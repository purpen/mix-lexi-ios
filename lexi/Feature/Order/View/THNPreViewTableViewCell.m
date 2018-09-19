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

static NSString *const kPreViewOrderDetailCellIdentifier = @"kPreViewOrderDetailCellIdentifier";

@interface THNPreViewTableViewCell()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *deliveryAddressLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
// 备注
@property (weak, nonatomic) IBOutlet UITextField *remarksTextField;
// 赠语
@property (weak, nonatomic) IBOutlet UITextField *giftTextField;
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;
@property (weak, nonatomic) IBOutlet UIView *couponView;
// 运费
@property (weak, nonatomic) IBOutlet UILabel *freightLabel;
// 满减
@property (weak, nonatomic) IBOutlet UILabel *fullReductionLabel;
@property (weak, nonatomic) IBOutlet UIView *fullReductionView;
@property (nonatomic, strong) THNSelectCouponView *selectCouponView;
@property (nonatomic, strong) NSArray *skus;
@property (nonatomic, strong) NSArray *itemSkus;
// 优惠卷
@property (nonatomic, strong) NSArray *coupons;
// 物流公司名字
@property (nonatomic, strong) NSString *logisticsName;

@property (nonatomic, strong) THNFreightModelItem *freightModel;

@end

@implementation THNPreViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.tableView registerNib:[UINib nibWithNibName:@"THNOrderDetailTableViewCell" bundle:nil] forCellReuseIdentifier:kPreViewOrderDetailCellIdentifier];
}


- (CGFloat)setPreViewCell:(NSArray *)skus initWithItmeSkus:(NSArray *)itemSkus initWithCouponModel:(THNCouponModel *)couponModel initWithFreight:(CGFloat)freight initWithCoupons:(NSArray *)coupons initWithLogisticsNames:(THNFreightModelItem *)freightModel {
    
    NSArray *sortArr = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"fid" ascending:YES]];
    self.skus = [skus sortedArrayUsingDescriptors:sortArr];
    self.itemSkus = self.itemSkus;
    self.coupons = coupons;
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

    if (couponModel.type_text.length == 0) {
        self.fullReductionView.hidden = YES;
    } else {
        self.fullReductionView.hidden = NO;
        self.fullReductionLabel.text = couponModel.type_text;
    }
    
    if (self.coupons.count > 0) {
        self.couponLabel.text = [NSString stringWithFormat:@"有%ld张可用",self.coupons.count];
    } else {
        self.couponLabel.text = @"当前没有优惠券";
    }
    
    
    self.freightModel = freightModel;
    
    return freight - couponModel.amount;
}

- (IBAction)selectCouponButton:(id)sender {
    
    if (self.coupons.count == 0) {
        return;
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.selectCouponView.frame = window.bounds;
    self.selectCouponView.coupons = self.coupons;
    __weak typeof(self)weakSelf = self;
    
    self.selectCouponView.selectCouponBlock = ^(NSString *text) {
        weakSelf.couponLabel.text = text;
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
     THNSkuModelItem *itemModel = [[THNSkuModelItem alloc]initWithDictionary:self.skus[indexPath.row]];
    [cell setSkuItemModel:itemModel];
    [cell setFreightModel:self.freightModel];
    cell.productCountLabel.text = [NSString stringWithFormat:@"x%@",self.itemSkus[indexPath.row][@"quantity"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 155;
}

#pragma mark - lazy
- (THNSelectCouponView *)selectCouponView {
    if (!_selectCouponView) {
        _selectCouponView = [THNSelectCouponView viewFromXib];
    }
    return _selectCouponView;
}

@end
