//
//  THNLifeDataView.h
//  lexi
//
//  Created by FLYang on 2018/10/7.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNLifeOrdersCollectModel.h"
#import "THNLifeCashCollectModel.h"

@protocol THNLifeDataViewDelegate <NSObject>

// 查看订单记录
- (void)thn_checkLifeOrderRecord;
// 查看可提现金额
- (void)thn_checkLifeCashMoney;

@end

@interface THNLifeDataView : UIView

@property (nonatomic, weak) id <THNLifeDataViewDelegate> delegate;

// 订单汇总
- (void)thn_setLifeOrdersCollecitonModel:(THNLifeOrdersCollectModel *)model;

// 提现汇总
- (void)thn_setLifeCashCollectModel:(THNLifeCashCollectModel *)model;

@end
