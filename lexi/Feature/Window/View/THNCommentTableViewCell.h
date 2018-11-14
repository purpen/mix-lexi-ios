//
//  THNCommentTableViewCell.h
//  lexi
//
//  Created by HongpingRao on 2018/8/23.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THNCommentTableView;

typedef void(^LookCommentBlock)(void);

@interface THNCommentTableViewCell : UITableViewCell

- (void)setComments:(NSArray *)comments
initWithSubComments:(NSMutableArray *)subComments;
@property (nonatomic, strong) THNCommentTableView *commentTableView;
@property (nonatomic, assign) BOOL isShopWindow;

@end
