//
//  THNTableViewCells.h
//  lexi
//
//  Created by FLYang on 2018/8/15.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class THNLikedGoodsTableViewCell;
@class THNLikedWindowTableViewCell;
@class UITableViewCell;

typedef NS_ENUM(NSUInteger, THNTableViewCellType) {
    THNTableViewCellTypeLikedGoods = 0, // 喜欢的商品
    THNTableViewCellTypeLikedWindow,    // 喜欢的橱窗
    THNTableViewCellTypeViewed,         // 最近查看
    THNTableViewCellTypeWish,           // 心愿单
    THNTableViewCellTypeDynamic         // 动态
};

typedef void(^THNSelectedCellBlock)(NSString *ids);

@interface THNTableViewCells : NSObject

/**
 喜欢的商品
 */
@property (nonatomic, weak) THNLikedGoodsTableViewCell *likedGoodsCell;
@property (nonatomic, strong) NSArray *goodsDataArr;

/**
 喜欢的橱窗
 */
@property (nonatomic, weak) THNLikedWindowTableViewCell *likedWindowCell;
@property (nonatomic, strong) NSArray *windowDataArr;

/**
 选中的单元格
 */
@property (nonatomic, copy) THNSelectedCellBlock selectedCellBlock;

/**
 cell 类型
 */
@property (nonatomic, assign) THNTableViewCellType cellType;

/**
 高度
 */
@property (nonatomic, assign) CGFloat height;

/**
 AccessoryType
 */
@property (nonatomic, assign) UITableViewCellAccessoryType accessoryType;

/**
 选中的样式
 */
@property (nonatomic, assign) UITableViewCellSelectionStyle selectionStyle;

+ (instancetype)initWithCellType:(THNTableViewCellType)type didSelectedItem:(THNSelectedCellBlock)completion;

@end
