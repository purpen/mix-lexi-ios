//
//  THNLifeHintView.m
//  lexi
//
//  Created by FLYang on 2018/10/7.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNLifeHintView.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>
#import "UIView+Helper.h"
#import "UIColor+Extension.h"

static NSString *const kTextTitle       = @"成功在30天内售出3笔订单即可成为正式馆主";
static NSString *const kTextHintFirst   = @"未达销售指标生活馆将被冻结并关闭。";
static NSString *const kTextHintSecond  = @"已产生交易的订单收益将无法提现。";
static NSString *const kTextHintWechat  = @"  关注“乐喜生活馆”公众号随时接收订单和收益通知";

@interface THNLifeHintView ()

// 边框背景
@property (nonatomic, strong) UIView *borderView;
// 标题
@property (nonatomic, strong) YYLabel *titleLabel;
// 微信提示内容
@property (nonatomic, strong) UIButton *hintWechatButton;

@end

@implementation THNLifeHintView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

#pragma mark - event response
- (void)hintWechatButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_checkWechatInfo)]) {
        [self.delegate thn_checkWechatInfo];
    }
}

#pragma mark - private methods
- (void)thn_setHintContentWithTexts:(NSArray *)texts {
    for (NSUInteger idx = 0; idx < texts.count; idx ++) {
        YYLabel *hintLabel = [[YYLabel alloc] initWithFrame:CGRectMake(45, 53 + 18 * idx, 220, 15)];
        hintLabel.font = [UIFont systemFontOfSize:12];
        hintLabel.textColor = [UIColor colorWithHexString:@"#555555"];
        hintLabel.text = texts[idx];
        [self addSubview:hintLabel];
        
        UILabel *symbolLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 51 + 19 * idx, 10, 15)];
        symbolLabel.font = [UIFont systemFontOfSize:30 weight:(UIFontWeightSemibold)];
        symbolLabel.textColor = [UIColor colorWithHexString:@"#5FE4B1"];
        symbolLabel.text = @"·";
        [self addSubview:symbolLabel];
    }
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.borderView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.hintWechatButton];
    [self thn_setHintContentWithTexts:@[kTextHintFirst, kTextHintSecond]];
    
    [self setMasonryLayout];
}

- (void)setMasonryLayout {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(35);
        make.top.mas_equalTo(30);
        make.right.mas_equalTo(-35);
        make.height.mas_equalTo(15);
    }];
    
    [self.hintWechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(35);
        make.bottom.mas_equalTo(-30);
        make.right.mas_equalTo(-35);
        make.height.mas_equalTo(28);
    }];
}

- (void)drawRect:(CGRect)rect {
    [UIView drawRectLineStart:CGPointMake(0, CGRectGetHeight(self.frame))
                          end:CGPointMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))
                        width:1
                        color:[UIColor colorWithHexString:@"#E9E9E9"]];
}

#pragma mark - getters and setters
- (UIView *)borderView {
    if (!_borderView) {
        _borderView = [[UIView alloc] initWithFrame:CGRectMake(20, 15, CGRectGetWidth(self.frame) - 40, CGRectGetHeight(self.frame) - 30)];
        _borderView.backgroundColor = [UIColor whiteColor];
        
        CAShapeLayer *border = [CAShapeLayer layer];
        border.strokeColor = [UIColor colorWithHexString:@"#E9E9E9"].CGColor;
        border.fillColor = [UIColor clearColor].CGColor;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_borderView.bounds cornerRadius:4];
        border.path = path.CGPath;
        border.frame = _borderView.bounds;
        border.lineWidth = 2.0;
        border.lineDashPattern = @[@4, @2];
        
        _borderView.layer.cornerRadius = 5.f;
        _borderView.layer.masksToBounds = YES;
        
        [_borderView.layer addSublayer:border];
    }
    return _borderView;
}

- (YYLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[YYLabel alloc] init];
        _titleLabel.text = kTextTitle;
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _titleLabel;
}

- (UIButton *)hintWechatButton {
    if (!_hintWechatButton) {
        _hintWechatButton = [[UIButton alloc] init];
        _hintWechatButton.backgroundColor = [UIColor colorWithHexString:@"#FB880C" alpha:0.2];
        [_hintWechatButton setTitle:kTextHintWechat forState:(UIControlStateNormal)];
        [_hintWechatButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateNormal)];
        _hintWechatButton.titleLabel.font = [UIFont systemFontOfSize:11];
        [_hintWechatButton setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentLeft)];
        [_hintWechatButton setImage:[UIImage imageNamed:@"icon_arrow_right_gray"] forState:(UIControlStateNormal)];
        [_hintWechatButton setImageEdgeInsets:(UIEdgeInsetsMake(0, kScreenWidth - 85, 0, 0))];
        _hintWechatButton.layer.cornerRadius = 14;
        _hintWechatButton.layer.masksToBounds = YES;
        [_hintWechatButton addTarget:self action:@selector(hintWechatButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _hintWechatButton;
}

@end
