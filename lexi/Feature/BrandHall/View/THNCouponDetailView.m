//
//  THNCouponDetailView.m
//  lexi
//
//  Created by HongpingRao on 2018/9/3.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNCouponDetailView.h"
#import "UIView+Helper.h"
#import "THNLoginManager.h"
#import "THNCouponTableViewCell.h"
#import "UIColor+Extension.h"
#import "THNCouponModel.h"
#import <MJExtension/MJExtension.h>

static NSString *const kCouponCellIdentifier = @"kCouponCellIdentifier";

@interface THNCouponDetailView()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *finishButton;
@property (weak, nonatomic) IBOutlet UILabel *fullReductionLabel;
// 满减View
@property (weak, nonatomic) IBOutlet UIView *fullReductionView;
// 优惠券View
@property (weak, nonatomic) IBOutlet UIView *redEnvelopeView;
@property (nonatomic, strong) NSArray *loginCoupons;
@property (nonatomic, strong) NSArray *noLoginCoupons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *couponDetailViewHeightConstraint;

@end

@implementation THNCouponDetailView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.finishButton.layer.cornerRadius = 4;
}

- (void)layoutTableView {
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 90;
    [self.tableView registerNib:[UINib nibWithNibName:@"THNCouponTableViewCell" bundle:nil] forCellReuseIdentifier:kCouponCellIdentifier];
}

- (void)layoutCouponDetailView:(NSMutableString *)text withLoginCoupons:(NSArray *)loginCoupons withNologinCoupos:(NSArray *)noLoginCoupons {
    [self layoutTableView];
    self.loginCoupons = loginCoupons;
    self.noLoginCoupons = noLoginCoupons;
    if (text.length == 0) {
        self.fullReductionView.hidden = YES;
        self.couponDetailViewHeightConstraint.constant = 336;
        return;
    }
    self.fullReductionLabel.text = text;
   
}

- (void)layoutFullReductionLabelText:(NSMutableString *)text {
    self.fullReductionLabel.text = text;
    self.redEnvelopeView.hidden = YES;
    self.couponDetailViewHeightConstraint.constant = 132;
}

- (IBAction)finish:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)remove:(id)sender {
    
    [self removeFromSuperview];
}

-  (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     if ([THNLoginManager isLogin]) {
         return self.loginCoupons.count;
     } else {
         return self.noLoginCoupons.count;
     }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNCouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCouponCellIdentifier forIndexPath:indexPath];
    THNCouponModel *couponModel;
    if ([THNLoginManager isLogin]) {
        couponModel = [THNCouponModel mj_objectWithKeyValues:self.loginCoupons[indexPath.row]];
    } else {
        couponModel = [THNCouponModel mj_objectWithKeyValues:self.noLoginCoupons[indexPath.row]];
    }
    
    [cell setCouponModel:couponModel];
    return cell;
}

@end
