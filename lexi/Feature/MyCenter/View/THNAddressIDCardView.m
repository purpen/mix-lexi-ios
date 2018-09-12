//
//  THNAddressIDCardView.m
//  lexi
//
//  Created by HongpingRao on 2018/9/11.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNAddressIDCardView.h"

@interface THNAddressIDCardView()

@end

@implementation THNAddressIDCardView

// 上传正面照片
- (IBAction)pushPositive:(id)sender {
    self.openCameraBlcok(PhotoTypePositive);
}

// 上传反面照片
- (IBAction)pushNegative:(id)sender {
    self.openCameraBlcok(PhotoTypeNegative);
}

@end
