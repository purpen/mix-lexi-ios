//
//  THNLifeOrderModel.h
//  lexi
//
//  Created by FLYang on 2018/10/9.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJExtension/MJExtension.h>

@interface THNLifeOrderModel : NSObject

@property (nonatomic, strong) NSString *rid;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, assign) CGFloat pay_amount;
@property (nonatomic, assign) CGFloat order_total_commission_price;
@property (nonatomic, assign) NSInteger life_order_status;
@property (nonatomic, strong) NSDictionary *store;
@property (nonatomic, strong) NSDictionary *user_info;
@property (nonatomic, strong) NSArray *items;

@end
