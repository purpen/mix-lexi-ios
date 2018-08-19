//
//  THNFeatureTableViewCell.h
//  lexi
//
//  Created by HongpingRao on 2018/7/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FeaturedCellType) {
    FeaturedRecommendedToday,
    FeaturedRecommendationPopular,
    FeaturedLifeAesthetics,
    FearuredOptimal,
    FearuredGrassList,
    FeaturedNo // 生活馆最后一个cell (本周最受欢迎)
};

UIKIT_EXTERN  CGFloat const kCellTodayHeight;
UIKIT_EXTERN  CGFloat const kCellPopularHeight;
UIKIT_EXTERN  CGFloat const kCellLifeAestheticsHeight;
UIKIT_EXTERN  CGFloat const kCellOptimalHeight;
UIKIT_EXTERN  CGFloat const kCellGrassListHeight;

@interface THNFeatureTableViewCell : UITableViewCell

- (void)setCellTypeStyle:(FeaturedCellType)cellType
       initWithDataArray:(NSArray *)dataArray
           initWithTitle:(NSString *)title;

@property (nonatomic, strong) NSMutableArray *grassLabelHeights;


@end
