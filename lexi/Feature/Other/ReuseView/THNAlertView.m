//
//  THNAlertView.m
//  lexi
//
//  Created by FLYang on 2018/10/18.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNAlertView.h"
#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>
#import "YYLabel+Helper.h"
#import "UIColor+Extension.h"
#import "UIView+Helper.h"
#import "THNConst.h"

#define CURRENT_WINDOW [[UIApplication sharedApplication].windows firstObject]

static CGFloat const MAX_WIDTH              = 315.0f;
static CGFloat const ACTION_BUTTON_HEIGHT   = 50.0f;
static NSInteger const kActionButtonTag     = 1951;

@interface THNAlertView ()

@property (nonatomic, strong) UIView *containerView;

/// 文字内容
@property (nonatomic, strong) YYLabel *titleLable;
@property (nonatomic, strong) YYLabel *messageLabel;

/// 操作按钮
@property (nonatomic, strong) UIView *buttonContainerView;
@property (nonatomic, strong) NSMutableArray *buttonArr;
@property (nonatomic, strong) NSMutableArray *buttonTitleArr;

@end

@implementation THNAlertView

- (instancetype)initAlertViewTitle:(NSString *)title message:(NSString *)message {
    self = [super init];
    if (self) {
        [self setupViewUI];
        
        [self setTitleLableText:title];
        [self setMessageLabelText:message];
    }
    return self;
}

+ (instancetype)initAlertViewTitle:(NSString *)title message:(NSString *)message {
    return [[self alloc] initAlertViewTitle:title message:message];
}

#pragma mark - public methods
- (void)addActionButtonWithTitle:(NSString *)title handler:(ActionButtonHandler)handler {
    NSString *actionTitle = title.length ? title : @"确定";
    
    [self addActionButtonWithTitles:@[actionTitle] style:(THNAlertViewStyleAlert) handler:handler];
}

- (void)addActionButtonWithTitles:(NSArray *)titles handler:(ActionButtonHandler)handler {
    [self addActionButtonWithTitles:titles style:self.alertViewStyle handler:handler];
}

- (void)addActionButtonWithTitles:(NSArray *)titles style:(THNAlertViewStyle)style handler:(ActionButtonHandler)handler {
    self.alertViewStyle = style;
    [self.buttonTitleArr addObjectsFromArray:titles];
    [self createActionButtonWithTitles:self.buttonTitleArr];
    self.actionButtonHandler = handler;
    
    [self setNeedsUpdateConstraints];
}

- (void)show {
    if (!self.superview) {
        [CURRENT_WINDOW addSubview:self];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.transform = CGAffineTransformIdentity;
        self.containerView.alpha = 1;
    }];
}

