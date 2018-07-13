//
//  UILable+Frame.m
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "UILable+Frame.h"

@implementation UILabel (Frame)

#pragma mark 获取UILable的size
- (CGSize)boundingRectWithSize:(CGSize)size {
    NSDictionary *attribute = @{NSFontAttributeName:self.font};
    
    CGSize retSize = [self.text boundingRectWithSize:size
                                             options:NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    return retSize;
}

@end
