//
//  THNShareWxaView.h
//  lexi
//
//  Created by FLYang on 2018/11/29.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, THNShareWxaViewType) {
    THNShareWxaViewTypeLifeStore = 0,   // 生活馆
    THNShareWxaViewTypeSellGoods,       // 销售分销的商品
};

@protocol THNShareWxaViewDelegate <NSObject>

@required
- (void)thn_cancelShare;
- (void)thn_reviewSharePosterImage:(UIImage *)image;
- (void)thn_shareToWechat;
- (void)thn_savePosterImage:(UIImage *)image;

@end

@interface THNShareWxaView : UIView

@property (nonatomic, weak) id <THNShareWxaViewDelegate> delegate;
@property (nonatomic, assign) THNShareWxaViewType viewType;

/**
 分销商品的佣金
 */
- (void)thn_setSellGoodsMoeny:(CGFloat)money;

/**
 分享海报的url
 */
- (void)thn_setSharePosterImageUrl:(NSString *)imageUrl;

- (instancetype)initWithFrame:(CGRect)frame type:(THNShareWxaViewType)type;

@end
