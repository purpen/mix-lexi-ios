//
//  THNPopularSingleProductTableViewController.h
//  lexi
//
//  Created by HongpingRao on 2018/8/24.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ArrayCountBlock)(NSInteger count);

@interface THNPopularSingleProductTableViewController : UITableViewController

@property (nonatomic, copy)  ArrayCountBlock arrayCountBlock;

@end
