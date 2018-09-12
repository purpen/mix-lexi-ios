//
//  THNAddressIDCardView.h
//  lexi
//
//  Created by HongpingRao on 2018/9/11.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 照片类型

 - PhotoTypePositive: 正面
 - PhotoTypeNegative: 反面
 */
typedef NS_ENUM(NSUInteger, PhotoType) {
    PhotoTypePositive,
    PhotoTypeNegative
};

typedef void(^OpenCameraBlcok)(PhotoType photoType);

@interface THNAddressIDCardView : UIView

@property (nonatomic, copy) OpenCameraBlcok openCameraBlcok;
@property (weak, nonatomic) IBOutlet UIButton *positiveButton;
@property (weak, nonatomic) IBOutlet UIButton *negativeButton;

@end
