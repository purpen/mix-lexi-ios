//
//  THNLifeInviteView.h
//  lexi
//
//  Created by FLYang on 2018/12/14.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNInviteCountModel.h"
#import "THNInviteAmountModel.h"

@protocol THNLifeInviteViewDelegate <NSObject>

- (void)thn_lifeInviteCheckFriend;
- (void)thn_lifeInviteCheckMoney;
- (void)thn_lifeInviteMoneyHint;
- (void)thn_lifeInviteApplyStore;

@end

@interface THNLifeInviteView : UIView

@property (nonatomic, weak) id <THNLifeInviteViewDelegate> delegate;

- (void)thn_setLifeInviteCountModel:(THNInviteCountModel *)model;
- (void)thn_setLifeInviteAmountModel:(THNInviteAmountModel *)model;

@end
