//
//  THNAddShowWindowViewController.h
//  lexi
//
//  Created by HongpingRao on 2018/11/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBaseViewController.h"

typedef void(^AddShowWindowBlock)(NSString *name);

@interface THNAddShowWindowViewController : THNBaseViewController

@property (nonatomic, copy) AddShowWindowBlock addShowWindowBlock;

@end
