//
//  THNTextTool.h
//  lexi
//
//  Created by HongpingRao on 2018/8/10.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface THNTextTool : NSObject

+ (NSMutableAttributedString *)setStrikethrough:(CGFloat)price;
+ (NSMutableAttributedString *)setTextColor:(NSString *)text
                              initWithColor:(NSString *)colorStr
                              initWithRange:(NSRange)range;

@end