- (void)dismiss {
    if (self.superview) {
        [UIView animateWithDuration:0.3 animations:^{
            self.containerView.transform = CGAffineTransformScale(self.containerView.transform, 0.1, 0.1);
            self.containerView.alpha = 0;
            
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

#pragma mark - event response
- (void)thn_createButtonAction:(UIButton *)button {
    NSInteger index = button.tag - kActionButtonTag;
    
    if (self.actionButtonHandler) {
        self.actionButtonHandler(button, index);
    }
    
    [self dismiss];
}

#pragma mark - private methods
/**
 标题
 */
- (void)setTitleLableText:(NSString *)text {
    NSMutableAttributedString *textAtt = [[NSMutableAttributedString alloc] initWithString:text];
    textAtt.lineSpacing = 5;
    textAtt.alignment = NSTextAlignmentCenter;
    textAtt.font = [UIFont systemFontOfSize:18 weight:(UIFontWeightMedium)];
    textAtt.color = [UIColor colorWithHexString:@"#333333"];
    
    self.titleLable.attributedText = textAtt;
}

/**
 描述信息
 */
- (void)setMessageLabelText:(NSString *)text {
    NSMutableAttributedString *textAtt = [[NSMutableAttributedString alloc] initWithString:text];
    textAtt.lineSpacing = 5;
    textAtt.alignment = NSTextAlignmentCenter;
    textAtt.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightRegular)];
    textAtt.color = [UIColor colorWithHexString:@"#333333"];
    
    self.messageLabel.attributedText = textAtt;
}

/**
 创建操作按钮
 */
- (void)createActionButtonWithTitles:(NSArray *)titles {
    for (NSUInteger idx = 0; idx < titles.count; idx ++) {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:titles[idx] forState:(UIControlStateNormal)];
        button.titleLabel.font = [UIFont systemFontOfSize:18 weight:(UIFontWeightRegular)];
        
        if (idx == [self getDefaultIndex]) {
            button.backgroundColor = self.mainActionColor;
            [button setTitleColor:self.mainTitleColor forState:(UIControlStateNormal)];
            
        } else {
            button.backgroundColor = [UIColor whiteColor];
            [button setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateNormal)];
        }
        
        [self thn_addCuttingLineWithButton:button];
        
        button.tag = kActionButtonTag + idx;
        [button addTarget:self action:@selector(thn_createButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self.buttonContainerView addSubview:button];
        [self.buttonArr addObject:button];
    }
}

// 按钮添加分割线
- (UIButton *)thn_addCuttingLineWithButton:(UIButton *)button {
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.backgroundColor = [UIColor colorWithHexString:@"#E9E9E9"];
    
    [button addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    return button;
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.3];
    
    [self.containerView addSubview:self.titleLable];
    [self.containerView addSubview:self.messageLabel];
    [self.containerView addSubview:self.buttonContainerView];
    [self addSubview:self.containerView];
}

- (void)updateConstraints {
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(0);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(MAX_WIDTH, [self getContainerHeight]));
        make.centerX.centerY.equalTo(self);
    }];
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo([self getTitleHeight]);
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLable.mas_bottom).with.offset(10);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo([self getMessageHeight]);
    }];
    
    [self.buttonContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageLabel.mas_bottom).with.offset(17);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    if (self.buttonArr.count > 1) {
        if (self.alertViewStyle == THNAlertViewStyleAlert) {
            [self.buttonArr mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal) withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
            [self.buttonArr mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(0);
                make.height.mas_equalTo(ACTION_BUTTON_HEIGHT);
            }];
            
        } else if (self.alertViewStyle == THNAlertViewStyleActionSheet) {
            [self.buttonArr mas_distributeViewsAlongAxis:(MASAxisTypeVertical) withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
            [self.buttonArr mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(ACTION_BUTTON_HEIGHT);
            }];
        }
        
    } else if (self.buttonArr.count == 1) {
        UIButton *actionButton = (UIButton *)self.buttonArr[0];
        [actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.mas_equalTo(0);
        }];
    }
    
    [super updateConstraints];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    if ([touches anyObject].view != self.containerView) {
//        [self dismiss];
//    }
//}

#pragma mark - getters and setters
- (CGFloat)getContainerHeight {
    CGFloat originH = 20 + 10 + 17;
    CGFloat titleH = [self getTitleHeight];
    CGFloat messageH = [self getMessageHeight];
    CGFloat buttonH = [self getButtonCaotainerViewHeight];
    
    return titleH + messageH + originH + buttonH;
}

- (CGFloat)getTitleHeight {
    NSString *text = self.titleLable.attributedText.string;
    CGFloat textHeight = [self.titleLable thn_getLabelHeightWithMaxWidth:MAX_WIDTH];
    
    return text.length ? textHeight : 0;
}

- (CGFloat)getMessageHeight {
    NSString *text = self.messageLabel.attributedText.string;
    CGFloat textHeight = [self.messageLabel thn_getLabelHeightWithMaxWidth:MAX_WIDTH];
    
    return text.length ? textHeight : 0;
}

- (CGFloat)getButtonCaotainerViewHeight {
    if (self.alertViewStyle == THNAlertViewStyleAlert) {
        return ACTION_BUTTON_HEIGHT;
    }
    
    return ACTION_BUTTON_HEIGHT * self.buttonTitleArr.count;
}

- (NSInteger)getDefaultIndex {
    if (!self.buttonTitleArr.count) {
        return 0;
    }
    
    return self.alertViewStyle == THNAlertViewStyleActionSheet ? 0 : self.buttonTitleArr.count - 1;
}

- (UIColor *)mainActionColor {
    NSArray *acitonColors = @[kColorMain, @"#FFFFFF"];
    NSString *colorHex = acitonColors[(NSUInteger)self.alertViewStyle];
    
    return _mainActionColor ? _mainActionColor : [UIColor colorWithHexString:colorHex];
}

- (UIColor *)mainTitleColor {
    NSArray *acitonColors = @[@"#FFFFFF", kColorMain];
    NSString *colorHex = acitonColors[(NSUInteger)self.alertViewStyle];
    
    return _mainTitleColor ? _mainTitleColor : [UIColor colorWithHexString:colorHex];
}

- (THNAlertViewStyle)alertViewStyle {
    return _alertViewStyle ? _alertViewStyle : THNAlertViewStyleAlert;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 4;
        _containerView.layer.masksToBounds = YES;
        _containerView.transform = CGAffineTransformScale(_containerView.transform, 0.1, 0.1);
        _containerView.alpha = 0;
    }
    return _containerView;
}

- (YYLabel *)titleLable {
    if (!_titleLable) {
        _titleLable = [[YYLabel alloc] init];
        _titleLable.numberOfLines = 0;
    }
    return _titleLable;
}

- (YYLabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[YYLabel alloc] init];
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}

- (UIView *)buttonContainerView {
    if (!_buttonContainerView) {
        _buttonContainerView = [[UIView alloc] init];
        _buttonContainerView.backgroundColor = [UIColor whiteColor];
    }
    return _buttonContainerView;
}

- (NSMutableArray *)buttonArr {
    if (!_buttonArr) {
        _buttonArr = [NSMutableArray array];
    }
    return _buttonArr;
}

- (NSMutableArray *)buttonTitleArr {
    if (!_buttonTitleArr) {
        _buttonTitleArr = [NSMutableArray array];
    }
    return _buttonTitleArr;
}

@end
