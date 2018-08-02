//
//  THNExploreTableViewCell.h
//  lexi
//
//  Created by HongpingRao on 2018/7/26.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ExploreCellType) {
    ExploreSet,  //  集合类型Cell
    ExploreFeaturedBrand,  //特色品牌馆Cell
    ExploreOther  // 其他cell类型
};

UIKIT_EXTERN  CGFloat const cellSetHeight;
UIKIT_EXTERN  CGFloat const cellFeaturedBrandHeight;
UIKIT_EXTERN  CGFloat const cellOtherHeight;

@interface THNExploreTableViewCell : UITableViewCell

- (void)setCellTypeStyle:(ExploreCellType)cellType;

@end
