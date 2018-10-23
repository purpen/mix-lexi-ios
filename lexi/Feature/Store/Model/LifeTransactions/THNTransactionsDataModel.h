//
//  THNTransactionsDataModel.h
//  lexi
//
//  Created by FLYang on 2018/10/9.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJExtension/MJExtension.h>

@interface THNTransactionsDataModel : NSObject

@property (nonatomic, assign) NSInteger success_not_read;
@property (nonatomic, assign) NSInteger refund_not_read;
@property (nonatomic, assign) NSInteger not_settlement_not_read;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSArray *transactions;

@end
