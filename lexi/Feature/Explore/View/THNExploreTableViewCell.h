//
//  THNExploreTableViewCell.h
//  lexi
//
//  Created by HongpingRao on 2018/7/26.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 - ExploreRecommend: 推荐
 - ExploreFeaturedBrand: 特色品牌馆
 - ExploreNewProduct: 优质新品
 - ExploreSet: 集合
 - ExploreGoodDesign: 特惠好设计
 - ExploreGoodThings : 百元好物
 */
typedef NS_ENUM(NSInteger, ExploreCellType) {
    ExploreRecommend,
    ExploreFeaturedBrand,
    ExploreNewProduct,
    ExploreSet,
    ExploreGoodDesign,
    ExploreGoodThings
};

@class THNExploreTableViewCell;
@class THNSetModel;
@class THNFeaturedBrandModel;

@protocol THNExploreTableViewCellDelegate<NSObject>

@optional
- (void)lookAllWithType:(ExploreCellType)cellType;
- (void)pushSetDetail:(THNSetModel *)setModel;
- (void)pushBrandHall:(THNFeaturedBrandModel *)featuredBrandModel;

@end

UIKIT_EXTERN  CGFloat const cellSetHeight;
UIKIT_EXTERN  CGFloat const cellFeaturedBrandHeight;
UIKIT_EXTERN  CGFloat const cellOtherHeight;

@interface THNExploreTableViewCell : UITableViewCell

- (void)setCellTypeStyle:(ExploreCellType)cellType
       initWithDataArray:(NSArray *)dataArray
           initWithTitle:(NSString *)title;

@property (nonatomic, weak) id <THNExploreTableViewCellDelegate> delagate;

@end
