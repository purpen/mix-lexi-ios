//
//  THNTableViewCells.h
//  lexi
//
//  Created by FLYang on 2018/8/15.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNStoreModel.h"
@class THNLikedGoodsTableViewCell;
@class THNLikedWindowTableViewCell;
@class THNFollowStoreTableViewCell;
@class THNAllsetTableViewCell;
@class UITableViewCell;

typedef NS_ENUM(NSUInteger, THNTableViewCellType) {
    THNTableViewCellTypeLikedGoods = 0, // 喜欢的商品、最近查看、心愿单
    THNTableViewCellTypeLikedWindow,    // 喜欢的橱窗
    THNTableViewCellTypeFollowStore,    // 关注的设计馆
    THNTableViewCellTypeDynamic,        // 动态
    THNTableViewCellTypeSet,            // 集合
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
 关注的店铺
 */
@property (nonatomic, weak) THNFollowStoreTableViewCell *followStoreCell;
@property (nonatomic, strong) THNStoreModel *storeModel;

@property (nonatomic, weak) THNAllsetTableViewCell *setCell;
@property (nonatomic, strong) NSDictionary *setDataDict;

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
+ (instancetype)initWithCellType:(THNTableViewCellType)type cellHeight:(CGFloat)height didSelectedItem:(THNSelectedCellBlock)completion;

@end
