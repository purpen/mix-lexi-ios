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

@implementation THNTextTool

+ (NSMutableAttributedString *)setStrikethrough:(CGFloat)price {
    
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%2.f",price] attributes:attribtDic];
    return attribtStr;
}

+ (NSMutableAttributedString *)setTextColor:(NSString *)text initWithColor:(NSString *)colorStr initWithRange:(NSRange)range {
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:text];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:colorStr] range:range];
    return attributedStr;
}

@end
