//
//  THNPreViewTableViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/9/14.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNPreViewTableViewCell.h"
#import "THNSkuModelItem.h"
#import "UIImageView+WebImage.h"
#import <MJExtension/MJExtension.h>
#import "THNOrderDetailTableViewCell.h"
#import "THNCouponModel.h"
#import "THNSelectCouponView.h"
#import "UIView+Helper.h"
#import <UIKit/UIKit.h>
#import "UIColor+Extension.h"
#import "THNFreightModelItem.h"
#import "NSString+Helper.h"

NSString *const kNotSelectDesTitle = @"不可使用";

static NSString *const kPreViewOrderDetailCellIdentifier = @"kPreViewOrderDetailCellIdentifier";
const CGFloat kProductViewHeight = 90;
const CGFloat kLogisticsViewHeight = 83;

@interface THNPreViewTableViewCell()<
UITableViewDelegate,
UITableViewDataSource,
UITextFieldDelegate
>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *deliveryAddressLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *remarksView;
// 备注
@property (weak, nonatomic) IBOutlet UITextField *remarksTextField;
// 赠语
@property (weak, nonatomic) IBOutlet UIView *giftView;
@property (weak, nonatomic) IBOutlet UITextField *giftTextField;
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;
@property (weak, nonatomic) IBOutlet UIView *couponView;
// 满减
@property (weak, nonatomic) IBOutlet UILabel *fullReductionLabel;
@property (weak, nonatomic) IBOutlet UIView *fullReductionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fullReductionViewHeightConstraint;
@property (nonatomic, strong) THNSelectCouponView *selectCouponView;
@property (weak, nonatomic) IBOutlet UIButton *selectCouponButton;
@property (nonatomic, strong) NSArray *skus;
@property (nonatomic, strong) NSArray *itemSkus;
// 优惠卷
@property (nonatomic, strong) NSArray *storeInformations;
// 物流公司名字
@property (nonatomic, strong) NSString *logisticsName;
// 默认物流
@property (nonatomic, strong) NSArray *defaultLogistics;
// 所有物流数组
@property (nonatomic, strong) NSArray *products;

@end

@implementation THNPreViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.tableView registerNib:[UINib nibWithNibName:@"THNOrderDetailTableViewCell" bundle:nil] forCellReuseIdentifier:kPreViewOrderDetailCellIdentifier];
    self.maskView.layer.cornerRadius = 4;
    self.giftView.layer.cornerRadius = 4;
    self.remarksView.layer.borderWidth = 0.5;
    self.giftView.layer.borderWidth = 0.5;
    self.remarksView.layer.borderColor = [UIColor colorWithHexString:@"E9E9E9"].CGColor;
    self.giftView.layer.borderColor = [UIColor colorWithHexString:@"E9E9E9"].CGColor;
    self.remarksTextField.delegate = self;
    self.giftTextField.delegate = self;
    self.giftTextField.returnKeyType = UIReturnKeyDone;
    self.remarksTextField.returnKeyType = UIReturnKeyDone;
}

- (CGFloat)setPreViewCell:(NSArray *)skus
         initWithItmeSkus:(NSArray *)itemSkus
      initWithCouponModel:(THNCouponModel *)fullReductionModel
          initWithFreight:(CGFloat)freight
initWithStoreInformations:(NSArray *)storeInformations
         initWithproducts:(NSArray *)products
           initWithRemark:(NSString *)remarkStr
             initWithGift:(NSString *)giftStr {

    self.remarksTextField.text = remarkStr;
    self.giftTextField.text = giftStr;
    NSArray *sortArr = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"fid" ascending:YES]];
    self.skus = [skus sortedArrayUsingDescriptors:sortArr];
    self.itemSkus = itemSkus;
    self.storeInformations = storeInformations;
    self.products = products;
    
    THNSkuModelItem *itemModel = [[THNSkuModelItem alloc]initWithDictionary:skus[0]];
    self.nameLabel.text = itemModel.storeName;
    
    if (itemModel.deliveryCountry.length == 0 || [itemModel.deliveryCountry isEqualToString:@"中国"]) {
        self.deliveryAddressLabel.text = [NSString stringWithFormat:@"从%@发货",itemModel.deliveryProvince];
    } else {
        self.deliveryAddressLabel.text = [NSString stringWithFormat:@"从%@,%@发货",itemModel.deliveryCountry,itemModel.deliveryProvince];
    }
    
    if (freight == 0) {
        self.freightLabel.text = @"包邮";
    } else {
        self.freightLabel.text = [NSString formatFloat:freight];
    }

    // 满减
    if (fullReductionModel.type_text.length == 0) {
        self.fullReductionViewHeightConstraint.constant = 0;
        self.fullReductionView.hidden = YES;
    } else {
        self.fullReductionView.hidden = NO;
        self.fullReductionViewHeightConstraint.constant = 40;
        self.fullReductionLabel.text = fullReductionModel.type_text;
    }

    NSMutableArray *coupons = [NSMutableArray array];
    for (NSDictionary *storeDict in self.storeInformations) {
        [coupons addObject:storeDict[@"coupon"]];
    }
    
    switch (self.couponStyleType) {
        case ShowCouponStyleTypeAmount:
            if (coupons.count > 0) {
                 self.couponLabel.text = [NSString stringWithFormat:@"已抵%@",[NSString formatFloat:self.selectStoreAmount]];
            }
            self.couponLabel.textColor = [UIColor colorWithHexString:@"FF6666"];
            self.selectCouponButton.enabled = YES;
            break;
        case ShowCouponStyleTypeUnavailable:
            self.couponLabel.text = @"不可使用";
            self.couponLabel.textColor = [UIColor colorWithHexString:@"999999"];
            self.selectCouponButton.enabled = NO;
            break;
        case ShowCouponStyleTypeNotavailable:
            self.couponLabel.text = @"无可用优惠券";
            self.couponLabel.textColor = [UIColor colorWithHexString:@"999999"];
            self.selectCouponButton.enabled = NO;
            break;
        case ShowCouponStyleTypeQuantityAvailable:
            self.couponLabel.text =  [NSString stringWithFormat:@"%ld个优惠券可用", coupons.count];
            self.couponLabel.textColor = [UIColor colorWithHexString:@"FF6666"];
            self.selectCouponButton.enabled = YES;
            break;
    }
    
    return self.fullReductionViewHeightConstraint.constant;
}


