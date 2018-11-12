//
//  THNCommentTableView.h
//  lexi
//
//  Created by HongpingRao on 2018/11/6.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 评论内容展示类型

 - CommentTypeSection: 部分评论
 - CommentTypeAll: 全部评论
 */
typedef NS_ENUM(NSUInteger, CommentType) {
    CommentTypeSection,
    CommentTypeAll
};

@protocol THNCommentTableViewDelegate <NSObject>

@required
- (void)replyComment:(NSInteger)pid withSection:(NSInteger)section;

@end

extern NSInteger const maxShowSubComment;

@interface THNCommentTableView : UITableView

- (instancetype)initWithFrame:(CGRect)frame initWithCommentType:(CommentType)commentType;
- (void)setComments:(NSArray *)comments
initWithSubComments:(NSMutableArray *)subComments;
@property (nonatomic, weak) id <THNCommentTableViewDelegate> commentDelegate;
- (void)loadMoreSubCommentData:(NSInteger)section;
@property (nonatomic, assign) BOOL isShopWindow;

@end
