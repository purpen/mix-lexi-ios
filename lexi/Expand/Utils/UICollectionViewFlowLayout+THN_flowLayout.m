//
//  UICollectionViewFlowLayout+THN_flowLayout.m
//  lexi
//
//  Created by HongpingRao on 2018/7/27.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "UICollectionViewFlowLayout+THN_flowLayout.h"
#import <objc/runtime.h>

static NSString * const kFlowLineSpacing = @"kFlowLineSpacing";
static NSString * const kFlowWidth = @"kFlowWidth";
static NSString * const kFlowHeight = @"kFlowHeight";

@implementation UICollectionViewFlowLayout (THN_flowLayout)

- (instancetype)initWithLineSpacing:(CGFloat)lineSpacing initWithWidth:(CGFloat)width initwithHeight:(CGFloat)height {
    self.flowLineSpacing = lineSpacing;
    self.flowWidth = width;
    self.flowHeight = height;
    return [self init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.minimumLineSpacing = self.flowLineSpacing;
        self.itemSize = CGSizeMake(self.flowWidth, self.flowHeight);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}



- (CGFloat)flowLineSpacing {
    return [objc_getAssociatedObject(self, &kFlowLineSpacing) floatValue];
}

- (void)setFlowLineSpacing:(CGFloat)flowLineSpacing {
    return objc_setAssociatedObject(self, &kFlowLineSpacing, [NSString stringWithFormat:@"%f",flowLineSpacing], OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)flowWidth {
    return [objc_getAssociatedObject(self, &kFlowWidth) floatValue];
}

- (void)setFlowWidth:(CGFloat)flowWidth {
     return objc_setAssociatedObject(self, &kFlowWidth, [NSString stringWithFormat:@"%f",flowWidth], OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)flowHeight {
    return [objc_getAssociatedObject(self, &kFlowHeight) floatValue];
}

- (void)setFlowHeight:(CGFloat)flowHeight {
    return objc_setAssociatedObject(self, &kFlowHeight, [NSString stringWithFormat:@"%f",flowHeight], OBJC_ASSOCIATION_ASSIGN);
}


@end
