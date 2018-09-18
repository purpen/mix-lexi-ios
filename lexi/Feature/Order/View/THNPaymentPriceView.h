//
//  THNPaymentPriceView.h
//  lexi
//
//  Created by FLYang on 2018/9/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THNPaymentPriceView : UIView

/**
 设置价格

 @param priceValue 价格
 @param totalPriceValue 运费
 @param freightValue 总价
 */
- (void)thn_setPriceValue:(CGFloat)priceValue totalPriceValue:(CGFloat)totalPriceValue freightValue:(CGFloat)freightValue;

@end
