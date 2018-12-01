//
//  THNAdvertCouponView.m
//  lexi
//
//  Created by FLYang on 2018/11/27.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNAdvertCouponView.h"
#import <Masonry/Masonry.h>
#import "UIColor+Extension.h"
#import "THNMarco.h"
#import "THNAdvertCouponTableViewCell.h"

static NSString *const kAdvertCouponTableViewCellId = @"THNAdvertCouponTableViewCellId";

@interface THNAdvertCouponView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *couponView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UITableView *couponTable;
@property (nonatomic, strong) UIImageView *maskImageView;
@property (nonatomic, strong) UIButton *getButton;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) NSArray *couponData;

@end

@implementation THNAdvertCouponView

- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

#pragma mark - event response
- (void)getButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_advertGetCoupon)]) {
        [self.delegate thn_advertGetCoupon];
    }
}

- (void)closeButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_advertViewClose)]) {
        [self.delegate thn_advertViewClose];
    }
}

#pragma mark - tableView datasource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.couponData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNAdvertCouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAdvertCouponTableViewCellId];
    if (!cell) {
        cell = [[THNAdvertCouponTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault)
                                                   reuseIdentifier:kAdvertCouponTableViewCellId];
    }
    
    NSArray *coupon = self.couponData[indexPath.row];
    [cell thn_setAdvertCouponAmount:[coupon[0] floatValue] minAmount:[coupon[1] floatValue] typeText:coupon[2]];
    
    return cell;
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0];
    
    [self.couponView addSubview:self.bgImageView];
    [self.couponView addSubview:self.couponTable];
    [self.couponView addSubview:self.maskImageView];
    [self.couponView addSubview:self.getButton];
    [self addSubview:self.couponView];
    [self addSubview:self.closeButton];
    
    [self setMasonryLayout];
}

- (void)setMasonryLayout {
    [self.couponView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(300, 419));
        make.center.equalTo(self).centerOffset(CGPointMake(0, -10));
    }];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.couponView);
    }];
    
    [self.couponTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(95);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-83);
    }];
    
    [self.maskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(129);
        make.left.bottom.right.mas_equalTo(0);
    }];
    
    [self.getButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(235, 60));
        make.centerX.equalTo(self.couponView);
        make.bottom.mas_equalTo(-20);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(32, 32));
        make.centerX.equalTo(self);
        make.top.equalTo(self.couponView.mas_bottom).with.offset(15);
    }];
}

#pragma mark - getters and setters
- (UIView *)couponView {
    if (!_couponView) {
        _couponView = [[UIView alloc] init];
    }
    return _couponView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"advert_coupon_bg"]];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImageView;
}

- (UITableView *)couponTable {
    if (!_couponTable) {
        _couponTable = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _couponTable.delegate = self;
        _couponTable.dataSource = self;
        _couponTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _couponTable.showsVerticalScrollIndicator = NO;
        _couponTable.contentInset = UIEdgeInsetsMake(5, 0, 30, 0);
        _couponTable.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0];
    }
    return _couponTable;
}

- (UIImageView *)maskImageView {
    if (!_maskImageView) {
        _maskImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"advert_coupon_mask"]];
        _maskImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _maskImageView;
}

- (UIButton *)getButton {
    if (!_getButton) {
        _getButton = [[UIButton alloc] init];
        [_getButton setImage:[UIImage imageNamed:@"advert_coupon_get"] forState:(UIControlStateNormal)];
        [_getButton setImage:[UIImage imageNamed:@"advert_coupon_get"] forState:(UIControlStateHighlighted)];
        [_getButton addTarget:self action:@selector(getButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _getButton;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        [_closeButton setImage:[UIImage imageNamed:@"advert_coupon_close"] forState:(UIControlStateNormal)];
        [_closeButton setImage:[UIImage imageNamed:@"advert_coupon_close"] forState:(UIControlStateHighlighted)];
        [_closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeButton;
}

#pragma mark 新人1000元优惠券
- (NSArray *)couponData {
    if (!_couponData) {
        /**
         0: 优惠券金额； 1: 最低消费金额； 2: 使用条件
         */
        _couponData = @[@[@(5),    @(10),  @"限艺术作品类"],
                        @[@(10),   @(11),  @"限亲子用品类"],
                        @[@(25),   @(259), @"限鞋袜商品"],
                        @[@(30),   @(299), @"限文具商品"],
                        @[@(30),   @(199), @"全场通用"],
                        @[@(30),   @(299), @"限宠物商品"],
                        @[@(35),   @(299), @"全场通用"],
                        @[@(35),   @(359), @"限箱包商品"],
                        @[@(40),   @(399), @"限饰品商品"],
                        @[@(70),   @(599), @"全场通用"],
                        @[@(80),   @(899), @"限饰品商品"],
                        @[@(100),  @(999), @"全场通用"],
                        @[@(210),  @(1999), @"全场通用"],
                        @[@(300),  @(2999), @"全场通用"]];
    }
    return _couponData;
}

@end
