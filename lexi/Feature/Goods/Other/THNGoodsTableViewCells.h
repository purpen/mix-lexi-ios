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
#import "THNFreightModel.h"

@class THNGoodsTitleTableViewCell;
@class THNGoodsTagTableViewCell;
@class THNGoodsActionTableViewCell;
@class THNGoodsDirectTableViewCell;
@class THNGoodsUserTableViewCell;
@class THNGoodsDescribeTableViewCell;
@class THNGoodsCheckTableViewCell;
@class THNGoodsStoreTableViewCell;
@class THNLikedGoodsTableViewCell;
@class THNGoodsHeaderTableViewCell;
@class THNGoodsContactTableViewCell;
@class THNDealContentTableViewCell;
@class THNGoodsCouponTableViewCell;
@class UITableViewCell;

typedef NS_ENUM(NSUInteger, THNGoodsTableViewCellType) {
    THNGoodsTableViewCellTypeTitle = 0, // 标题、价格
    THNGoodsTableViewCellTypeTag,       // 标签
    THNGoodsTableViewCellTypeAction,    // 喜欢、心愿单
    THNGoodsTableViewCellTypeChoose,    // 选择规格、尺码
    THNGoodsTableViewCellTypeUser,      // 用户头像
    THNGoodsTableViewCellTypeDescribe,  // 描述
    THNGoodsTableViewCellTypeStore,     // 店铺
    THNGoodsTableViewCellTypeSimilar,   // 相似商品
    THNGoodsTableViewCellTypeContent,   // 商品详情内容
    THNGoodsTableViewCellTypeCoupon     // 优惠券
};

typedef void(^GoodsInfoSelectedCellBlock)(NSString *rid);

@interface THNGoodsTableViewCells : NSObject

/// 商品标题、价格
@property (nonatomic, weak) THNGoodsTitleTableViewCell      *titleCell;
/// 商品标签
@property (nonatomic, weak) THNGoodsTagTableViewCell        *tagCell;
/// 操作按钮
@property (nonatomic, weak) THNGoodsActionTableViewCell     *actionCell;
/// 商品直接选择尺码
@property (nonatomic, weak) THNGoodsDirectTableViewCell     *directCell;
/// 喜欢商品的用户
@property (nonatomic, weak) THNGoodsUserTableViewCell       *userCell;
/// 查看全部描述
@property (nonatomic, weak) THNGoodsDescribeTableViewCell   *desInfoCell;
@property (nonatomic, weak) THNGoodsDescribeTableViewCell   *dispatchCell;
@property (nonatomic, weak) THNGoodsDescribeTableViewCell   *timeCell;
@property (nonatomic, weak) THNGoodsDescribeTableViewCell   *salesReturnCell;
@property (nonatomic, weak) THNGoodsCheckTableViewCell      *cheakDesCell;
/// 店铺商品
@property (nonatomic, weak) THNGoodsStoreTableViewCell      *storeCell;
@property (nonatomic, weak) THNLikedGoodsTableViewCell      *storeGoodsCell;
@property (nonatomic, weak) THNGoodsContactTableViewCell    *contactCell;
/// 相似商品
@property (nonatomic, weak) THNGoodsHeaderTableViewCell     *similarHeaderCell;
@property (nonatomic, weak) THNLikedGoodsTableViewCell      *similarGoodsCell;
/// 详情内容
@property (nonatomic, weak) THNGoodsHeaderTableViewCell     *infoHeaderCell;
@property (nonatomic, weak) THNDealContentTableViewCell    *contentCell;
/// 优惠券
@property (nonatomic, weak) THNGoodsCouponTableViewCell     *couponCell;

/**
 店铺数据
 */
@property (nonatomic, strong) THNStoreModel *storeModel;

/**
 运费数据
 */
@property (nonatomic, strong) THNFreightModel *freightModel;

/**
 商品数据
 */
@property (nonatomic, strong) THNGoodsModel *goodsModel;

/**
 店铺商品数据
 */
@property (nonatomic, strong) NSArray *storeGoodsData;

/**
 相似商品数据
 */
@property (nonatomic, strong) NSArray *similarGoodsData;

/**
 喜欢商品用户数据
 */
@property (nonatomic, strong) NSArray *likeUserData;

/**
 优惠券数据
 */
@property (nonatomic, strong) NSArray *couponData;

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
