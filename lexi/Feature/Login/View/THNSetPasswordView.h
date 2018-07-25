//
//  THNSetPasswordView.h
//  lexi
//
//  Created by FLYang on 2018/7/23.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLoginBaseView.h"

@interface THNSetPasswordView : THNLoginBaseView

/**
 设置完成密码，注册
 */
@property (nonatomic, copy) void (^SetPasswordRegisterBlock)(void);

@end
