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
#import "THNAPI.h"
#import "SVProgressHUD+Helper.h"
static NSString *const kUrlShopWindowChildComments = @"/shop_windows/child_comments";
static NSString *const kUrlShopLiferecordsChildComments = @"/life_records/child_comments";

static NSString *const kCommentSectionHeaderViewidentifier = @"kCommentSectionHeaderViewidentifier";
static NSString *const kCommentSecondCellIdentifier = @"kCommentSecondCellIdentifier";
static NSString *const kCommentSectionSecondCellIdentifier = @"kCommentSectionSecondCellIdentifier";

NSInteger const maxShowSubComment = 2;

@interface THNCommentTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) CommentType commentType;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) THNCommentSectionHeaderView *sectionHeaderView;
@property (nonatomic, strong) NSArray *comments;
// 子评论数组的集合
@property (nonatomic, strong) NSMutableArray *subComments;
// 组合每次分页的可变数组
@property (nonatomic, strong) NSMutableArray *allSubComments;
@property (nonatomic, assign) NSInteger allCommentCount;
@property (nonatomic, strong) THNCommentModel *commentModel;
@property (nonatomic, assign) NSInteger page;
// 剩余评论数量
@property (nonatomic, assign) NSInteger remainCount;
@property (nonatomic, strong) UIButton *loadMoreButton;
@property (nonatomic, strong) NSIndexPath *lastIndexPath;

@end

@implementation THNCommentTableView

