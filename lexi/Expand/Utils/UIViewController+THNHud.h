//
//  UIViewController+THNHud.h
//  lexi
//
//  Created by rhp on 2018/10/13.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (THNHud)

@property(nonatomic, assign) CGFloat loadViewY;
// 是否透明
@property (nonatomic, assign) BOOL isTransparent;
@property (nonatomic, assign) BOOL isAddWindow;
@property (nonatomic, assign) BOOL isFromMain;

- (void)showHud;
- (void)hiddenHud;

@end
