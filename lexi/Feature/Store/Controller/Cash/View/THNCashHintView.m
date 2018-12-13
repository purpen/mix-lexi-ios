//
//  THNCashHintView.m
//  lexi
//
//  Created by FLYang on 2018/12/11.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNCashHintView.h"
#import "UIColor+Extension.h"
#import "UIView+Helper.h"
#import "YYLabel+Helper.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>
#import "THNConst.h"

static NSString *const kTitleNotes      = @"注意事项";
static NSString *const kTitleExplain    = @"提现说明";
static NSString *const kTitleQuery      = @"到账查询";
static NSString *const kTextHintHigh    = @"1-3小时";
static NSString *const kTextHint1       = @"提现申请将在1-3小时内审批到账；如遇高峰期，可能延迟到账，烦请耐心等待";
static NSString *const kTextHint2       = @"请及时关注提现记录，查看提现状态";
static NSString *const kTextHint3       = @"提现到账查询：支付宝 > 我的 > 账单，如果有名称为“乐喜提现成功”的数据，即提现成功到账";
static NSString *const kTextHint4       = @"支付宝：我的 > 账单";
static NSString *const kTextHint5       = @"微信：我 > 钱包 > 零钱 > 零钱明细";

@interface THNCashHintView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation THNCashHintView

- (instancetype)initWithType:(THNCashHintViewType)type {
    self = [super init];
    if (self) {
        [self setupViewUI];
        [self thn_setTitleWithType:type];
        [self thn_creatHintTextWithType:type];
    }
    return self;
}

#pragma mark - private methods
- (void)thn_creatHintTextWithType:(THNCashHintViewType)type {
    if (type == THNCashHintViewTypeNotes) {
        [self thn_createHintInfoViewWithTexts:@[kTextHint1, kTextHint2, kTextHint3]];
        
    } else if (type == THNCashHintViewTypeQuery) {
        [self thn_createHintInfoViewWithTexts:@[kTextHint4, kTextHint5]];
    }
}

- (void)thn_setTitleWithType:(THNCashHintViewType)type {
    NSArray *titleArr = @[kTitleNotes, kTitleQuery];
    
    self.titleLabel.text = titleArr[(NSUInteger)type];
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.titleLabel];
}

#pragma mark - getters and setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 15)];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _titleLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)];
    }
    return _titleLabel;
}

- (void)thn_createHintInfoViewWithTexts:(NSArray *)texts {
    CGFloat originY = 50;
    
    for (NSUInteger idx = 0; idx < texts.count; idx ++) {
        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, originY, 15, 15)];
        numLabel.backgroundColor = [UIColor colorWithHexString:kColorMain];
        numLabel.textColor = [UIColor whiteColor];
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.font = [UIFont systemFontOfSize:11 weight:(UIFontWeightMedium)];
        numLabel.text = [NSString stringWithFormat:@"%zi", idx + 1];
        [numLabel drawCornerWithType:(UILayoutCornerRadiusAll) radius:15/2];
        
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:texts[idx]];
        att.font = [UIFont systemFontOfSize:13];
        att.color = [UIColor colorWithHexString:@"#999999"];
        att.lineSpacing = 5;
        if ([att.string containsString:kTextHintHigh]) {
            [att setTextHighlightRange:NSMakeRange(6, kTextHintHigh.length)
                                 color:[UIColor colorWithHexString:@"#FF6666"]
                       backgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]
                             tapAction:nil];
        }
        
        YYLabel *textLabel = [[YYLabel alloc] init];
        textLabel.numberOfLines = 0;
        textLabel.attributedText = att;
        
        CGFloat textH = [textLabel thn_getLabelHeightWithMaxWidth:kScreenWidth - 62];
        textLabel.frame = CGRectMake(42, originY, kScreenWidth - 62, textH);
        
        [self addSubview:textLabel];
        [self addSubview:numLabel];
        
        originY += (textH + 10);
    }
}

@end
