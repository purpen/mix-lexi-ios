//
//  THNLifeCashBillDataModel.h
//  lexi
//
//  Created by FLYang on 2018/10/8.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJExtension/MJExtension.h>

@interface THNLifeCashBillDataModel : NSObject

@property (nonatomic, strong) NSArray *statements;
@property (nonatomic, assign) CGFloat total_amount;

@end
