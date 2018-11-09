//
//  THNTextTool.m
//  lexi
//
//  Created by HongpingRao on 2018/8/10.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNTextTool.h"
#import <UIKit/UIKit.h>
#import "UIColor+Extension.h"
#import "NSString+Helper.h"

@implementation THNTextTool

/**
 价格增加删除线

 @param price 价格
 @return 价格带删除线富文本
 */
+ (NSMutableAttributedString *)setStrikethrough:(CGFloat)price {
    
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString formatFloat:price] attributes:attribtDic];
    return attribtStr;
}

/**
 改变文体区间的颜色

 @param text 文本
 @param colorStr 改变的颜色
 @param range 区间
 @return 区间颜色改变的富文本
 */
+ (NSMutableAttributedString *)setTextColor:(NSString *)text initWithColor:(NSString *)colorStr initWithRange:(NSRange)range {
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:text];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:colorStr] range:range];
    return attributedStr;
}



@end
