//
//  THNZipCodeViewController.h
//  lexi
//
//  Created by FLYang on 2018/7/23.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBaseViewController.h"

@interface THNZipCodeViewController : THNBaseViewController

/**
 选择的区号
 */
@property (nonatomic, copy) void (^SelectAreaCode)(NSString *code);

@end
