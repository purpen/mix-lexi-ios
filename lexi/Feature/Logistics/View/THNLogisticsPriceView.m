//
//  THNLogisticsPriceView.m
//  lexi
//
//  Created by FLYang on 2018/9/11.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLogisticsPriceView.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>

static NSString *const kTextTitle = @"预计运费";
static NSString *const kTextHint  = @"注：采用不同的配送方式的到达天数不同，运费价格也有所不同，实际运费返回明细查看。";

@interface THNLogisticsPriceView ()

/// 标题
@property (nonatomic, strong) YYLabel *titelLabel;
/// 价格
@property (nonatomic, strong) YYLabel *priceLabel;
/// 提示
@property (nonatomic, strong) YYLabel *hintLabel;

@end

@implementation THNLogisticsPriceView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

- (void)thn_setLogisticsPriceValue:(CGFloat)value {
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.0f", value];
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.titelLabel];
    [self addSubview:self.priceLabel];
    [self addSubview:self.hintLabel];
    
    [self setMasonryLayout];
}

- (void)setMasonryLayout {
    [self.titelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(100, 16));
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(100, 16));
    }];
    
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titelLabel.mas_bottom).with.offset(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(35);
    }];
}

#pragma mark - getters and setters
- (YYLabel *)titelLabel {
    if (!_titelLabel) {
        _titelLabel = [[YYLabel alloc] init];
        _titelLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)];
        _titelLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titelLabel.text = kTextTitle;
    }
    return _titelLabel;
}

- (YYLabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[YYLabel alloc] init];
        _priceLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)];
        _priceLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _priceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _priceLabel;
}

- (YYLabel *)hintLabel {
    if (!_hintLabel) {
        _hintLabel = [[YYLabel alloc] init];
        _hintLabel.numberOfLines = 2;
        
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:kTextHint];
        att.font = [UIFont systemFontOfSize:11];
        att.lineSpacing = 5;
        att.color = [UIColor colorWithHexString:@"#333333"];

        [att setTextHighlightRange:NSMakeRange(0, 2)
                             color:[UIColor colorWithHexString:@"#FF6666"]
                   backgroundColor:[UIColor clearColor]
                          userInfo:nil];
        
        _hintLabel.attributedText = att;
    }
    return _hintLabel;
}

@end
