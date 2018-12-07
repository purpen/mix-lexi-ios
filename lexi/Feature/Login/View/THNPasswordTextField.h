//
//  THNPasswordTextField.h
//  lexi
//
//  Created by FLYang on 2018/7/31.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THNPasswordTextField : UIView

/**
 获取输入的文字内容
 */
@property (nonatomic, strong) NSString *text;

/**
 根据占位文字初始化
 */
- (instancetype)initWithPlaceholderText:(NSString *)placeholder;

@end
