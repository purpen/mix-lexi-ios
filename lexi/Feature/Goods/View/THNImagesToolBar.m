//
//  THNImagesToolBar.m
//  lexi
//
//  Created by FLYang on 2018/12/5.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNImagesToolBar.h"
#import <Masonry/Masonry.h>
#import "THNMarco.h"
#import "UIColor+Extension.h"
#import "THNGoodsActionButton.h"
#import "THNGoodsActionButton+SelfManager.h"

@interface THNImagesToolBar () {
//    id <YBImageBrowserCellDataProtocol> _data;
}

/// 商品数据
@property (nonatomic, strong) THNGoodsModel *goodsModel;
/// 视图
@property (nonatomic, strong) CAGradientLayer *gradient;
@property (nonatomic, strong) THNGoodsActionButton *likeButton;
@property (nonatomic, strong) THNGoodsActionButton *buyButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation THNImagesToolBar

- (instancetype)initWithGoodsModel:(THNGoodsModel *)model {
    self = [super init];
    if (self) {
        self.goodsModel = model;
        [self setupViewUI];
    }
    return self;
}

#pragma mark - YBImageBrowserToolBarProtocol
- (void)yb_browserUpdateLayoutWithDirection:(YBImageBrowserLayoutDirection)layoutDirection containerSize:(CGSize)containerSize {
    CGFloat viewH = kDeviceiPhoneX ? 122.0 : 90.0;
    
    self.frame = CGRectMake(0, SCREEN_HEIGHT - viewH, SCREEN_WIDTH, viewH);
    self.gradient.frame = self.bounds;
    
    [self setMasonryLayout];
}

- (void)yb_browserPageIndexChanged:(NSUInteger)pageIndex totalPage:(NSUInteger)totalPage data:(id<YBImageBrowserCellDataProtocol>)data {
    self.countLabel.text = [NSString stringWithFormat:@"%zi/%zi", pageIndex + 1, totalPage];
}

#pragma mark - event response
- (void)buyButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_goodsImageBuyGoodsAction)]) {
        [self.delegate thn_goodsImageBuyGoodsAction];
    }
}

- (void)shareButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_goodsImageShareGoodsAction)]) {
        [self.delegate thn_goodsImageShareGoodsAction];
    }
}

#pragma mark - setup UI
- (void)setupViewUI {
    [self.layer addSublayer:self.gradient];
    [self addSubview:self.likeButton];
    [self addSubview:self.buyButton];
    [self addSubview:self.shareButton];
    [self addSubview:self.countLabel];
}

- (void)setMasonryLayout {
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(66, 29));
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(46);
    }];
    
    [self.buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(66, 29));
        make.left.equalTo(self.likeButton.mas_right).with.offset(15);
        make.centerY.mas_equalTo(self.likeButton);
    }];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(29, 29));
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.likeButton);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(29);
        make.left.equalTo(self.buyButton.mas_right).with.offset(15);
        make.right.equalTo(self.shareButton.mas_left).with.offset(-15);
        make.centerY.mas_equalTo(self.likeButton);
    }];
}

#pragma mark - getters and setters
- (CAGradientLayer *)gradient {
    if (!_gradient) {
        _gradient = [CAGradientLayer layer];
        _gradient.startPoint = CGPointMake(0.5, 1);
        _gradient.endPoint = CGPointMake(0.5, 0);
        _gradient.colors = @[(id)[UIColor colorWithHexString:@"#000000" alpha:1].CGColor,
                             (id)[UIColor colorWithHexString:@"#000000" alpha:0].CGColor];
    }
    return _gradient;
}

- (THNGoodsActionButton *)likeButton {
    if (!_likeButton) {
        _likeButton = [[THNGoodsActionButton alloc] initWithType:(THNGoodsActionButtonTypeLike)];
        [_likeButton selfManagerLikeGoodsStatus:self.goodsModel.isLike
                                          count:self.goodsModel.likeCount
                                        goodsId:self.goodsModel.rid];
        
        WEAKSELF;
        
        _likeButton.likeGoodsCompleted = ^(NSInteger count) {
            weakSelf.goodsModel.isLike = !weakSelf.goodsModel.isLike;
            weakSelf.goodsModel.likeCount = count;
        };
    }
    return _likeButton;
}

- (THNGoodsActionButton *)buyButton {
    if (!_buyButton) {
        _buyButton = [[THNGoodsActionButton alloc] initWithType:(THNGoodsActionButtonTypeBuy)];
        [_buyButton setBuyGoodsButton];
        [_buyButton addTarget:self action:@selector(buyButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _buyButton;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [[UIButton alloc] init];
        _shareButton.backgroundColor = [UIColor colorWithHexString:@"#2D343A"];
        [_shareButton setImage:[UIImage imageNamed:@"icon_share_white"] forState:(UIControlStateNormal)];
        [_shareButton setImageEdgeInsets:(UIEdgeInsetsMake(8, 8, 8, 8))];
        _shareButton.layer.cornerRadius = 29/2;
        [_shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _shareButton;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.textColor = [UIColor colorWithHexString:@"#DADADA"];
        _countLabel.font = [UIFont systemFontOfSize:14];
        _countLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _countLabel;
}

@end
