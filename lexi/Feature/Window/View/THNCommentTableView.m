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

static NSString *const kCommentSectionHeaderViewidentifier = @"kCommentSectionHeaderViewidentifier";
static NSString *const kCommentSecondCellIdentifier = @"kCommentSecondCellIdentifier";

@interface THNCommentTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) CommentType commentType;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) THNCommentSectionHeaderView *sectionHeaderView;

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
        [self registerNib:[UINib nibWithNibName:@"THNSecondLevelCommentTableViewCell" bundle:nil] forCellReuseIdentifier:kCommentSecondCellIdentifier];
        self.sectionHeaderHeight = 15;
        self.sectionFooterHeight = 15;
        self.backgroundColor = [UIColor whiteColor];
        self.frame = frame;
    }
    return self;
}

- (void)lookAllCommentData {
    
}

- (void)setComments:(NSArray *)comments {
    [self reloadData];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else if (section == 1) {
        return 2;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNSecondLevelCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommentSecondCellIdentifier forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 83;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [tableView dequeueReusableHeaderFooterViewWithIdentifier:kCommentSectionHeaderViewidentifier];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 65;
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
