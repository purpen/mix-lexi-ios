//
//  UIViewController+THNHud.h
//  lexi
//
//  Created by rhp on 2018/10/13.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (THNHud)

@property(nonatomic, assign)CGFloat loadHeight;
- (void)showHud;
- (void)hiddenHud;
//- (void)localShowHud;
//- (void)localHiddenHud;

@end
