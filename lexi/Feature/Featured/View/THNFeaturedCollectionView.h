//
//  THNFeaturedCollectionView.h
//  lexi
//
//  Created by HongpingRao on 2018/7/27.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BannerType) {
    BannerTypeLeft,
    BannerTypeCenter
};

@protocol THNFeaturedCollectionViewDelegate <NSObject>

@optional
- (void)bannerPushGoodInfo:(NSString *)rid;
- (void)bannerPushBrandHall:(NSString *)rid;
- (void)bannerPushArticle:(NSInteger)rid;
- (void)bannerPushCategorie:(NSString *)name initWithCategoriesID:(NSInteger)categorieID;

@end

@interface THNFeaturedCollectionView : UICollectionView

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) BannerType bannerType;
@property (nonatomic, weak) id <THNFeaturedCollectionViewDelegate> featuredDelegate;

@end
