//
//  THNActivityView.h
//  lexi
//
//  Created by HongpingRao on 2018/7/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol THNActivityViewDelegate <NSObject>

@optional
- (void)pushGoodList;
- (void)pushCouponsCenter;

@end

@interface THNActivityView : UIView

@property (nonatomic, weak) id <THNActivityViewDelegate> delegate;

@end
