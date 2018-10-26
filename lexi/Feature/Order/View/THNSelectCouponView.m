//
//  THNSelectCouponView.m
//  lexi
//
//  Created by HongpingRao on 2018/9/17.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSelectCouponView.h"
#import "THNSelectCouponTableViewCell.h"
#import "UIView+Helper.h"
#import <MJExtension/MJExtension.h>
#import "THNCouponModel.h"
#import "NSString+Helper.h"

static NSString *const kSelectCouponCellIdentifier = @"kSelectCouponCellIdentifier";

@interface THNSelectCouponView()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UILabel *couponMoneyLabel;
@property (nonatomic, strong) NSIndexPath *selectIndex;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) THNCouponModel *couponModel;

@end

@implementation THNSelectCouponView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.sureButton drawCornerWithType:0 radius:4];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 95;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"THNSelectCouponTableViewCell" bundle:nil] forCellReuseIdentifier:kSelectCouponCellIdentifier];
    self.selectIndex = [NSIndexPath indexPathForRow:0 inSection:0];
}

- (IBAction)cancel:(id)sender {
    [self remove];
}

- (void)remove {
    if (self.selectCouponBlock) {
        self.selectCouponBlock(self.couponMoneyLabel.text, self.couponModel.amount, self.couponModel.code);
    }
    [self removeFromSuperview];
}


- (IBAction)sure:(id)sender {
    [self remove];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.coupons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    THNSelectCouponTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [THNSelectCouponTableViewCell viewFromXib];
    }
  
    THNCouponModel *couponModel;
    
    if (self.couponType == CouponTypeStore) {
        NSString *startDate = [NSString timeConversion:self.coupons[indexPath.row][@"get_at"] initWithFormatterType:FormatterDay];
        NSString *endDate = [NSString timeConversion:self.coupons[indexPath.row][@"end_at"] initWithFormatterType:FormatterDay];
        cell.validityPeriodLabel.text = [NSString stringWithFormat:@"%@至%@",startDate,endDate];
        couponModel = [THNCouponModel mj_objectWithKeyValues:self.coupons[indexPath.row][@"coupon"]];
    } else {
        couponModel = [THNCouponModel mj_objectWithKeyValues:self.coupons[indexPath.row]];
    }
    
    cell.couponType = self.couponType;
    
    [cell setCouponModel:couponModel];
    
    if (indexPath == self.selectIndex) {
        self.couponMoneyLabel.text = [NSString stringWithFormat:@"已抵扣%.2f",couponModel.amount];
        cell.isSelect = YES;
        self.selectIndex = indexPath;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    THNSelectCouponTableViewCell *selectedCell = [tableView cellForRowAtIndexPath:self.selectIndex];
    selectedCell.isSelect = NO;
    
    THNSelectCouponTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.isSelect = YES;
    self.selectIndex = indexPath;
    THNCouponModel *couponModel;

    
    if (self.couponType == CouponTypeStore) {
        couponModel = [THNCouponModel mj_objectWithKeyValues:self.coupons[indexPath.row][@"coupon"]];
    } else {
        couponModel = [THNCouponModel mj_objectWithKeyValues:self.coupons[indexPath.row]];
    }

    if (couponModel) {
        self.couponModel = couponModel;

        self.couponMoneyLabel.text = [NSString stringWithFormat:@"已抵扣%.2f",couponModel.amount];
    }

}

@end