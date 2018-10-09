//
//  THNTransactionsModel.h
//  lexi
//
//  Created by FLYang on 2018/10/9.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJExtension/MJExtension.h>

@interface THNTransactionsModel : NSObject

@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) CGFloat actual_amount;
@property (nonatomic, strong) NSString *order_rid;
@property (nonatomic, strong) NSString *payed_at;

@end
