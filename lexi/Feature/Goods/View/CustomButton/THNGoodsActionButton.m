//
//  THNGoodsActionButton.m
//  lexi
//
//  Created by FLYang on 2018/9/1.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsActionButton.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>
#import "UIColor+Extension.h"
#import "THNConst.h"
#import "YYLabel+Helper.h"

static NSString *const kTextLike    = @"喜欢";
static NSString *const kTextLiked   = @"已喜欢";
static NSString *const kTextWish    = @"心愿单";
static NSString *const kTextAlready = @"已添加";
static NSString *const kTextBuy     = @"购买";
static NSString *const kTextPutaway = @"上架";

@interface THNGoodsActionButton ()

/// icon
@property (nonatomic, strong) UIImageView *iconImageView;
/// 标题
@property (nonatomic, strong) YYLabel *textLabel;

@end

@implementation THNGoodsActionButton

- (instancetype)initWithType:(THNGoodsActionButtonType)type {
    self = [super init];
    if (self) {
        self.type = type;
        [self setupViewUI];
    }
    return self;
}

#pragma mark - public methods
- (void)setLikedGoodsStatus:(BOOL)liked {
    self.selected = liked;
    
    [self thn_showIcon:!liked];
    [self thn_showBorder:NO borderColor:@"#2D343A"];
    [self thn_setIconImageName:liked ? @"" : @"icon_like_white"];
    [self thn_setTitleLabelText:liked ? kTextLiked : kTextLike textColor:kColorWhite];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    [self thn_setBackgroundColorHex:liked ? @"#2D343A" : kColorMain];
}

- (void)setLikedGoodsStatus:(BOOL)liked count:(NSInteger)count {
    self.selected = liked;
    
    [self thn_showIcon:YES];
    [self thn_showBorder:!liked borderColor:@"#EDEDEF"];
    [self thn_setIconImageName:liked ? @"icon_like_white" : @"icon_like_gray"];
    NSString *countStr = count > 0 ? [NSString stringWithFormat:@"+%zi", count] : kTextLike;
    [self thn_setTitleLabelText:countStr textColor:liked ? kColorWhite : @"#949EA6"];
    [self thn_setBackgroundColorHex:liked ? kColorMain : kColorWhite];
}

- (void)setWishGoodsStatus:(BOOL)wish {
    self.selected = wish;
    
    [self thn_showIcon:!wish];
    [self thn_showBorder:YES borderColor:@"#EDEDEF"];
    [self thn_setIconImageName:wish ? @"" : @"icon_add_gray"];
    [self thn_setTitleLabelText:wish ? kTextAlready : kTextWish textColor:@"#949EA6"];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    [self thn_setBackgroundColorHex:kColorWhite];
}

- (void)setPutawayGoodsStauts:(BOOL)putaway {
    self.selected = putaway;
    
    [self thn_showIcon:YES];
    [self thn_showBorder:YES borderColor:@"#EDEDEF"];
    [self thn_setIconImageName:@"icon_putaway_gray"];
    [self thn_setTitleLabelText:kTextPutaway textColor:@"#949EA6"];
    [self thn_setBackgroundColorHex:kColorWhite];
}

- (void)setBuyGoodsButton {
    [self thn_showIcon:NO];
    [self thn_setTitleLabelText:kTextBuy textColor:@"#FFFFFF"];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    [self thn_setBackgroundColorHex:@"#2D343A"];
}

#pragma mark - private methods
- (void)thn_setIconImageName:(NSString *)imageName {
    self.iconImageView.image = [UIImage imageNamed:imageName];
}

- (void)thn_setTitleLabelText:(NSString *)text textColor:(NSString *)color {
    self.textLabel.text = text;
    self.textLabel.textColor = [UIColor colorWithHexString:color];
}

- (void)thn_setBackgroundColorHex:(NSString *)hex {
    self.backgroundColor = [UIColor colorWithHexString:hex];
}

- (void)thn_showIcon:(BOOL)show {
    self.iconImageView.hidden = !show;
    
    [self layoutIfNeeded];
}

- (void)thn_showBorder:(BOOL)show borderColor:(NSString *)color {
    self.layer.borderWidth = show ? 1 : 0;
    self.layer.borderColor = [UIColor colorWithHexString:color].CGColor;
}

#pragma mark - setup UI
- (void)setupViewUI {
    [self addSubview:self.iconImageView];
    [self addSubview:self.textLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (CGRectGetWidth(self.bounds) <= 0 ) return;
    
    self.layer.cornerRadius = CGRectGetHeight(self.bounds) / 2;
    
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(self);
    }];

    [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(15);
        make.centerY.equalTo(self.mas_centerY).with.offset(1.5);
        make.left.mas_equalTo(self.iconImageView.hidden ? 10 : 28);
        make.right.mas_equalTo(-10);
    }];
}

#pragma mark - setup UI
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeCenter;
        _iconImageView.hidden = YES;
    }
    return _iconImageView;
}

- (YYLabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[YYLabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:13];
        _textLabel.userInteractionEnabled = NO;
    }
    return _textLabel;
}

@end
