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

@interface THNFeaturedCollectionView : UICollectionView

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) BannerType bannerType;

@end
