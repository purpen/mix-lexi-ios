//
//  THNCashView.h
//  lexi
//
//  Created by FLYang on 2018/12/10.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol THNCashViewDelegate <NSObject>

@optional
/**
 提现金额

 @param amount 金额
 @param mode 方式 0:微信 / 1:支付宝
 */
- (void)thn_didSelectedDoneCashWithAmount:(CGFloat)amount mode:(NSInteger)mode;

@end

@interface THNCashView : UIView

@property (nonatomic, weak) id <THNCashViewDelegate> delegate;

/**
 可提现金额
 */
@property (nonatomic, assign) CGFloat cashAmount;

@end
