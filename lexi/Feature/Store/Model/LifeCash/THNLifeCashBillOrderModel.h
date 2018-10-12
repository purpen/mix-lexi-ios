//
//  THNLifeCashBillOrderModel.h
//  lexi
//
//  Created by FLYang on 2018/10/10.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJExtension/MJExtension.h>

@interface THNLifeCashBillOrderModel : NSObject

@property (nonatomic, assign) CGFloat commission_price;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *order_id;

@end
