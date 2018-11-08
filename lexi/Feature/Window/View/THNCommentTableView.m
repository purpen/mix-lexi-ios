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
#import "THNSaveTool.h"
#import "THNConst.h"

static NSString *const kCommentSectionHeaderViewidentifier = @"kCommentSectionHeaderViewidentifier";
static NSString *const kCommentSecondCellIdentifier = @"kCommentSecondCellIdentifier";
static NSString *const kCommentSectionSecondCellIdentifier = @"kCommentSectionSecondCellIdentifier";
static CGFloat const loadViewHeight = 30;
static CGFloat allSubCommentHeight = 66;
NSInteger const maxShowSubComment = 2;

@interface THNCommentTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) CommentType commentType;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) THNCommentSectionHeaderView *sectionHeaderView;
@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) NSMutableArray *subComments;
@property (nonatomic, strong) NSArray *sectionSubComments;
@property (nonatomic, strong) NSString *shopWindowRid;
@property (nonatomic, assign) NSInteger allCommentCount;
@property (nonatomic, strong) UIView *loadMoreView;
@property (nonatomic, strong) THNCommentModel *commentModel;

@end

@implementation THNCommentTableView

- (instancetype)initWithFrame:(CGRect)frame initWithCommentType:(CommentType)commentType {
    self.commentType = commentType;
   self.allCommentCount = [[THNSaveTool objectForKey:@"kCommentCount"] integerValue];
    return [self initWithFrame:frame style:UITableViewStyleGrouped];
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if ([super initWithFrame:frame style:style]) {
        
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.showsVerticalScrollIndicator = NO;
       
        if (self.commentType == CommentTypeSection) {
            if (self.allCommentCount > 3) {
                self.tableFooterView = self.footView;
            }
             self.tableHeaderView = self.headerView;
        }
        
        [self registerNib:[UINib nibWithNibName:@"THNCommentSectionHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:kCommentSectionHeaderViewidentifier];
        
        if (self.commentType == CommentTypeSection) {
             [self registerNib:[UINib nibWithNibName:@"THNSectionSecondLevelCommentTableViewCell" bundle:nil] forCellReuseIdentifier:kCommentSectionSecondCellIdentifier];
            self.scrollEnabled = NO;
        } else {
            self.scrollEnabled = YES;
            [self registerNib:[UINib nibWithNibName:@"THNSecondLevelCommentTableViewCell" bundle:nil] forCellReuseIdentifier:kCommentSecondCellIdentifier];
        }
        
        self.backgroundColor = [UIColor whiteColor];
        self.frame = frame;
    }
    return self;
}

- (void)lookAllCommentData {
    [[NSNotificationCenter defaultCenter]postNotificationName:kLookAllCommentData object:nil];
}

- (void)setComments:(NSArray *)comments initWithSubComments:(NSMutableArray *)subComments initWithRid:(NSString *)rid {
    self.comments = comments;
    self.subComments = subComments;
    self.shopWindowRid = rid;
}

- (void)loadMoreSubCommentData {
    
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
    self.commentModel = self.comments[indexPath.section];
    self.sectionSubComments = self.subComments[indexPath.section];
    THNCommentModel *subCommentModel = [THNCommentModel mj_objectWithKeyValues:self.sectionSubComments[indexPath.row]];

    if (self.commentType == CommentTypeSection) {
        THNSectionSecondLevelCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommentSectionSecondCellIdentifier forIndexPath:indexPath];
        cell.subCommentCount = self.commentModel.sub_comment_count;
        
        if (indexPath.row == 0) {
            if (self.sectionSubComments.count == 1) {
                [cell drawCornerWithType:UILayoutCornerRadiusAll radius:4];
            } else {
                [cell drawCornerWithType:UILayoutCornerRadiusTop radius:4];
            }
            
        } else if (indexPath.row == self.sectionSubComments.count - 1) {
            [cell drawCornerWithType:UILayoutCornerRadiusBottom radius:4];
        }
        
        [cell setSubCommentModel:subCommentModel];
        return cell;
    } else {
        THNSecondLevelCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommentSecondCellIdentifier forIndexPath:indexPath];
        
        if (indexPath.row == 0) {
            if (self.sectionSubComments.count == 1) {
                [cell drawCornerWithType:UILayoutCornerRadiusAll radius:4];
            } else {
                [cell drawCornerWithType:UILayoutCornerRadiusTop radius:4];
            }
        } else if (indexPath.row == self.sectionSubComments.count - 1) {
            if (self.commentModel.sub_comment_count > maxShowSubComment) {
                self.loadMoreView.frame = CGRectMake(0, subCommentModel.height + allSubCommentHeight, SCREEN_WIDTH - 82, loadViewHeight);
                [cell.contentView addSubview:self.loadMoreView];
                [cell drawCornerWithType:UILayoutCornerRadiusBottom radius:4];
            } else {
                [cell drawCornerWithType:UILayoutCornerRadiusBottom radius:4];
            }
        }
        
        [cell setSubCommentModel:subCommentModel];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNCommentModel *subCommentModel = [THNCommentModel mj_objectWithKeyValues:self.subComments[indexPath.section][indexPath.row]];
    if (subCommentModel.height) {
        CGFloat allSubcommentHeight = 0;
        if (self.commentModel.sub_comment_count > maxShowSubComment && indexPath.row == self.sectionSubComments.count - 1) {
            allSubcommentHeight = subCommentModel.height + allSubCommentHeight + loadViewHeight;
        } else if (indexPath.row == self.sectionSubComments.count - 1) {
            allSubcommentHeight = subCommentModel.height + allSubCommentHeight + 10;
        } else {
            allSubcommentHeight = subCommentModel.height + allSubCommentHeight;
        }
        
        return self.commentType == CommentTypeSection ? subCommentModel.height + 18 : allSubcommentHeight;
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
    return self.commentType == CommentTypeSection ? commentModel.height + 45 : commentModel.height + 55 ;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"lineView"];
    if (!_footView) {
        // 有子评论间距加15
        NSArray *array = self.subComments[section];
        CGFloat footerViewHeight = array.count > 0 ? 30.5 : 15.5;
        CGFloat lineViewY = array.count > 0 ? 15 : 0;
        footerView = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"lineView"];
        footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, footerViewHeight);
        
        if (self.commentType == CommentTypeAll && section != self.comments.count - 1) {
            [footerView addSubview:[UIView initLineView:CGRectMake(0, lineViewY, SCREEN_WIDTH, 0.5)]];
        }
    }
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.commentType == CommentTypeAll) {
        // 有子评论间距加15
        NSArray *array = self.subComments[section];
        CGFloat footerViewHeight = array.count > 0 ? 30.5 : 15.5;
        return footerViewHeight;
    } else {
        return 15.5;
    }
}

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
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40.5)];
        UIView *lineView = [UIView initLineView:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        [_footView addSubview:lineView];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH, 40.5)];
        NSString *btnTitle = [NSString stringWithFormat:@"查看全部%ld条评论",self.allCommentCount];
        [button setTitle:btnTitle forState:UIControlStateNormal];
        [button addTarget:self action:@selector(lookAllCommentData) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [_footView addSubview:button];
    }
    return _footView;
}

