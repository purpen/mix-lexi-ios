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
- (void)thn_loginDidSelectSignUp;
- (void)thn_loginDidSelectWechat;
- (void)thn_loginDidSelectSignIn;

@optional
- (void)thn_loginDidSelectSkip;

@end

@interface THNLoginView : UIView

@property (nonatomic, weak) id <THNLoginViewDelegate> delegate;

@end
