//
//  THNContentTableViewController.h
//  lexi
//
//  Created by HongpingRao on 2018/8/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNBaseViewController.h"

UIKIT_EXTERN NSString *const kUrlAddComment;

@interface THNCommentViewController : THNBaseViewController

@property (nonatomic, strong) NSString *rid;
// 评论数
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, assign) BOOL isFromShopWindow;


@end
