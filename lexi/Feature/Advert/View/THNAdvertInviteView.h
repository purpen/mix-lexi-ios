//
//  THNAdvertInviteView.h
//  lexi
//
//  Created by FLYang on 2018/12/13.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AdvertInviteDoneBlock)(void);

@interface THNAdvertInviteView : UIView

@property (nonatomic, copy) AdvertInviteDoneBlock advertInviteDoneBlock;

/**
 展示/消失视图
 */
- (void)show;
- (void)dismiss;

@end
