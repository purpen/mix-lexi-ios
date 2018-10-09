//
//  THNLifeCashBillModel.h
//  lexi
//
//  Created by FLYang on 2018/10/8.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJExtension/MJExtension.h>

@interface THNLifeCashBillModel : NSObject

@property (nonatomic, assign) CGFloat actual_account_amount;
@property (nonatomic, assign) CGFloat actual_amount;
@property (nonatomic, assign) CGFloat service_fee;
@property (nonatomic, assign) NSInteger created_at;
@property (nonatomic, assign) NSInteger receive_target;
@property (nonatomic, assign) NSInteger record_id;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger store_rid;

@end