- (IBAction)selectCouponButton:(id)sender {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.selectCouponView.frame = window.bounds;
    self.selectCouponView.coupons = self.storeInformations;
    __weak typeof(self)weakSelf = self;
    
    self.selectCouponView.selectCouponBlock = ^(NSString *text, THNCouponModel *couponModel) {

        weakSelf.couponLabel.text = text;
        weakSelf.couponLabel.textColor = [UIColor colorWithHexString:@"FF6666"];

        if (weakSelf.delagate && [weakSelf.delagate respondsToSelector:@selector(updateTotalCouponAcount:withCode:withTag:)]) {
            [weakSelf.delagate updateTotalCouponAcount:couponModel.amount withCode:couponModel.code withTag:weakSelf.tag];
        }
    };
    

    [window addSubview:self.selectCouponView];
}

- (void)setFrame:(CGRect)frame {
    frame.origin.y += 10;
    frame.size.height -= 10;
    [super setFrame:frame];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.skus.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNOrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPreViewOrderDetailCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = indexPath.row;

     __weak typeof(self)weakSelf = self;
    cell.selectDeliveryBlcok = ^(NSString *fid) {
        NSMutableArray *skuIds = [NSMutableArray array];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fid == %@",fid];
        NSArray *fidForItems = [weakSelf.skus filteredArrayUsingPredicate:predicate];
        
        for (NSDictionary *dict in fidForItems) {
           [skuIds addObject:dict[@"rid"]];
        }

        if (weakSelf.delagate && [weakSelf.delagate respondsToSelector:@selector(selectLogistic:WithFid:withStoreIndex:)]) {
            [weakSelf.delagate selectLogistic:skuIds WithFid:fid withStoreIndex:weakSelf.tag];
        }
        
    };
    
    THNSkuModelItem *itemModel = [[THNSkuModelItem alloc]initWithDictionary:self.skus[indexPath.row]];
    // 最后一行不隐藏运费模板
    if (indexPath.row < self.skus.count - 1) {
        // 该商品后面运费模板一样，隐藏选择运费模板
        if ([itemModel.fid isEqualToString:self.skus[indexPath.row + 1][@"fid"]]) {
            
            cell.logisticsView.hidden = YES;
        } else {
            cell.logisticsView.hidden = NO;
        }
    } else {
        cell.logisticsView.hidden = NO;
    }
    
    [cell setSkuItemModel:itemModel];


    cell.productCountLabel.text = [NSString stringWithFormat:@"x%@",self.itemSkus[indexPath.row][@"quantity"]];
    NSString *ridKey = itemModel.rid;
    NSArray *expressArray = self.products[indexPath.row][ridKey][@"express"];
    cell.selectDeliveryButton.hidden = expressArray.count == 1 ?: NO;
    // 筛选出默认物流
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"is_default = YES"];
    self.defaultLogistics = [expressArray filteredArrayUsingPredicate:predicate];
    
    if (self.defaultLogistics.count > 0) {
        
        THNFreightModelItem *freightModel = [[THNFreightModelItem alloc]initWithDictionary: self.defaultLogistics[0]];
        [cell setFreightModel:freightModel];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNSkuModelItem *itemModel = [[THNSkuModelItem alloc]initWithDictionary:self.skus[indexPath.row]];
    
    if (indexPath.row < self.skus.count - 1) {
        // 该商品后面运费模板一样，设置为商品的高度
        if ([itemModel.fid isEqualToString:self.skus[indexPath.row + 1][@"fid"]]) {
            return kProductViewHeight;
        } else {
            return kProductViewHeight + kLogisticsViewHeight;
        }
    } else {
        return kProductViewHeight + kLogisticsViewHeight;
    }
    
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.delagate && [self.delagate respondsToSelector:@selector(setRemarkWithGift:withGift:withTag:)]) {
        [self.delagate setRemarkWithGift:self.remarksTextField.text withGift:self.giftTextField.text withTag:self.tag];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - lazy
- (THNSelectCouponView *)selectCouponView {
    if (!_selectCouponView) {
        _selectCouponView = [THNSelectCouponView viewFromXib];
    }
    return _selectCouponView;
}

@end
