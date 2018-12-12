//
//  THNDoneButton.h
//  lexi
//
//  Created by FLYang on 2018/7/23.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THNDoneButton : UIView

/**
 初始化功能按钮

 @param frame 结构
 @param title 标题
 @param completion 点击事件
 @return 功能按钮
 */
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title completion:(void (^)(void))completion;

@end