- (instancetype)initWithFrame:(CGRect)frame initWithCommentType:(CommentType)commentType {
    self.commentType = commentType;
    self.allCommentCount = [[THNSaveTool objectForKey:kCommentCount] integerValue];
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

- (void)setComments:(NSArray *)comments initWithSubComments:(NSMutableArray *)subComments {
    self.comments = comments;
    self.subComments = subComments;
}

// 分页未实现
- (void)loadMoreSubCommentData:(NSInteger)section {
    NSString *requestUrl = self.isShopWindow ? kUrlShopWindowChildComments : kUrlShopLiferecordsChildComments;
    THNCommentModel *commentModel = self.comments[section];
    self.page = 1;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pid"] = @(commentModel.comment_id);
    params[@"page"] = @(self.page);
    params[@"per_page"] = @(20);
    THNRequest *request = [THNAPI getWithUrlString:requestUrl requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        self.page = [result.data[@"current_page"] integerValue];
        self.remainCount = [result.data[@"remain_count"] integerValue];
        NSArray *array = [THNCommentModel mj_objectArrayWithKeyValuesArray:result.data[@"comments"]];
//        [self.allSubComments addObjectsFromArray:array];
        
        for (THNCommentModel *subCommentModel in array) {
            subCommentModel.height = [self getHeightByString:subCommentModel.content AndFontSize:[UIFont fontWithName:@"PingFangSC-Regular" size:12]];
        }
        
        [self.subComments replaceObjectAtIndex:section withObject:array];
        [UIView performWithoutAnimation:^{
            [self reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        }];
       
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

//获取字符串高度的方法
- (CGFloat)getHeightByString:(NSString*)string AndFontSize:(UIFont *)font
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 112, 999) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
    return size.height;
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
    NSArray *sectionSubComments = self.subComments[indexPath.section];
    THNCommentModel *subCommentModel = [THNCommentModel mj_objectWithKeyValues:sectionSubComments[indexPath.row]];

    if (self.commentType == CommentTypeSection) {
        THNSectionSecondLevelCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommentSectionSecondCellIdentifier forIndexPath:indexPath];
        cell.subCommentCount = self.commentModel.sub_comment_count;
        
        if (indexPath.row == 0) {
            if (sectionSubComments.count == 1) {
                [cell drawCornerWithType:UILayoutCornerRadiusAll radius:4];
            } else {
                [cell drawCornerWithType:UILayoutCornerRadiusTop radius:4];
            }
            
        } else if (indexPath.row == sectionSubComments.count - 1) {
                [cell drawCornerWithType:UILayoutCornerRadiusBottom radius:4];
        }
        
        [cell setSubCommentModel:subCommentModel];
        return cell;
    } else {
        THNSecondLevelCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommentSecondCellIdentifier forIndexPath:indexPath];
        
        cell.isShopWindow = self.isShopWindow;
        
        WEAKSELF;
        cell.secondLevelBlock = ^(THNSecondLevelCommentTableViewCell *cell) {
            NSIndexPath *indexPath = [weakSelf indexPathForCell:cell];
            [weakSelf loadMoreSubCommentData:indexPath.section];
        };
        
        if (indexPath.row == 0) {
            if (sectionSubComments.count == 1) {
                [cell drawCornerWithType:UILayoutCornerRadiusAll radius:4];
            } else {
                [cell drawCornerWithType:UILayoutCornerRadiusTop radius:4];
            }
            cell.isHiddenLoadMoreDataView = YES;
        } else if (indexPath.row == sectionSubComments.count - 1) {
            if (self.commentModel.sub_comment_count > maxShowSubComment) {
                [cell drawCornerWithType:UILayoutCornerRadiusBottom radius:4];
                
                if (self.remainCount != 0 || sectionSubComments.count == maxShowSubComment) {
                    cell.isHiddenLoadMoreDataView = NO;
                } else {
                    cell.isHiddenLoadMoreDataView = YES;
                }
                
            } else {
                cell.isHiddenLoadMoreDataView = YES;
                [cell drawCornerWithType:UILayoutCornerRadiusBottom radius:4];
            }
        } else {
            cell.isHiddenLoadMoreDataView = YES;
        }
        
        cell.commentModel = self.commentModel;
        [cell setSubCommentModel:subCommentModel];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sectionSubComments = self.subComments[indexPath.section];
    THNCommentModel *subCommentModel = [THNCommentModel mj_objectWithKeyValues:sectionSubComments[indexPath.row]];

    if (!subCommentModel.height) {
        if (self.commentDelegate && [self.commentDelegate respondsToSelector:@selector(lookAllSubComment)]) {
            [self.commentDelegate lookAllSubComment];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNCommentModel *subCommentModel = [THNCommentModel mj_objectWithKeyValues:self.subComments[indexPath.section][indexPath.row]];
    NSArray *sectionSubComments = self.subComments[indexPath.section];
    if (subCommentModel.height) {
        CGFloat allSubcommentHeight = 0;
        if (self.commentModel.sub_comment_count > maxShowSubComment && indexPath.row == sectionSubComments.count - 1) {
            
            if (self.remainCount != 0 || sectionSubComments.count == maxShowSubComment) {
               allSubcommentHeight = subCommentModel.height + allSubCommentHeight + loadViewHeight;
            } else {
               allSubcommentHeight = subCommentModel.height + allSubCommentHeight + 10;
            }
            
        } else if (indexPath.row == sectionSubComments.count - 1) {
            
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

    WEAKSELF;
    headerView.replyBlcok = ^(NSInteger pid) {
        
        if (weakSelf.commentDelegate && [weakSelf.commentDelegate respondsToSelector:@selector(replyComment: withSection:)]) {
            [weakSelf.commentDelegate replyComment:pid withSection:section];
        }
    };

    headerView.isShopWindow = self.isShopWindow;
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
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 41)];
        UIView *lineView = [UIView initLineView:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        UIView *secondLineView = [UIView initLineView:CGRectMake(0, 38, SCREEN_WIDTH, 0.5)];
        [_footView addSubview:lineView];
        [_footView addSubview:secondLineView];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0.5, SCREEN_WIDTH, 40)];
        NSString *btnTitle = [NSString stringWithFormat:@"查看全部%ld条评论",self.allCommentCount];
        [button setTitle:btnTitle forState:UIControlStateNormal];
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

- (NSMutableArray *)allSubComments {
    if (!_allSubComments) {
        _allSubComments = [NSMutableArray array];
    }
    return _allSubComments;
}

@end
