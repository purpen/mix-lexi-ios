//
//  THNSelectWindowProductViewController.h
//  lexi
//
//  Created by HongpingRao on 2018/11/14.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBaseViewController.h"

typedef void(^SelectWindowBlcok)(NSString *cover);

@interface THNSelectWindowProductViewController : THNBaseViewController

@property (nonatomic, copy) SelectWindowBlcok selectWindowBlock;

@end
