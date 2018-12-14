//
//  THNLivingHallHeadLineView.h
//  lexi
//
//  Created by HongpingRao on 2018/12/13.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HeadLineViewBlock)(void);

@interface THNLivingHallHeadLineView : UIView

@property (nonatomic, copy) HeadLineViewBlock headLineViewBlock;

@end
