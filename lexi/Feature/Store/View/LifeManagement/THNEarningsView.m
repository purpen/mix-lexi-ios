//
//  THNEarningsView.m
//  lexi
//
//  Created by FLYang on 2018/10/7.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNEarningsView.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>
#import "UIView+Helper.h"
#import "UIColor+Extension.h"

static NSString *const kTextTitle       = @"生活馆累计收益";
static NSString *const kTextTitleSub    = @"（元）";
static NSString *const kTextTotay       = @"今日：";
static NSString *const kTextWait        = @"待结算：";

@interface THNEarningsView ()

// 数据
@property (nonatomic, strong) THNLifeSaleCollectModel *saleModel;
// 背景
@property (nonatomic, strong) UIView *backgroundColorView;
// 标题
@property (nonatomic, strong) YYLabel *titleLabel;
// 显示金额按钮
@property (nonatomic, strong) UIButton *showButton;
// 总收益
@property (nonatomic, strong) UILabel *totalLabel;
// 今日收益
@property (nonatomic, strong) UILabel *todayLabel;
// 待结算收益
@property (nonatomic, strong) UILabel *waitLabel;
// 待结算提示
@property (nonatomic, strong) UIButton *waitHintButton;
// 分割线
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *cutLineView;

@end

@implementation THNEarningsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

- (void)thn_setLifeSaleColleciton:(THNLifeSaleCollectModel *)model {
    self.saleModel = model;
    
    self.totalLabel.text = [NSString stringWithFormat:@"%.2f", model.total_commission_price];
    self.todayLabel.text = [NSString stringWithFormat:@"%@%.2f", kTextTotay, model.today_commission_price];
    self.waitLabel.text = [NSString stringWithFormat:@"%@%.2f", kTextWait, model.pending_commission_price];
}

#pragma mark - event response
- (void)selfAction:(UITapGestureRecognizer *)gesture {
    if ([self.delegate respondsToSelector:@selector(thn_checkLifeTransactionRecord)]) {
        [self.delegate thn_checkLifeTransactionRecord];
    }
}

- (void)showButtonAction:(UIButton *)button {
    if (button.selected) {
        [self thn_setLifeSaleColleciton:self.saleModel];
        
    } else {
        self.totalLabel.text = @"＊＊＊＊";
        self.todayLabel.text = [NSString stringWithFormat:@"%@＊＊＊", kTextTotay];
        self.waitLabel.text = [NSString stringWithFormat:@"%@＊＊＊", kTextWait];
    }
    
    self.showButton.selected = !button.selected;
}

- (void)waitHintButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_showCashHintText)]) {
        [self.delegate thn_showCashHintText];
    }
}

#pragma mark - setup UI
- (void)setupViewUI {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfAction:)];
    [self addGestureRecognizer:tap];
    
    [self addSubview:self.backgroundColorView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.showButton];
    [self addSubview:self.totalLabel];
    [self addSubview:self.cutLineView];
    [self addSubview:self.todayLabel];
    [self addSubview:self.waitLabel];
    [self addSubview:self.waitHintButton];
    [self addSubview:self.lineView];
    
    [self setMasonryLayout];
}

- (void)setMasonryLayout {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(150, 15));
        make.centerX.equalTo(self);
    }];
    
    [self.showButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-15);
    }];
    
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(15);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(26);
    }];
    
    [self.cutLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.totalLabel.mas_bottom).with.offset(15);
        make.height.mas_equalTo(1);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(1, 12));
        make.bottom.mas_equalTo(-17);
        make.centerX.equalTo(self);
    }];
    
    [self.todayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.equalTo(self.lineView.mas_left).with.offset(-20);
        make.bottom.mas_equalTo(-17);
    }];
    
    [self.waitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-50);
        make.left.equalTo(self.lineView.mas_right).with.offset(20);
        make.bottom.mas_equalTo(-17);
    }];
    
    [self.waitHintButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(17, 17));
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-16);
    }];
}

#pragma mark - getters and setters
- (YYLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[YYLabel alloc] init];
        
        NSMutableAttributedString *titleAtt = [[NSMutableAttributedString alloc] initWithString:kTextTitle];
        titleAtt.color = [UIColor colorWithHexString:@"#FFFFFF"];
        titleAtt.font = [UIFont systemFontOfSize:14];
        titleAtt.alignment = NSTextAlignmentCenter;
        
        NSMutableAttributedString *titleSubAtt = [[NSMutableAttributedString alloc] initWithString:kTextTitleSub];
        titleSubAtt.color = [UIColor colorWithHexString:@"#FFFFFF"];
        titleSubAtt.font = [UIFont systemFontOfSize:12];
        
        [titleAtt appendAttributedString:titleSubAtt];
        _titleLabel.attributedText = titleAtt;
    }
    return _titleLabel;
}

- (UIButton *)showButton {
    if (!_showButton) {
        _showButton = [[UIButton alloc] init];
        [_showButton setImage:[UIImage imageNamed:@"icon_eye_open_white"] forState:(UIControlStateNormal)];
        [_showButton setImage:[UIImage imageNamed:@"icon_eye_close_white"] forState:(UIControlStateSelected)];
        _showButton.selected = NO;
        [_showButton addTarget:self action:@selector(showButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _showButton;
}

- (UILabel *)totalLabel {
    if (!_totalLabel) {
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.font = [UIFont systemFontOfSize:24 weight:(UIFontWeightSemibold)];
        _totalLabel.textColor = [UIColor whiteColor];
        _totalLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalLabel;
}

- (UILabel *)todayLabel {
    if (!_todayLabel) {
        _todayLabel = [[UILabel alloc] init];
        _todayLabel.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
        _todayLabel.textColor = [UIColor whiteColor];
        _todayLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _todayLabel;
}

- (UILabel *)waitLabel {
    if (!_waitLabel) {
        _waitLabel = [[UILabel alloc] init];
        _waitLabel.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
        _waitLabel.textColor = [UIColor whiteColor];
        _waitLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _waitLabel;
}

- (UIButton *)waitHintButton {
    if (!_waitHintButton) {
        _waitHintButton = [[UIButton alloc] init];
        [_waitHintButton setImage:[UIImage imageNamed:@"icon_hint_white"] forState:(UIControlStateNormal)];
        [_waitHintButton addTarget:self action:@selector(waitHintButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _waitHintButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor whiteColor];
    }
    return _lineView;
}

- (UIView *)cutLineView {
    if (!_cutLineView) {
        _cutLineView = [[UIView alloc] init];
        _cutLineView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.2];
    }
    return _cutLineView;
}

- (UIView *)backgroundColorView {
    if (!_backgroundColorView) {
        _backgroundColorView = [[UIView alloc] initWithFrame: \
                                CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        
        UIView *colorView = [[UIView alloc] initWithFrame:_backgroundColorView.bounds];
        [colorView.layer addSublayer:[UIColor colorGradientWithView:self colors:@[@"#2785FA", @"#539EFB"]]];
        colorView.layer.cornerRadius = 4;
        colorView.layer.masksToBounds = YES;
        
        _backgroundColorView.layer.shadowColor = [UIColor colorWithHexString:@"#000000" alpha:0.1].CGColor;
        _backgroundColorView.layer.shadowOffset = CGSizeMake(0, 0);
        _backgroundColorView.layer.shadowRadius = 4;
        _backgroundColorView.layer.shadowOpacity = 1;
        
        [_backgroundColorView addSubview:colorView];
    }
    return _backgroundColorView;
}

@end
