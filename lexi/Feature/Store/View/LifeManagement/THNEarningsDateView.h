//
//  THNEarningsDateView.h
//  lexi
//
//  Created by FLYang on 2018/10/9.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol THNEarningsDateViewDelegate <NSObject>

// 选择默认的日期
- (void)thn_didSelectedDateWithDefaultIndex:(NSInteger)index;

@end

@interface THNEarningsDateView : UIView

@property (nonatomic, weak) id <THNEarningsDateViewDelegate> delegate;

// 选择的日期:2018-01
- (void)thn_setSelectedDate:(NSString *)dateString;

@end