- (UIView *)loadMoreView {
    if (!_loadMoreView) {
        _loadMoreView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 82, loadViewHeight)];
        UIButton *loadMoreButton = [[UIButton alloc]initWithFrame:_loadMoreView.bounds];
        [loadMoreButton setTitle:[NSString stringWithFormat:@"查看%ld条回复",self.commentModel.sub_comment_count] forState:UIControlStateNormal];
        loadMoreButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [loadMoreButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        loadMoreButton.imageEdgeInsets = UIEdgeInsetsMake(0, 125, 0, 0);
        loadMoreButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 50);
        [loadMoreButton setImage:[UIImage imageNamed:@"icon_arrow_down"] forState:UIControlStateNormal];
        [loadMoreButton addTarget:self action:@selector(loadMoreSubCommentData) forControlEvents:UIControlEventTouchUpInside];
        loadMoreButton.backgroundColor = [UIColor colorWithHexString:@"F5F7F9"];
        [_loadMoreView drawCornerWithType:UILayoutCornerRadiusBottom radius:4];
        [_loadMoreView addSubview:loadMoreButton];
    }
    return _loadMoreView;
}

- (THNCommentSectionHeaderView *)sectionHeaderView {
    if (!_sectionHeaderView) {
        _sectionHeaderView = [THNCommentSectionHeaderView viewFromXib];
    }
    return _sectionHeaderView;
}

@end
