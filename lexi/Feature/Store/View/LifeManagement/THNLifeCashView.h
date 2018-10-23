//
//  THNLifeCashView.h
//  lexi
//
//  Created by FLYang on 2018/10/8.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNLifeCashCollectModel.h"

@protocol THNLifeCashViewDelegate <NSObject>

// 生活馆提现
- (void)thn_checkLifeCash;

@end

@interface THNLifeCashView : UIView

@property (nonatomic, weak) id <THNLifeCashViewDelegate> delegate;

- (void)thn_setLifeCashCollect:(THNLifeCashCollectModel *)model;

@end
