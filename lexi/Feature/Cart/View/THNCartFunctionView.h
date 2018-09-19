//
//  THNCartFunctionView.h
//  lexi
//
//  Created by FLYang on 2018/9/15.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol THNCartFunctionViewDelegate <NSObject>

@optional
/// 结算购物车商品
- (void)thn_didSettleShoppingCartItems;

@end

@interface THNCartFunctionView : UIView

/**
 合计总价
 */
@property (nonatomic, assign) CGFloat totalPrice;

@property (nonatomic, weak) id <THNCartFunctionViewDelegate> delegate;

@end
