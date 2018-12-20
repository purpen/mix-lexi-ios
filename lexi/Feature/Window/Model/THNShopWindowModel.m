//
//  THNShopWindowModel.m
//  lexi
//
//  Created by HongpingRao on 2018/8/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNShopWindowModel.h"
#import <UIKit/UIKit.h>
#import "THNMarco.h"

@implementation THNShopWindowModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"des":@"description"
             };
}

- (void)setDes:(NSString *)des {
    _des = des;
    CGFloat fixedHeight = _keywords.count == 0 ? 113 : 135;
    CGFloat titleHeight = [self getSizeByString:_title withFontSize:[UIFont fontWithName:@"PingFangSC-Medium" size:15] withMaxWidth:SCREEN_WIDTH - 35];
    CGFloat contentHeight = [self getSizeByString:des withFontSize:[UIFont fontWithName:@"PingFangSC-Regular" size:14] withMaxWidth:SCREEN_WIDTH - 35];
    CGFloat otherHeight = fixedHeight + titleHeight + contentHeight;
    
    _cellHeight = (SCREEN_WIDTH - 2) * 2/3 + otherHeight;
}

//获取字符串高度的方法
- (CGFloat)getSizeByString:(NSString *)string withFontSize:(UIFont *)font withMaxWidth:(CGFloat)maxWidth
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(maxWidth, 999) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
    return size.height;
}

@end
