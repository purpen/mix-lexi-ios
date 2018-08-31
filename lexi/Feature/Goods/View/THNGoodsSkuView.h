//
//  THNGoodsSkuView.h
//  lexi
//
//  Created by FLYang on 2018/8/31.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+EnumManagement.h"
#import "THNSkuModel.h"

@interface THNGoodsSkuView : UIView

/**
 视图类型
 */
@property (nonatomic, assign) THNGoodsFunctionViewType viewType;

/**
 执行的操作类型
 */
@property (nonatomic, assign) THNGoodsButtonType handleType;

/**
 商品 id
 */
@property (nonatomic, strong) NSString *goodsId;

/**
 显示视图的类型，执行的操作类型

 @param viewType 视图类型
 @param handleType 操作类型
 */
- (void)thn_showGoodsSkuViewWithType:(THNGoodsFunctionViewType)viewType handleType:(THNGoodsButtonType)handleType;

/**
 设置商品标题
 */
- (void)thn_setTitleAttributedString:(NSAttributedString *)string;

/**
 设置 Sku 信息
 */
- (void)thn_setGoodsSkuModel:(THNSkuModel *)model;

@end
