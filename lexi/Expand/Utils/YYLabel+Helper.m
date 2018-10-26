//
//  YYLabel+Helper.m
//  lexi
//
//  Created by FLYang on 2018/8/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "YYLabel+Helper.h"
#import <YYKit/NSAttributedString+YYText.h>

@implementation YYLabel (Helper)

- (CGFloat)thn_getLabelHeightWithMaxWidth:(CGFloat)width {
    CGSize textSize = CGSizeMake(width, CGFLOAT_MAX);
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainerSize:textSize text:self.attributedText];
    
    return textLayout.textBoundingSize.height;
}

- (CGFloat)thn_getLabelWidthWithMaxHeight:(CGFloat)height {
    CGSize textSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainerSize:textSize text:self.attributedText];
    
    return textLayout.textBoundingSize.width;
}

- (NSMutableAttributedString *)thn_getAttributedStringWithText:(NSString *)text {
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    
    return attStr;
}

+ (CGSize)thn_getYYLabelTextLayoutSizeWithText:(NSString *)text
                                      fontSize:(NSInteger)fontSize
                                   lineSpacing:(NSInteger)lineSpacing
                                       fixSize:(CGSize)fixSize {
    
    NSMutableAttributedString *textAtt = [[NSMutableAttributedString alloc] initWithString:text];
    textAtt.font = [UIFont systemFontOfSize:fontSize];
    textAtt.lineSpacing = lineSpacing;
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:fixSize text:textAtt];
    
    return layout.textBoundingSize;
}

@end