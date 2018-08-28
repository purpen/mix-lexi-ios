//
//  THNProductCollectionViewCell.h
//  lexi
//
//  Created by HongpingRao on 2018/7/26.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THNProductCollectionViewCell;


/**
 - THNHomeTypeExplore: 探索
 - THNHomeTypeFeatured: 精选
 - THNHomeTypeCenter: 选品中心
 */
typedef NS_ENUM(NSInteger, THNHomeType) {
    THNHomeTypeExplore,
    THNHomeTypeFeatured,
    THNHomeTypeCenter
};

typedef void(^ShelfBlock)(THNProductCollectionViewCell *cell);


@class THNProductModel;

@interface THNProductCollectionViewCell : UICollectionViewCell

- (void)setProductModel:(THNProductModel *)productModel initWithType:(THNHomeType)homeType;

@property (nonatomic, copy) ShelfBlock shelfBlock;

@end
