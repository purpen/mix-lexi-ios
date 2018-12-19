//
//  THNCertificationStatusView.h
//  lexi
//
//  Created by FLYang on 2018/12/19.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol THNCertificationStatusViewDelegate <NSObject>

- (void)thn_certificationStatusViewDoneAction;

@end

@interface THNCertificationStatusView : UIView

@property (nonatomic, weak) id <THNCertificationStatusViewDelegate> delegate;

@end
