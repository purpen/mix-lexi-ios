//
//  UICollectionViewFlowLayout+THN_flowLayout.h
//  lexi
//
//  Created by HongpingRao on 2018/7/27.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionViewFlowLayout (THN_flowLayout)

@property (nonatomic, assign) CGFloat flowLineSpacing;
@property (nonatomic, assign) CGFloat flowWidth;
@property (nonatomic, assign) CGFloat flowHeight;

- (instancetype)initWithLineSpacing:(CGFloat)lineSpacing
                      initWithWidth:(CGFloat)width
                     initwithHeight:(CGFloat)height;

@end
