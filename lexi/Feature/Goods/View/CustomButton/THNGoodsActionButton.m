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
#import "UIView+Helper.h"

static NSString *const kTextLike    = @"喜欢";
static NSString *const kTextLiked   = @"已喜欢";
static NSString *const kTextWish    = @"心愿单";
static NSString *const kTextAlready = @"已添加";
static NSString *const kTextBuy     = @"购买";
static NSString *const kTextPutaway = @"上架";

@interface THNGoodsActionButton ()

/// 视图容器
@property (nonatomic, strong) UIView *containerView;
/// icon
@property (nonatomic, strong) UIImageView *iconImageView;
/// 标题
@property (nonatomic, strong) YYLabel *textLabel;
/// 加载动画
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

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
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    [self thn_showBorder:NO borderColor:@"#2D343A"];
    [self thn_setIconImageName:liked ? @"" : @"icon_like_white"];
    [self thn_setTitleLabelText:liked ? kTextLiked : kTextLike textColor:kColorWhite];
    [self thn_setBackgroundColorHex:liked ? @"#2D343A" : kColorMain];
    
    [self setNeedsUpdateConstraints];
}

- (void)setLikedGoodsStatus:(BOOL)liked count:(NSInteger)count {
    self.selected = liked;
    
    NSString *countStr = count > 0 ? [NSString stringWithFormat:@"+%zi", count] : kTextLike;
    
    [self thn_showIcon:YES];
    
    if (self.type == THNGoodsActionButtonTypeLikeCount) {
        [self thn_showBorder:!liked borderColor:@"#EDEDEF"];
        [self thn_setIconImageName:liked ? @"icon_like_white" : @"icon_like_gray"];
        [self thn_setTitleLabelText:countStr textColor:liked ? kColorWhite : @"#949EA6"];
        [self thn_setBackgroundColorHex:liked ? kColorMain : kColorWhite];
        
    } else if (self.type == THNGoodsActionButtonTypeLike) {
        [self thn_showBorder:!liked borderColor:@"#2D343A"];
        [self thn_setIconImageName:@"icon_like_white"];
        [self thn_setTitleLabelText:countStr textColor:kColorWhite];
        [self thn_setBackgroundColorHex:liked ? kColorMain : @"#2D343A"];
    }
    
    [self setNeedsUpdateConstraints];
}

- (void)setWishGoodsStatus:(BOOL)wish {
    self.selected = wish;
    
    [self thn_showIcon:!wish];
    [self thn_showBorder:YES borderColor:@"#EDEDEF"];
    [self thn_setIconImageName:wish ? @"" : @"icon_add_gray"];
    [self thn_setTitleLabelText:wish ? kTextAlready : kTextWish textColor:@"#949EA6"];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    [self thn_setBackgroundColorHex:kColorWhite];
    
    [self setNeedsUpdateConstraints];
}

- (void)setPutawayGoodsStauts:(BOOL)putaway {
    self.selected = putaway;
    
    [self thn_showIcon:YES];
    [self thn_showBorder:YES borderColor:@"#EDEDEF"];
    [self thn_setIconImageName:@"icon_putaway_gray"];
    [self thn_setTitleLabelText:kTextPutaway textColor:@"#949EA6"];
    [self thn_setBackgroundColorHex:kColorWhite];
    
    [self setNeedsUpdateConstraints];
}

- (void)setBuyGoodsButton {
    [self thn_showIcon:NO];
    [self thn_setTitleLabelText:kTextBuy textColor:@"#FFFFFF"];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    [self thn_setBackgroundColorHex:@"#2D343A"];
    
    [self setNeedsUpdateConstraints];
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
    self.containerView.backgroundColor = [UIColor colorWithHexString:hex];
}

- (void)thn_showIcon:(BOOL)show {
    self.iconImageView.hidden = !show;
}

- (void)thn_showBorder:(BOOL)show borderColor:(NSString *)color {
    self.containerView.layer.borderWidth = show ? 1 : 0;
    self.containerView.layer.borderColor = [UIColor colorWithHexString:color].CGColor;
}

#pragma mark 显示加载动画
- (void)startLoading {
    [self thn_showLoadingView:YES];
    [self.loadingView startAnimating];
}

- (void)endLoading {
    [self thn_showLoadingView:NO];
    [self.loadingView stopAnimating];
}

- (void)thn_showLoadingView:(BOOL)show {
    self.userInteractionEnabled = !show;
    
    self.iconImageView.hidden = show;
    self.textLabel.hidden = show;
    
    BOOL isLike = self.type == THNGoodsActionButtonTypeLike || self.type == THNGoodsActionButtonTypeLikeCount;
    NSString *hexColor = isLike ? kColorMain : @"#FFFFFF";
    self.containerView.backgroundColor = [UIColor colorWithHexString:hexColor];
    
    [self thn_showBorder:!isLike borderColor:isLike ? kColorMain : @"#EDEDEF"];
    
    self.loadingView.activityIndicatorViewStyle = isLike ? UIActivityIndicatorViewStyleWhite : UIActivityIndicatorViewStyleGray;
}

#pragma mark - setup UI
- (void)setupViewUI {
    [self.containerView addSubview:self.iconImageView];
    [self.containerView addSubview:self.textLabel];
    [self addSubview:self.containerView];
    [self addSubview:self.loadingView];
}

- (void)updateConstraints {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.left.mas_equalTo(10);
        make.centerY.equalTo(self.containerView);
    }];
    
    [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(15);
        make.left.mas_equalTo(self.iconImageView.hidden ? 10 : 28);
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(self.containerView).centerOffset(CGPointMake(1.5, 0));
    }];
    
    [self.loadingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [super updateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.containerView.layer.cornerRadius = CGRectGetHeight(self.bounds) / 2;
}

#pragma mark - setup UI
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.userInteractionEnabled = NO;
        _containerView.layer.masksToBounds = YES;
    }
    return _containerView;
}

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
        _textLabel.textContainerInset = UIEdgeInsetsMake(3, 0, 0, 0);
        _textLabel.userInteractionEnabled = NO;
    }
    return _textLabel;
}

- (UIActivityIndicatorView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhite)];
        _loadingView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    }
    return _loadingView;
}

@end
