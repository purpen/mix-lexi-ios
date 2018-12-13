//
//  THNCashMoneyView.h
//  lexi
//
//  Created by FLYang on 2018/12/10.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNCashBaseView.h"

@protocol THNCashMoneyViewDelegate <NSObject>

- (void)thn_didSelectedCashMoneyIndex:(NSInteger)index;

@end

@interface THNCashMoneyView : THNCashBaseView

@property (nonatomic, assign) CGFloat cashAmount;
@property (nonatomic, weak) id <THNCashMoneyViewDelegate> delegate;

@end
