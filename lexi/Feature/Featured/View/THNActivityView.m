//
//  THNActivityView.m
//  lexi
//
//  Created by HongpingRao on 2018/7/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNActivityView.h"

@implementation THNActivityView

// 活动
- (IBAction)activity:(id)sender {
    
}

// 领劵
- (IBAction)collarCoupon:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushCouponsCenter)]) {
        [self.delegate pushCouponsCenter];
    }
}

// 包邮专区
- (IBAction)freeShippingArea:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushGoodList)]) {
        [self.delegate pushGoodList];
    }
}

@end
