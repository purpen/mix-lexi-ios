//
//  THNSelectButtonView.h
//  lexi
//
//  Created by HongpingRao on 2018/7/24.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol THNSelectButtonViewDelegate <NSObject>

- (void)selectButtonsDidClickedAtIndex:(NSInteger)index;

@end

@interface THNSelectButtonView : UIView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titleArray;
@property (nonatomic, weak) id <THNSelectButtonViewDelegate> delegate;

@end
