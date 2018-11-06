//
//  THNCommentTableViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/8/23.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNCommentTableViewCell.h"
#import "THNCommentTableView.h"

@interface THNCommentTableViewCell ()

@property (nonatomic, strong) THNCommentTableView *commentTableView;

@end

@implementation THNCommentTableViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    self.commentTableView = [[THNCommentTableView alloc]initWithFrame:self.bounds initWithCommentType:CommentTypeSection];
    [self addSubview:self.commentTableView];
}

- (void)setComments:(NSArray *)comments {
    self.commentTableView.comments = comments;
}

@end
