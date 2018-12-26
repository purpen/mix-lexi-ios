//
//  THNOrderPayModel.h
//  lexi
//
//  Created by HongpingRao on 2018/10/31.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface THNOrderPayModel : NSObject

@property (nonatomic, strong) NSString *store_name;
@property (nonatomic, assign) NSInteger total_quantity;
@property (nonatomic, assign) CGFloat user_pay_amount;

@end
