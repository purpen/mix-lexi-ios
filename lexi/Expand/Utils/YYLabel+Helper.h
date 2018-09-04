//
//  YYLabel+Helper.h
//  lexi
//
//  Created by FLYang on 2018/8/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <YYKit/YYKit.h>

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

/**
 获取文本布局大小

 @param text 文本
 @param fontSize 字体大小
 @param lineSpacing 行高
 @param fixSize 固定尺寸
 @return 大小
 */
+ (CGSize)thn_getYYLabelTextLayoutSizeWithText:(NSString *)text
                                      fontSize:(NSInteger)fontSize
                                   lineSpacing:(NSInteger)lineSpacing
                                       fixSize:(CGSize)fixSize;

@end
