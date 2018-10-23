//
//  THNGoodsSkuCollectionViewCell.h
//  lexi
//
//  Created by FLYang on 2018/8/31.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, THNGoodsSkuCellType) {
    THNGoodsSkuCellTypeNormal = 0,  // 默认
    THNGoodsSkuCellTypeSelected,    // 选中
    THNGoodsSkuCellTypeDisable      // 不可选
};

@interface THNGoodsSkuCollectionViewCell : UICollectionViewCell

/**
 显示状态类型
 */
@property (nonatomic, assign) THNGoodsSkuCellType cellType;

/**
 型号名称
 */
@property (nonatomic, strong) NSString *modeName;

@end
