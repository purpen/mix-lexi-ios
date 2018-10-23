//
//  THNCountdown.h
//  lexi
//
//  Created by FLYang on 2018/10/9.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THNCountdown : NSObject

// 用时间戳倒计时
- (void)thn_countDownWithStratTimeStamp:(long long)starTimeStamp
                        finishTimeStamp:(long long)finishTimeStamp
                          completeBlock:(void (^)(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second))completeBlock;

// 销毁计时器
- (void)destoryTimer;

@end
