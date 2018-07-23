//
//  THNSignUpView.h
//  lexi
//
//  Created by FLYang on 2018/7/13.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNLoginBaseView.h"

@protocol THNSignUpViewDelegate <NSObject>

@required
- (void)thn_signUpSetPassword;
- (void)thn_showZipCodeList;
- (void)thn_directLogin;

@end

@interface THNSignUpView : THNLoginBaseView

@property (nonatomic, weak) id <THNSignUpViewDelegate> delegate;

@end
