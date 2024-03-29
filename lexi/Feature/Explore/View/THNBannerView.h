//
//  THNBannerView.h
//  lexi
//
//  Created by HongpingRao on 2018/7/25.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>



/**
 循环轮播图的类型

 - CarouselBannerTypeDefault: 数据 : BannerModel pageControl 位置右下角
 - CarouselBannerTypeBrandHallFeatured: 数据 : string 中下方
 */
typedef NS_ENUM(NSUInteger, CarouselBannerType) {
    CarouselBannerTypeDefault,
    CarouselBannerTypeBrandHallFeatured,
    CarouselBannerTypeZoom
};

@protocol THNBannerViewDelegate <NSObject>

@optional
- (void)bannerPushWeb:(NSString *)url;
- (void)bannerPushGoodInfo:(NSString *)rid;
- (void)bannerPushBrandHall:(NSString *)rid;
- (void)bannerPushArticle:(NSInteger)rid;
- (void)bannerPushCategorie:(NSString *)name initWithCategoriesID:(NSString *)categorieID;
- (void)bannerPushSet:(NSInteger)collectionID;
- (void)bannerPushShowWindow:(NSString *)shopWindowRid;

@end

@interface THNBannerView : UIView

@property (nonatomic, assign) CarouselBannerType carouselBannerType;

- (void)setBannerView:(NSArray *)array;
- (void)removeTimer;
@property (nonatomic, weak) id <THNBannerViewDelegate> delegate;

@end
