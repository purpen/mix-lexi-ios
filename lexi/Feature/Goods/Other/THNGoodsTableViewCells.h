//
//  THNGoodsTableViewCells.h
//  lexi
//
//  Created by FLYang on 2018/8/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNGoodsModel.h"
@class THNGoodsTitleTableViewCell;
@class THNGoodsTagTableViewCell;
@class UITableViewCell;

typedef NS_ENUM(NSUInteger, THNGoodsTableViewCellType) {
    THNGoodsTableViewCellTypeTitle = 0, // 标题、价格
    THNGoodsTableViewCellTypeTag,       // 标签
    THNGoodsTableViewCellTypeLike,      // 喜欢、心愿单
    THNGoodsTableViewCellTypeChoose,    // 选择规格、尺码
    THNGoodsTableViewCellTypeUser,      // 用户头像
    THNGoodsTableViewCellTypeDescribe,  // 描述
    THNGoodsTableViewCellTypeCheck,     // 查看全部
};

typedef void(^GoodsInfoSelectedCellBlock)(void);

@interface THNGoodsTableViewCells : NSObject

/// 商品标题、价格
@property (nonatomic, weak) THNGoodsTitleTableViewCell *titleCell;
/// 商品标签
@property (nonatomic, weak) THNGoodsTagTableViewCell *tagCell;
@property (nonatomic, strong) NSArray *tagsArr;

@property (nonatomic, strong) THNGoodsModel *goodsModel;

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
