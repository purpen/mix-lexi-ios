//
//  THNSelectWindowProductViewController.h
//  lexi
//
//  Created by HongpingRao on 2018/11/14.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBaseViewController.h"

typedef void(^SelectWindowBlcok)(NSString *cover,
                                 NSInteger coverID,
                                 NSString *productRid,
                                 NSString *storeRid);

@interface THNSelectWindowProductViewController : THNBaseViewController

@property (nonatomic, copy) SelectWindowBlcok selectWindowBlock;
@property (nonatomic, strong) NSArray *storeRids;

@end
