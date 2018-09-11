//
//  THNAddressIDCardView.h
//  lexi
//
//  Created by HongpingRao on 2018/9/11.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OpenCameraBlcok)(void);

@interface THNAddressIDCardView : UIView

@property (nonatomic, copy) OpenCameraBlcok openCameraBlcok;

@end
