//
//  YYLabel+Helper.h
//  lexi
//
//  Created by FLYang on 2018/8/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <YYText/YYText.h>

@interface YYLabel (Helper)

/**
 获取 label 的高度
 
 @param width 限制宽度
 @return 高度
 */
- (CGFloat)thn_getLabelHeightWithMaxWidth:(CGFloat)width;

/**
 获取 label 的宽度
 
 @param height 限制高度
 @return 宽度
 */
- (CGFloat)thn_getLabelWidthWithMaxHeight:(CGFloat)height;

/**
 获取可变属性字符串

 @param text 文字
 @return 字符串
 */
- (NSMutableAttributedString *)thn_getAttributedStringWithText:(NSString *)text;

@end
