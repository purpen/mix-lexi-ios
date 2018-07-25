//
//  THNAuthCodeButton.h
//  lexi
//
//  Created by FLYang on 2018/7/23.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THNAuthCodeButton;

typedef void(^AuthCodeButtonCompletion)(THNAuthCodeButton *authCodeButton);

@interface THNAuthCodeButton : UIButton

/**
 设置倒计时时间

 @param startTime 开始时间
 @param completion 结束后的回调
 */
- (void)thn_countdownStartTime:(NSTimeInterval)startTime completion:(AuthCodeButtonCompletion)completion;

@end
