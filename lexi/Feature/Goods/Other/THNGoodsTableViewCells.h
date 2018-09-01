//
//  THNGoodsTableViewCells.h
//  lexi
//
//  Created by FLYang on 2018/8/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNGoodsModel.h"
#import "THNStoreModel.h"
@class THNGoodsTitleTableViewCell;
@class THNGoodsTagTableViewCell;
@class THNGoodsDirectTableViewCell;
@class THNGoodsUserTableViewCell;
@class THNGoodsStoreTableViewCell;
@class THNLikedGoodsTableViewCell;
@class THNGoodsContactTableViewCell;
@class UITableViewCell;

typedef NS_ENUM(NSUInteger, THNGoodsTableViewCellType) {
    THNGoodsTableViewCellTypeTitle = 0, // 标题、价格
    THNGoodsTableViewCellTypeTag,       // 标签
    THNGoodsTableViewCellTypeLike,      // 喜欢、心愿单
    THNGoodsTableViewCellTypeChoose,    // 选择规格、尺码
    THNGoodsTableViewCellTypeUser,      // 用户头像
    THNGoodsTableViewCellTypeDescribe,  // 描述
    THNGoodsTableViewCellTypeCheck,     // 查看全部
    THNGoodsTableViewCellTypeStore      // 店铺
};

typedef void(^GoodsInfoSelectedCellBlock)(void);

@interface THNGoodsTableViewCells : NSObject

/// 商品标题、价格
@property (nonatomic, weak) THNGoodsTitleTableViewCell *titleCell;
/// 商品标签
@property (nonatomic, weak) THNGoodsTagTableViewCell *tagCell;
/// 商品直接选择尺码
@property (nonatomic, weak) THNGoodsDirectTableViewCell *directCell;
/// 喜欢商品的用户
@property (nonatomic, weak) THNGoodsUserTableViewCell *userCell;
/// 店铺
@property (nonatomic, weak) THNGoodsStoreTableViewCell *storeCell;
/// 店铺商品
@property (nonatomic, weak) THNLikedGoodsTableViewCell *storeGoodsCell;
/// 联系店铺
@property (nonatomic, weak) THNGoodsContactTableViewCell *contactCell;

/**
 商品数据
 */
@property (nonatomic, strong) THNGoodsModel *goodsModel;

/**
 店铺商品数据
 */
@property (nonatomic, strong) NSArray *storeGoodsData;

/**
 店铺数据
 */
@property (nonatomic, strong) THNStoreModel *storeModel;

/**
 cell 类型
 */
@property (nonatomic, assign) THNGoodsTableViewCellType cellType;

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

/**
 单元格操作事件
 */
@property (nonatomic, copy) GoodsInfoSelectedCellBlock selectedCellBlock;

+ (instancetype)initWithCellType:(THNGoodsTableViewCellType)type;
+ (instancetype)initWithCellType:(THNGoodsTableViewCellType)type didSelectedItem:(GoodsInfoSelectedCellBlock)completion;
+ (instancetype)initWithCellType:(THNGoodsTableViewCellType)type
                      cellHeight:(CGFloat)height
                 didSelectedItem:(GoodsInfoSelectedCellBlock)completion;


@end
