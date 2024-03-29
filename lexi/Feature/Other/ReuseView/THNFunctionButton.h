//
//  THNFunctionButton.h
//  lexi
//
//  Created by FLYang on 2018/8/29.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THNFunctionButton : UIButton

/**
 图标
 */
@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, assign) BOOL iconHidden;

/**
 加粗
 */
@property (nonatomic, assign) BOOL isBold;

/**
 标题
 */
@property (nonatomic, copy) NSString *title;

/**
 初始标题
 */
@property (nonatomic, copy) NSString *defaultTitle;

/**
 选中
 */
@property (nonatomic, assign) BOOL isSelected;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;

@end
