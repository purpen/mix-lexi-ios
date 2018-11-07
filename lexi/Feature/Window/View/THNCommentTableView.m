//
//  THNCommentTableView.m
//  lexi
//
//  Created by HongpingRao on 2018/11/6.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNCommentTableView.h"
#import "THNMarco.h"
#import "UIColor+Extension.h"
#import "UIView+Helper.h"
#import "THNCommentSectionHeaderView.h"
#import "THNSecondLevelCommentTableViewCell.h"
#import "THNSectionSecondLevelCommentTableViewCell.h"
#import "THNCommentModel.h"
#import <MJExtension/MJExtension.h>

static NSString *const kCommentSectionHeaderViewidentifier = @"kCommentSectionHeaderViewidentifier";
static NSString *const kCommentSecondCellIdentifier = @"kCommentSecondCellIdentifier";
static NSString *const kCommentSectionSecondCellIdentifier = @"kCommentSectionSecondCellIdentifier";

@interface THNCommentTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) CommentType commentType;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) THNCommentSectionHeaderView *sectionHeaderView;
@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) NSMutableArray *subComments;
@property (nonatomic, strong) NSString *shopWindowRid;

@end

@implementation THNCommentTableView

- (instancetype)initWithFrame:(CGRect)frame initWithCommentType:(CommentType)commentType {
    self.commentType = commentType;
    return [self initWithFrame:frame style:UITableViewStyleGrouped];
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if ([super initWithFrame:frame style:style]) {
        
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableHeaderView = self.headerView;
        self.tableFooterView = self.footView;
        [self registerNib:[UINib nibWithNibName:@"THNCommentSectionHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:kCommentSectionHeaderViewidentifier];
        
        if (self.commentType == CommentTypeSection) {
             [self registerNib:[UINib nibWithNibName:@"THNSectionSecondLevelCommentTableViewCell" bundle:nil] forCellReuseIdentifier:kCommentSectionSecondCellIdentifier];
        } else {
             [self registerNib:[UINib nibWithNibName:@"THNSecondLevelCommentTableViewCell" bundle:nil] forCellReuseIdentifier:kCommentSecondCellIdentifier];
        }
       
        self.sectionHeaderHeight = 15;
        self.sectionFooterHeight = 15;
        self.backgroundColor = [UIColor whiteColor];
        self.frame = frame;
    }
    return self;
}

- (void)lookAllCommentData {
    
}

- (void)setComments:(NSArray *)comments initWithSubComments:(NSMutableArray *)subComments initWithRid:(NSString *)rid {
    self.comments = comments;
    self.subComments = subComments;
    self.shopWindowRid = rid;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.comments.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.subComments[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNCommentModel *commentModel = self.comments[indexPath.section];
    THNCommentModel *subCommentModel = [THNCommentModel mj_objectWithKeyValues:self.subComments[indexPath.section][indexPath.row]];
    if (self.commentType == CommentTypeSection) {
        THNSectionSecondLevelCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommentSectionSecondCellIdentifier forIndexPath:indexPath];
        cell.subCommentCount = commentModel.sub_comment_count;
        [cell setSubCommentModel:subCommentModel];
        return cell;
    } else {
        THNSecondLevelCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommentSecondCellIdentifier forIndexPath:indexPath];
        return cell;
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNCommentModel *subCommentModel = [THNCommentModel mj_objectWithKeyValues:self.subComments[indexPath.section][indexPath.row]];
    if (subCommentModel.height) {
        return subCommentModel.height + 18;
    } else {
        return 32;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    THNCommentSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kCommentSectionHeaderViewidentifier];
    headerView.shopWindowRid = self.shopWindowRid;
    [headerView setCommentModel:self.comments[section]];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    THNCommentModel *commentModel = self.comments[section];
    return commentModel.height + 45;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView  [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
//    return
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 15;
//}

#pragma makr - lazy
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, SCREEN_WIDTH - 20, 13)];
        label.text = @"评论";
        label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        label.textColor = [UIColor colorWithHexString:@"333333"];
        [_headerView addSubview:label];
    }
    return _headerView;
}

- (UIView *)footView {
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 41)];
        UIView *lineView = [UIView initLineView:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        [_footView addSubview:lineView];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH, 40)];
        [button setTitle:@"查看所有评论" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(lookAllCommentData) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [_footView addSubview:button];
    }
    return _footView;
}

- (THNCommentSectionHeaderView *)sectionHeaderView {
    if (!_sectionHeaderView) {
        _sectionHeaderView = [THNCommentSectionHeaderView viewFromXib];
    }
    return _sectionHeaderView;
}

@end
