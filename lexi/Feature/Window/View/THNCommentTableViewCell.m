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

@end

@implementation THNCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.commentTableView = [[THNCommentTableView alloc]initWithFrame:self.bounds initWithCommentType:CommentTypeSection];
    [self addSubview:self.commentTableView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.commentTableView.frame = self.bounds;
}

- (void)setComments:(NSArray *)comments initWithSubComments:(NSMutableArray *)subComments{
    self.commentTableView.isShopWindow = self.isShopWindow;
    [self.commentTableView setComments:comments initWithSubComments:subComments];
}

@end
