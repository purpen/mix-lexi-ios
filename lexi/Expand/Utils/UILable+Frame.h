//
//  UILable+Frame.h
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Frame)

/**
 获取 UILable 的 size
 */
- (CGSize)boundingRectWithSize:(CGSize)size;

@end
