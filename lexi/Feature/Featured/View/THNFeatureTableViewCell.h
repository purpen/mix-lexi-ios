//
//  THNFeatureTableViewCell.h
//  lexi
//
//  Created by HongpingRao on 2018/7/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 cell类型

 - FeaturedRecommendedToday: 今日推荐
 - FeaturedRecommendationPopular: 最受欢迎
 - FeaturedLifeAesthetics: 发现生活
 - FearuredOptimal: 优选
 - FearuredGrassList: 种草清单
 - FeaturedNo: 生活馆的本周最受欢迎
 */
typedef NS_ENUM(NSInteger, FeaturedCellType) {
    FeaturedRecommendedToday,
    FeaturedRecommendationPopular,
    FeaturedLifeAesthetics,
    FearuredOptimal,
    FearuredGrassList,
    FeaturedNo
};

UIKIT_EXTERN  CGFloat const kCellTodayHeight;
UIKIT_EXTERN  CGFloat const kCellPopularHeight;
UIKIT_EXTERN  CGFloat const kCellLifeAestheticsHeight;
UIKIT_EXTERN  CGFloat const kCellOptimalHeight;
UIKIT_EXTERN  CGFloat const kCellGrassListHeight;

@protocol THNFeatureTableViewCellDelegate<NSObject>

@optional
// 点击发现生活美学
- (void)pushShopWindow:(NSString *)rid;

@end

@interface THNFeatureTableViewCell : UITableViewCell



- (void)setCellTypeStyle:(FeaturedCellType)cellType
       initWithDataArray:(NSArray *)dataArray
           initWithTitle:(NSString *)title;
// 种草清单（titleLabel + contentLabel） 高度数组
@property (nonatomic, strong) NSMutableArray *grassLabelHeights;
@property (nonatomic, weak) id <THNFeatureTableViewCellDelegate> delagate;

@end
