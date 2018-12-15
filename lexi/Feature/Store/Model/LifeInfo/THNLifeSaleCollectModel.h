//
//  THNLifeSaleCollectModel.h
//  lexi
//
//  Created by FLYang on 2018/10/7.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJExtension/MJExtension.h>

@interface THNLifeSaleCollectModel : NSObject

@property (nonatomic, assign) CGFloat pending_commission_price;
@property (nonatomic, assign) CGFloat today_commission_price;
@property (nonatomic, assign) CGFloat total_commission_price;
@property (nonatomic, assign) CGFloat total_payed_amount;

@end
