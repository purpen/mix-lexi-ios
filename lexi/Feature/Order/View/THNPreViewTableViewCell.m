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
@property (nonatomic, strong) NSArray *skus;
@property (nonatomic, strong) NSArray *itemSkus;

@end

@implementation THNPreViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.tableView registerNib:[UINib nibWithNibName:@"THNOrderDetailTableViewCell" bundle:nil] forCellReuseIdentifier:kPreViewOrderDetailCellIdentifier];
}


- (void)setPreViewCell:(NSArray *)skus initWithItmeSkus:(NSArray *)itemSkus initWithCouponModel:(THNCouponModel *)couponModel {
    self.skus = skus;
    self.itemSkus = itemSkus;
    THNSkuModelItem *itemModel = [[THNSkuModelItem alloc]initWithDictionary:skus[0]];
    self.nameLabel.text = itemModel.storeName;
    
    if (itemModel.deliveryCountry.length == 0 || [itemModel.deliveryCountry isEqualToString:@"中国"]) {
        self.deliveryAddressLabel.text = [NSString stringWithFormat:@"从%@发货",itemModel.deliveryProvince];
    } else {
        self.deliveryAddressLabel.text = [NSString stringWithFormat:@"从%@,%@发货",itemModel.deliveryCountry,itemModel.deliveryProvince];
    }

    self.fullReductionLabel.text = couponModel.type_text;

}

- (IBAction)selectCouponButton:(id)sender {
    
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
    cell.tag = indexPath.row;
     THNSkuModelItem *itemModel = [[THNSkuModelItem alloc]initWithDictionary:self.skus[indexPath.row]];
    [cell setSkuItemModel:itemModel];
    cell.productCountLabel.text = [NSString stringWithFormat:@"x%@",self.itemSkus[indexPath.row][@"quantity"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 155;
}

@end
