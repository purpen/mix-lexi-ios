//
//  THNLifeCashBillView.m
//  lexi
//
//  Created by FLYang on 2018/10/8.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNLifeCashBillView.h"
#import <Masonry/Masonry.h>
#import "UIView+Helper.h"
#import "UIColor+Extension.h"

static NSString *const kTextBill    = @"对账单";
static NSString *const kTextNone    = @"无提现记录";
static NSString *const kTextRecent  = @"最近一笔提现";

@interface THNLifeCashBillView ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *subTextLabel;
@property (nonatomic, strong) UIImageView *nextImageView;

@end

@implementation THNLifeCashBillView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

- (void)thn_setLifeCashRecentPrice:(CGFloat)price {
    self.subTextLabel.text = price <= 0 ? kTextNone : [NSString stringWithFormat:@"%@%.2f", kTextRecent, price];
}

#pragma mark - event response
- (void)checkBillAction:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(thn_checkLifeCashBill)]) {
        [self.delegate thn_checkLifeCashBill];
    }
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkBillAction:)];
    [self addGestureRecognizer:tap];
    
    [self addSubview:self.iconImageView];
    [self addSubview:self.nextImageView];
    [self addSubview:self.textLabel];
    [self addSubview:self.subTextLabel];
}

- (void)updateConstraints {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.left.mas_equalTo(20);
        make.centerY.equalTo(self);
    }];
    
    [self.nextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(7, 13));
        make.right.mas_equalTo(-20);
        make.centerY.equalTo(self);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 15));
        make.left.mas_equalTo(45);
        make.centerY.equalTo(self);
    }];
    
    [self.subTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(15);
        make.right.mas_equalTo(-37);
        make.left.equalTo(self.textLabel.mas_right).with.offset(10);
        make.centerY.equalTo(self);
    }];
    
    [super updateConstraints];
}

#pragma mark - getters and setters
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_bill"]];
    }
    return _iconImageView;
}

- (UIImageView *)nextImageView {
    if (!_nextImageView) {
        _nextImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow_gray"]];
        _nextImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _nextImageView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.text = kTextBill;
        _textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _textLabel.font = [UIFont systemFontOfSize:14];
    }
    return _textLabel;
}

- (UILabel *)subTextLabel {
    if (!_subTextLabel) {
        _subTextLabel = [[UILabel alloc] init];
        _subTextLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _subTextLabel.font = [UIFont systemFontOfSize:12];
        _subTextLabel.textAlignment = NSTextAlignmentRight;
    }
    return _subTextLabel;
}

@end
