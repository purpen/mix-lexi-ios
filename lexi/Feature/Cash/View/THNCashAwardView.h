//
//  THNCashAwardView.h
//  lexi
//
//  Created by FLYang on 2018/12/14.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol THNCashAwardViewDelegate <NSObject>

- (void)thn_cashAwardMoney;
- (void)thn_showCashHintText;

@end

@interface THNCashAwardView : UIView

@property (nonatomic, weak) id <THNCashAwardViewDelegate> delegate;

@end
