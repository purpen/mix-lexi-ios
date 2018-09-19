//
//  THNGoodsInfoTableViewCell.h
//  lexi
//
//  Created by FLYang on 2018/9/11.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNGoodsModel.h"
#import "THNCartModel.h"
#import "THNSkuModel.h"

@class THNGoodsInfoTableViewCell;

typedef NS_ENUM(NSUInteger, THNGoodsInfoCellType) {
    THNGoodsInfoCellTypeDefault = 0,        // 默认
    THNGoodsInfoCellTypeCartNormal,         // 购物车正常状态
    THNGoodsInfoCellTypeCartEdit,           // 购物车编辑状态
    THNGoodsInfoCellTypeCartWish,           // 购物车心愿单
    THNGoodsInfoCellTypeSubmitOrder,        // 提交订单
    THNGoodsInfoCellTypeSelectLogistics,    // 选择配送方式
    THNGoodsInfoCellTypePaySuccess,         // 支付成功
    THNGoodsInfoCellTypeOrderList,          // 订单列表
    THNGoodsInfoCellTypeOrderInfo,          // 订单详情
};

@protocol THNGoodsInfoTableViewCellDelegate <NSObject>

@optional
- (void)thn_didSelectedAddGoodsToCart:(THNGoodsInfoTableViewCell *)cell;

@end

@interface THNGoodsInfoTableViewCell : UITableViewCell

@property (nonatomic, assign) THNGoodsInfoCellType cellType;
@property (nonatomic, assign) BOOL showLine;
@property (nonatomic, weak) id <THNGoodsInfoTableViewCellDelegate> delegate;

- (void)thn_setGoodsInfoWithModel:(THNGoodsModel *)model;
- (void)thn_setSkuGoodsInfoWithModel:(THNSkuModelItem *)model;
- (void)thn_setCartGoodsInfoWithModel:(THNCartModelItem *)model;

+ (instancetype)initGoodsInfoCellWithTableView:(UITableView *)tableView type:(THNGoodsInfoCellType)type;
+ (instancetype)initGoodsInfoCellWithTableView:(UITableView *)tableView type:(THNGoodsInfoCellType)type reuseIdentifier:(NSString *)reuseIdentifier;

@end
