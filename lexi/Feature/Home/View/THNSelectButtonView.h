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
 - ButtonTypeTriangle: 文字和三角形图片
 */
typedef NS_ENUM(NSUInteger, ButtonType) {
    ButtonTypeDefault,
    ButtonTypeTriangle
};

@protocol THNSelectButtonViewDelegate <NSObject>

- (void)selectButtonsDidClickedAtIndex:(NSInteger)index;

@end

@interface THNSelectButtonView : UIView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titleArray initWithButtonType:(ButtonType)type;
@property (nonatomic, weak) id <THNSelectButtonViewDelegate> delegate;

@end
