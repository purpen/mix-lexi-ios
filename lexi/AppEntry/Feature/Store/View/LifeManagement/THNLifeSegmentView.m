//
//  THNLifeSegmentView.m
//  lexi
//
//  Created by FLYang on 2018/10/8.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNLifeSegmentView.h"
#import "UIColor+Extension.h"
#import "UIView+Helper.h"
#import <Masonry/Masonry.h>
#import "THNConst.h"
#import "THNMarco.h"

static NSInteger const kActionButtonTag = 525;

@interface THNLifeSegmentView ()

@property (nonatomic, strong) NSMutableArray *buttonArr;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) UIView *borderView;
@property (nonatomic, strong) UILabel *countLabelFirst;
@property (nonatomic, strong) UILabel *countLabelSecond;
@property (nonatomic, strong) UILabel *countLabelThird;

@end

@implementation THNLifeSegmentView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
        [self thn_creatSegmentActionButtonWithTitles:titles];
    }
    return self;
}

- (void)thn_setTransactionReadData:(THNTransactionsDataModel *)model {
    self.countLabelFirst.hidden = model.not_settlement_not_read == 0;
    self.countLabelFirst.text = [NSString stringWithFormat:@"%zi", model.not_settlement_not_read];
    
    self.countLabelSecond.hidden = model.success_not_read == 0;
    self.countLabelSecond.text = [NSString stringWithFormat:@"%zi", model.success_not_read];
    
    self.countLabelThird.hidden = model.refund_not_read == 0;
    self.countLabelThird.text = [NSString stringWithFormat:@"%zi", model.refund_not_read];
}

- (void)thn_setLifeOrderReadData:(THNLifeOrderDataModel *)model {
    self.countLabelFirst.hidden = model.pending_shipment_not_read == 0;
    self.countLabelFirst.text = [NSString stringWithFormat:@"%zi", model.pending_shipment_not_read];
    
    self.countLabelSecond.hidden = model.shipment_not_read == 0;
    self.countLabelSecond.text = [NSString stringWithFormat:@"%zi", model.shipment_not_read];
    
    self.countLabelThird.hidden = model.finish_not_read == 0;
    self.countLabelThird.text = [NSString stringWithFormat:@"%zi", model.finish_not_read];
}

#pragma mark - event response
- (void)actitonButtonAction:(UIButton *)button {
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
    
    NSInteger index = button.tag - kActionButtonTag;
    
    if (index == 1) {
        self.countLabelFirst.hidden = YES;
        
    } else if (index == 2) {
        self.countLabelSecond.hidden = YES;
        
    } else if (index == 3) {
        self.countLabelThird.hidden = YES;
    }
    
    if ([self.delegate respondsToSelector:@selector(thn_didSelectedLifeSegmentIndex:)]) {
        [self.delegate thn_didSelectedLifeSegmentIndex:index];
    }
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.borderView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(36);
    }];
    
    [self.buttonArr mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal)
                                withFixedSpacing:10
                                     leadSpacing:30
                                     tailSpacing:30];
    
    [self.buttonArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(35);
        make.centerY.equalTo(self);
    }];
}

- (void)drawRect:(CGRect)rect {
    [UIView drawRectLineStart:CGPointMake(0, CGRectGetHeight(self.frame))
                          end:CGPointMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))
                        width:1
                        color:[UIColor colorWithHexString:@"#E9E9E9"]];
}

#pragma mark - getters and setters
- (void)thn_creatSegmentActionButtonWithTitles:(NSArray *)titles {
    CGFloat buttonW = ((SCREEN_WIDTH - 60) - ((titles.count - 1) * 10)) / titles.count;
    
    for (NSUInteger idx = 0; idx < titles.count; idx ++) {
        NSString *text = titles[idx];
        
        UIButton *actionButton = [[UIButton alloc] init];
        actionButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [actionButton setTitle:text forState:(UIControlStateNormal)];
        [actionButton setTitleColor:[UIColor colorWithHexString:@"#555555"] forState:(UIControlStateNormal)];
        [actionButton setTitleColor:[UIColor colorWithHexString:kColorMain] forState:(UIControlStateSelected)];
        actionButton.tag = kActionButtonTag + idx;
        [actionButton addTarget:self action:@selector(actitonButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        if (idx == 0) {
            actionButton.selected = YES;
            self.selectedButton = actionButton;
        }
        
        [self addSubview:actionButton];
        [self.buttonArr addObject:actionButton];
        
        // 未读数量
        CGFloat textW = text.length * 13;
        if (idx == 1) {
            self.countLabelFirst.frame = CGRectMake(buttonW/2 + textW/2, 3, 16, 16);
            [actionButton addSubview:self.countLabelFirst];
            
        } else if (idx == 2) {
            self.countLabelSecond.frame = CGRectMake(buttonW/2 + textW/2, 3, 16, 16);
            [actionButton addSubview:self.countLabelSecond];
            
        } else if (idx == 3) {
            self.countLabelThird.frame = CGRectMake(buttonW/2 + textW/2, 3, 16, 16);
            [actionButton addSubview:self.countLabelThird];
        }
    }
}

- (UIView *)borderView {
    if (!_borderView) {
        _borderView = [[UIView alloc] init];
        _borderView.layer.borderWidth = 1;
        _borderView.layer.borderColor = [UIColor colorWithHexString:kColorMain].CGColor;
        _borderView.layer.cornerRadius = 18;
        _borderView.layer.masksToBounds = YES;
        _borderView.backgroundColor = [UIColor whiteColor];
    }
    return _borderView;
}

- (UILabel *)countLabelFirst {
    if (!_countLabelFirst) {
        _countLabelFirst = [[UILabel alloc] init];
        _countLabelFirst.backgroundColor = [UIColor colorWithHexString:@"#FF6666"];
        _countLabelFirst.textColor = [UIColor whiteColor];
        _countLabelFirst.font = [UIFont systemFontOfSize:10];
        _countLabelFirst.textAlignment = NSTextAlignmentCenter;
        _countLabelFirst.layer.cornerRadius = 8;
        _countLabelFirst.layer.masksToBounds = YES;
        _countLabelFirst.hidden = YES;
    }
    return _countLabelFirst;
}

- (UILabel *)countLabelSecond {
    if (!_countLabelSecond) {
        _countLabelSecond = [[UILabel alloc] init];
        _countLabelSecond.backgroundColor = [UIColor colorWithHexString:@"#FF6666"];
        _countLabelSecond.textColor = [UIColor whiteColor];
        _countLabelSecond.font = [UIFont systemFontOfSize:10];
        _countLabelSecond.textAlignment = NSTextAlignmentCenter;
        _countLabelSecond.layer.cornerRadius = 8;
        _countLabelSecond.layer.masksToBounds = YES;
        _countLabelSecond.hidden = YES;
    }
    return _countLabelSecond;
}

- (UILabel *)countLabelThird {
    if (!_countLabelThird) {
        _countLabelThird = [[UILabel alloc] init];
        _countLabelThird.backgroundColor = [UIColor colorWithHexString:@"#FF6666"];
        _countLabelThird.textColor = [UIColor whiteColor];
        _countLabelThird.font = [UIFont systemFontOfSize:10];
        _countLabelThird.textAlignment = NSTextAlignmentCenter;
        _countLabelThird.layer.cornerRadius = 8;
        _countLabelThird.layer.masksToBounds = YES;
        _countLabelThird.hidden = YES;
    }
    return _countLabelThird;
}

- (NSMutableArray *)buttonArr {
    if (!_buttonArr) {
        _buttonArr = [NSMutableArray array];
    }
    return _buttonArr;
}

@end
