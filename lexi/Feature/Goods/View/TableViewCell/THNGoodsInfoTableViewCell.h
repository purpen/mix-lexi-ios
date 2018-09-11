//
//  THNGoodsInfoTableViewCell.h
//  lexi
//
//  Created by FLYang on 2018/9/11.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNGoodsModel.h"

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

@interface THNGoodsInfoTableViewCell : UITableViewCell

@property (nonatomic, assign) THNGoodsInfoCellType cellType;

- (void)thn_setGoodsInfoWithModel:(THNGoodsModel *)model;

+ (instancetype)initGoodsInfoCellWithTableView:(UITableView *)tableView type:(THNGoodsInfoCellType)type;

@end
