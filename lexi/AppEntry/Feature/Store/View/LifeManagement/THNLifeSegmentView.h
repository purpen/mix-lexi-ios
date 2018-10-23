//
//  THNLifeSegmentView.h
//  lexi
//
//  Created by FLYang on 2018/10/8.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNTransactionsDataModel.h"
#import "THNLifeOrderDataModel.h"

@protocol THNLifeSegmentViewDelegate <NSObject>

- (void)thn_didSelectedLifeSegmentIndex:(NSInteger)index;

@end

@interface THNLifeSegmentView : UIView

@property (nonatomic, weak) id <THNLifeSegmentViewDelegate> delegate;

// 交易记录未读消息
- (void)thn_setTransactionReadData:(THNTransactionsDataModel *)model;
// 订单记录未读消息
- (void)thn_setLifeOrderReadData:(THNLifeOrderDataModel *)model;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;

@end
