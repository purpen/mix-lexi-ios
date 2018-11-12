//
//  THNContentTableViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/8/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNCommentViewController.h"
#import "THNMarco.h"
#import "THNAPI.h"
#import <MJExtension/MJExtension.h>
#import "UIView+Helper.h"
#import "THNToolBarView.h"
#import "YYKit.h"
#import "THNCommentTableView.h"
#import "THNCommentModel.h"
#import "UIViewController+THNHud.h"

static NSString *const kUrlShopWindowsComments = @"/shop_windows/comments";
static NSString *const kUrlAddComment = @"/shop_windows/comments";

@interface THNCommentViewController ()<YYTextKeyboardObserver, UITextFieldDelegate, THNToolBarViewDelegate, THNMJRefreshDelegate>

@property (weak, nonatomic) IBOutlet UIView *fieldBackgroundView;
@property (nonatomic, strong) THNCommentTableView *commentTableView;
@property (nonatomic, strong) THNToolBarView *toolbar;
@property (weak, nonatomic) IBOutlet UITextField *textfield;
@property (weak, nonatomic) IBOutlet UIView *commentLikesView;
// 所有一级
@property (nonatomic, strong) NSMutableArray *comments;
// 组合 lessThanSubComments 和 moreThanSubComments
@property (nonatomic, strong) NSMutableArray *subComments;
/// 当前页码
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation THNCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadCommentData];
}

- (void)setupUI {
    // 监听键盘
    [[YYTextKeyboardManager defaultManager] addObserver:self];
    [self.fieldBackgroundView drawCornerWithType:0 radius:self.fieldBackgroundView.viewHeight / 2];
    CGFloat topHeight = kDeviceiPhoneX ? 88 : 64;
    self.commentTableView = [[THNCommentTableView alloc]initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 50 - topHeight) initWithCommentType:CommentTypeAll];
    self.commentTableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.navigationBarView.title = [NSString stringWithFormat:@"%ld条评论", self.commentCount];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
    [self.view addSubview:self.commentTableView];
    self.toolbar.delegate = self;
    [self.view addSubview:self.toolbar];
    [self.commentTableView setRefreshFooterWithClass:nil automaticallyRefresh:YES delegate:self];
    [self.commentTableView resetCurrentPageNumber];
    self.currentPage = 1;
}

// 橱窗评论
- (void)loadCommentData {
    if (self.currentPage == 1) {
        [self showHud];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(self.currentPage);
    params[@"rid"] = self.rid;
    THNRequest *request = [THNAPI getWithUrlString:kUrlShopWindowsComments requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [self hiddenHud];
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        [self.commentTableView endFooterRefreshAndCurrentPageChange:YES];
        [self.comments addObjectsFromArray:[THNCommentModel mj_objectArrayWithKeyValuesArray:result.data[@"comments"]]];
        
        for (THNCommentModel *commentModel in self.comments) {
            commentModel.height = [self getSizeByString:commentModel.content AndFontSize:[UIFont fontWithName:@"PingFangSC-Regular" size:14]];
            NSMutableArray *lessThanSubComments = [NSMutableArray array];
            
            for (NSDictionary *dict in commentModel.sub_comments) {
                
                THNCommentModel *subCommentModel = [THNCommentModel mj_objectWithKeyValues:dict];
                NSString *contentStr = [NSString stringWithFormat:@"%@ : %@",subCommentModel.user_name, subCommentModel.content];
                subCommentModel.height = [self getSizeByString:contentStr AndFontSize:[UIFont fontWithName:@"PingFangSC-Regular" size:12]];
                [lessThanSubComments addObject:subCommentModel];
            }
            
            [self.subComments addObject:lessThanSubComments];
        }
        
        [self.commentTableView setComments:self.comments initWithSubComments:self.subComments initWithRid:self.rid];
        [self.commentTableView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

//获取字符串高度的方法
- (CGFloat)getSizeByString:(NSString*)string AndFontSize:(UIFont *)font
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 80, 999) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
    return size.height;
}

#pragma mark @protocol YYTextKeyboardObserver
- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition {
    CGRect toFrame = [[YYTextKeyboardManager defaultManager] convertRect:transition.toFrame toView:self.view];
    if (transition.animationDuration == 0) {
        self.toolbar.bottom = CGRectGetMinY(toFrame);
    } else {
        self.toolbar.bottom = CGRectGetMinY(toFrame);
        [UIView animateWithDuration:transition.animationDuration delay:0 options:transition.animationOption | UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.toolbar.bottom = CGRectGetMinY(toFrame);
        } completion:NULL];
    }
}

- (void)dealloc {
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}

#pragma mark - THNToolBarViewDelegate
- (void)addComment:(NSString *)text {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = self.rid;
    params[@"content"] = text;
    THNRequest *request = [THNAPI postWithUrlString:kUrlAddComment requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        [self.comments removeAllObjects];
        [self loadCommentData];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

#pragma mark - THNMJRefreshDelegate
- (void)beginLoadingMoreDataWithCurrentPage:(NSNumber *)currentPage {
    self.currentPage = currentPage.integerValue;
    [self loadCommentData];
}

#pragma mark - lazy
- (THNToolBarView *)toolbar {
    if (!_toolbar) {
        _toolbar = [THNToolBarView viewFromXib];
        _toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _toolbar.frame = CGRectMake(0, 1000, self.view.width, 50);
    }
    return _toolbar;
}

- (NSMutableArray *)comments {
    if (!_comments) {
        _comments = [NSMutableArray array];
    }
    return _comments;
}

- (NSMutableArray *)subComments {
    if (!_subComments) {
        _subComments = [NSMutableArray array];
    }
    return _subComments;
}


@end
