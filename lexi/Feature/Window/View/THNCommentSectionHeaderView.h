//
//  THNSectionHeaderView.h
//  lexi
//
//  Created by HongpingRao on 2018/11/6.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kUrlCommentsPraises;

typedef void(^CommentReplyBlock)(NSInteger pid);

@class THNCommentModel;

@interface THNCommentSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) THNCommentModel *commentModel;
@property (nonatomic, assign) BOOL isShopWindow;
@property (nonatomic, copy) CommentReplyBlock replyBlcok;

@end
