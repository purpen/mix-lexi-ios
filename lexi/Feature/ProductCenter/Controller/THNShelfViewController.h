//
//  THNShelfViewController.h
//  lexi
//
//  Created by HongpingRao on 2018/8/27.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNBaseViewController.h"

@class THNProductModel;

typedef void(^ShelfPopBlock)(void);

@interface THNShelfViewController : THNBaseViewController

@property (nonatomic, strong) THNProductModel *productModel;
@property (nonatomic, copy) ShelfPopBlock shelfPopBlock;

@end
