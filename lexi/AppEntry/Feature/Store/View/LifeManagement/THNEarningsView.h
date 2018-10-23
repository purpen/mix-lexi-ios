//
//  THNEarningsView.h
//  lexi
//
//  Created by FLYang on 2018/10/7.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNLifeSaleCollectModel.h"

@protocol THNEarningsViewDelegate <NSObject>

@optional
// 查看交易记录
- (void)thn_checkLifeTransactionRecord;
// 待结算提示
- (void)thn_showCashHintText;

@end

@interface THNEarningsView : UIView

@property (nonatomic, weak) id <THNEarningsViewDelegate> delegate;

- (void)thn_setLifeSaleColleciton:(THNLifeSaleCollectModel *)model;

@end
