//
//  THNSelectButtonView.h
//  lexi
//
//  Created by HongpingRao on 2018/7/24.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 - ButtonTypeDefault: 纯文字
 - ButtonTypeLine: 线状
 */
typedef NS_ENUM(NSUInteger, ButtonType) {
    ButtonTypeDefault,
    ButtonTypeLine
};

@protocol THNSelectButtonViewDelegate <NSObject>

@optional
- (void)selectButtonsDidClickedAtIndex:(NSInteger)index;

@end

@interface THNSelectButtonView : UIView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titleArray initWithButtonType:(ButtonType)type;
@property (nonatomic, weak) id <THNSelectButtonViewDelegate> delegate;
// 默认展示的按钮
@property (nonatomic, assign) NSInteger defaultShowIndex;

@end
