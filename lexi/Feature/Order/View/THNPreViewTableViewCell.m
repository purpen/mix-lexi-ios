//
//  THNPreViewTableViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/9/14.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNPreViewTableViewCell.h"
#import "THNSkuModelItem.h"
#import "UIImageView+WebCache.h"
#import <MJExtension/MJExtension.h>
#import "THNOrderDetailTableViewCell.h"
#import "THNCouponModel.h"
#import "THNSelectCouponView.h"
#import "UIView+Helper.h"
#import <UIKit/UIKit.h>
#import "UIColor+Extension.h"
#import "THNFreightModelItem.h"

static NSString *const kPreViewOrderDetailCellIdentifier = @"kPreViewOrderDetailCellIdentifier";
const CGFloat kProductViewHeight = 85;
const CGFloat kLogisticsViewHeight = 65;

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
// 运费
@property (weak, nonatomic) IBOutlet UILabel *freightLabel;
// 满减
@property (weak, nonatomic) IBOutlet UILabel *fullReductionLabel;
@property (weak, nonatomic) IBOutlet UIView *fullReductionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fullReductionViewHeightConstraint;
@property (nonatomic, strong) THNSelectCouponView *selectCouponView;
@property (nonatomic, strong) NSArray *skus;
@property (nonatomic, strong) NSArray *itemSkus;
// 优惠卷
@property (nonatomic, strong) NSArray *coupons;
// 物流公司名字
@property (nonatomic, strong) NSString *logisticsName;
// 默认物流
@property (nonatomic, strong) NSArray *defaultLogistics;

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
}


- (CGFloat)setPreViewCell:(NSArray *)skus
         initWithItmeSkus:(NSArray *)itemSkus
      initWithCouponModel:(THNCouponModel *)couponModel
          initWithFreight:(CGFloat)freight
          initWithCoupons:(NSArray *)coupons
        initWithLogistics:(NSArray *)defaultLogistics
           initWithRemark:(NSString *)remarkStr
             initWithGift:(NSString *)giftStr {

    self.remarksTextField.text = remarkStr;
    self.giftTextField.text = giftStr;
    NSArray *sortArr = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"fid" ascending:YES]];
    self.skus = [skus sortedArrayUsingDescriptors:sortArr];
    self.itemSkus = itemSkus;
    self.coupons = coupons;
    self.defaultLogistics = defaultLogistics;
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
        self.freightLabel.text = [NSString stringWithFormat:@"¥%.2f",freight];
    }

    // 满减
    if (couponModel.type_text.length == 0) {
        self.fullReductionViewHeightConstraint.constant = 0;
        self.fullReductionView.hidden = YES;
    } else {
        self.fullReductionView.hidden = NO;
        self.fullReductionViewHeightConstraint.constant = 40;
        self.fullReductionLabel.text = couponModel.type_text;
    }

    NSMutableArray *newCoupons = [NSMutableArray array];
    for (NSDictionary *storeDict in self.coupons) {
        [newCoupons addObject:storeDict[@"coupon"]];
    }

    // 每个店铺的优惠券数组降序，取出最大面值的优惠券金额
    NSArray *amountSortArr = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"amount" ascending:NO]];
    NSArray *storeCoupons = [newCoupons sortedArrayUsingDescriptors:amountSortArr];

    
    if (storeCoupons.count > 0) {
        self.couponLabel.text = [NSString stringWithFormat:@"已抵扣%.2f",[storeCoupons[0][@"amount"] floatValue]];
    } else {
        self.couponLabel.text = @"当前没有优惠券";
    }
    
    
    self.defaultLogistics = defaultLogistics;
    
    return self.fullReductionViewHeightConstraint.constant;
}

- (IBAction)selectCouponButton:(id)sender {
    
    if (self.coupons.count == 0) {
        return;
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.selectCouponView.frame = window.bounds;
    self.selectCouponView.coupons = self.coupons;
    __weak typeof(self)weakSelf = self;
    
    self.selectCouponView.selectCouponBlock = ^(NSString *text, CGFloat couponAcount, NSString *code) {

        CGFloat couponSpread = couponAcount - [[weakSelf.couponLabel.text substringFromIndex:3] floatValue];
        weakSelf.couponLabel.text = text;

        if (weakSelf.delagate && [self.delagate respondsToSelector:@selector(updateTotalCouponAcount:withCode:withTag:)]) {
            [weakSelf.delagate updateTotalCouponAcount:couponSpread withCode:code withTag:weakSelf.tag];
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
            [weakSelf.delagate selectLogistic:skuIds WithFid:fid withStoreIndex:self.tag];
        }
        
    };
    
    THNSkuModelItem *itemModel = [[THNSkuModelItem alloc]initWithDictionary:self.skus[indexPath.row]];
    
    // 最后一行不隐藏运费模板
    if (indexPath.row < self.skus.count - 1) {
        // 该商品后面运费模板一样，隐藏选择运费模板
        if (itemModel.fid == self.skus[indexPath.row + 1][@"fid"]) {
            
            cell.logisticsView.hidden = YES;
        } else {
            cell.logisticsView.hidden = NO;
        }
    } else {
        cell.logisticsView.hidden = NO;
    }
    
    [cell setSkuItemModel:itemModel];


    cell.productCountLabel.text = [NSString stringWithFormat:@"x%@",self.itemSkus[indexPath.row][@"quantity"]];

    if (self.defaultLogistics.count > 0) {
        THNFreightModelItem *freightModel = [[THNFreightModelItem alloc]initWithDictionary: self.defaultLogistics[indexPath.row]];
        [cell setFreightModel:freightModel];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNSkuModelItem *itemModel = [[THNSkuModelItem alloc]initWithDictionary:self.skus[indexPath.row]];
    
    if (indexPath.row < self.skus.count - 1) {
        // 该商品后面运费模板一样，设置为商品的高度
        if (itemModel.fid == self.skus[indexPath.row + 1][@"fid"]) {
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
