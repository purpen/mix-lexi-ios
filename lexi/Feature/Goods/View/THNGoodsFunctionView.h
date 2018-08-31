//
//  THNGoodsFunctionView.h
//  lexi
//
//  Created by FLYang on 2018/8/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNGoodsModel.h"
#import "NSObject+EnumManagement.h"

@protocol THNGoodsFunctionViewDelegate <NSObject>

/// 打开购物车
- (void)thn_openGoodsCart;
/// 打开 SKU 视图
- (void)thn_openGoodsSkuWithType:(THNGoodsButtonType)type;

@end

@interface THNGoodsFunctionView : UIView

/**
 类型
 */
@property (nonatomic, assign) THNGoodsFunctionViewType type;

/**
 代理
 */
@property (nonatomic, weak) id <THNGoodsFunctionViewDelegate> delegate;

- (void)thn_setGoodsModel:(THNGoodsModel *)model;
- (instancetype)initWithFrame:(CGRect)frame type:(THNGoodsFunctionViewType)type;

@end
