//
//  THNLoginView.h
//  lexi
//
//  Created by FLYang on 2018/7/13.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol THNLoginViewDelegate <NSObject>

@required
- (void)thn_loginViewDidSelectSignUpButton:(UIButton *)button;
- (void)thn_loginViewDidSelectWechatButton:(UIButton *)button;
- (void)thn_loginViewDidSelectSignInButton:(UIButton *)button;

@optional
- (void)thn_loginViewDidSelectSkipButton:(UIButton *)button;

@end

@interface THNLoginView : UIView

@property (nonatomic, weak) id <THNLoginViewDelegate> delegate;

@end
