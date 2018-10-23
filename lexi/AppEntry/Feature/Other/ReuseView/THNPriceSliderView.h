//
//  THNPriceSliderView.h
//  lexi
//
//  Created by FLYang on 2018/8/27.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol THNPriceSliderViewDelegate <NSObject>

- (void)thn_selectedPriceSliderMinPrice:(NSInteger)minPrice maxPrice:(NSInteger)maxPrice;

@end

@interface THNPriceSliderView : UIView

/**
 重置滑块选择位置
 */
- (void)thn_resetSliderValue;

@property (nonatomic, weak) id <THNPriceSliderViewDelegate> delegate;

@end
