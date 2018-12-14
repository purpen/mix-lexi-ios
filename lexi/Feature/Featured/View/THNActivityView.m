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
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushGoodListOrderCustomization)]) {
        [self.delegate pushGoodListOrderCustomization];
    }
}

// 领劵
- (IBAction)collarCoupon:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushCouponsCenter)]) {
        [self.delegate pushCouponsCenter];
    }
}

// 包邮专区
- (IBAction)freeShippingArea:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushGoodListShipping)]) {
        [self.delegate pushGoodListShipping];
    }
}

@end
