//
//  THNNewUserInfoView.h
//  lexi
//
//  Created by FLYang on 2018/7/24.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLoginBaseView.h"

@interface THNNewUserInfoView : THNLoginBaseView

/**
 头像图片
 */
- (void)setHeaderImage:(UIImage *)image;

/**
 确认用户信息
 */
@property (nonatomic, copy) void (^NewUserInfoEditDoneBlock)(void);

/**
 选择头像图片
 */
@property (nonatomic, copy) void (^NewUserInfoSelectHeaderBlock)(void);

@end
