//
//  THNProductCollectionViewCell.h
//  lexi
//
//  Created by HongpingRao on 2018/7/26.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, THNHomeType) {
    THNHomeTypeExplore,
    THNHomeTypeFeatured
};

@class THNProductModel;

@interface THNProductCollectionViewCell : UICollectionViewCell

- (void)setProductModel:(THNProductModel *)productModel initWithType:(THNHomeType)homeType;

@end
