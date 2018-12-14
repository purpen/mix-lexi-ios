//
//  THNLifeInviteView.h
//  lexi
//
//  Created by FLYang on 2018/12/14.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol THNLifeInviteViewDelegate <NSObject>

- (void)thn_lifeInviteCheckFriend;
- (void)thn_lifeInviteCheckMoney;
- (void)thn_lifeInviteMoneyHint;
- (void)thn_lifeInviteApplyStore;

@end

@interface THNLifeInviteView : UIView

@property (nonatomic, weak) id <THNLifeInviteViewDelegate> delegate;

@end
