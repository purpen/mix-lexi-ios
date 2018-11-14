//
//  THNToolBarView.h
//  newDemo
//
//  Created by HongpingRao on 2018/8/22.
//  Copyright © 2018年 Hongping Rao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYTextView;

@protocol THNToolBarViewDelegate <NSObject>

@optional
- (void)addComment:(NSString *)text;
- (void)changeKeyboardType:(UIButton *)button;

@end

@interface THNToolBarView : UIView

@property (nonatomic, weak) id <THNToolBarViewDelegate> delegate;
@property (nonatomic, strong) YYTextView *textView;
@property (nonatomic, assign) BOOL isNoNeedAddTextView;

@end
