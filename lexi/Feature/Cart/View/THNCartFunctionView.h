//
//  THNCartFunctionView.h
//  lexi
//
//  Created by FLYang on 2018/9/15.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, THNCartFunctionStatus) {
    THNCartFunctionStatusDefault = 0, // 默认
    THNCartFunctionStatusEdit         // 编辑
};

@protocol THNCartFunctionViewDelegate <NSObject>

@optional
/// 结算购物车商品
- (void)thn_didSettleShoppingCartItems;
/// 移除购物车商品
- (void)thn_didRemoveShoppingCartItems;
/// 添加商品到心愿单
- (void)thn_didShoppingCartItemsToWishlist;

@end

@interface THNCartFunctionView : UIView

/**
 合计总价
 */
@property (nonatomic, assign) CGFloat totalPrice;

/**
 状态
 */
@property (nonatomic, assign) THNCartFunctionStatus status;

@property (nonatomic, weak) id <THNCartFunctionViewDelegate> delegate;

@end
