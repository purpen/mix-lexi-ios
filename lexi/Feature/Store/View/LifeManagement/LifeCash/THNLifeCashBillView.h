//
//  THNLifeCashBillView.h
//  lexi
//
//  Created by FLYang on 2018/10/8.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol THNLifeCashBillViewDelegate <NSObject>

// 查看对账单
- (void)thn_checkLifeCashBill;

@end

@interface THNLifeCashBillView : UIView

@property (nonatomic, weak) id <THNLifeCashBillViewDelegate> delegate;

// 最近提现金额
- (void)thn_setLifeCashRecentPrice:(CGFloat)price;

@end
