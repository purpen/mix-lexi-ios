//
//  THNEvaluationViewController.h
//  lexi
//
//  Created by HongpingRao on 2018/10/10.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBaseTableViewController.h"

typedef void(^EvaluationBlock)(void);

@interface THNEvaluationViewController : THNBaseViewController

@property (nonatomic, strong) NSArray *products;
@property (nonatomic, strong) NSString *rid;
@property (nonatomic, copy) EvaluationBlock ealuationBlock;

@end
