//
//  THNSetPasswordView.h
//  lexi
//
//  Created by FLYang on 2018/7/23.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLoginBaseView.h"

typedef NS_ENUM(NSUInteger, THNSetPasswordType) {
    THNSetPasswordTypeNew,
    THNSetPasswordTypeFind
};

@protocol THNSetPasswordViewDelegate <NSObject>

@optional
- (void)thn_setPasswordToRegister:(NSString *)password affirmPassword:(NSString *)affirmPassword;

@end

@interface THNSetPasswordView : THNLoginBaseView

@property (nonatomic, weak) id <THNSetPasswordViewDelegate> delegate;

- (instancetype)initWithType:(THNSetPasswordType)type;

@end
