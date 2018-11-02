//
//  THNPaySuccessTintView.h
//  lexi
//
//  Created by HongpingRao on 2018/11/2.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PaySuccessTintViewBlock)(void);
typedef void(^PaySuccessCloseBlock)(void);

@interface THNPaySuccessTintView : UIView

@property (nonatomic, copy) PaySuccessTintViewBlock paySuccessTintViewBlcok;
@property (nonatomic, copy) PaySuccessCloseBlock paySuccessCloseBlock;

@end
