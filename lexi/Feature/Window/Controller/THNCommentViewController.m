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
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "THNLoginManager.h"

static NSString *const kUrlShopWindowsComments = @"/shop_windows/comments";
static NSString *const KUrlLifeRecordsComments  = @"/life_records/comments";
NSString *const kUrlAddComment = @"/shop_windows/comments";

@interface THNCommentViewController () <
YYTextKeyboardObserver,
THNToolBarViewDelegate,
THNMJRefreshDelegate,
THNCommentTableViewDelegate
>

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
// 评论的父级ID
@property (nonatomic, assign) NSInteger pid;
// 点击回复的节头位置
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) BOOL isNeedLocalHud;
@property (nonatomic, strong) NSString *requestUrl;
@property (nonatomic, assign) BOOL isSecondComment;
@property (nonatomic, assign) NSInteger totalCommentCount;

@end

@implementation THNCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadCommentData];
}

- (void)setupUI {
    self.fieldBackgroundView.layer.cornerRadius = self.fieldBackgroundView.viewHeight / 2;
    CGFloat topWithBottomHeight = kDeviceiPhoneX ? 88 + 34 : 64;
    self.commentTableView = [[THNCommentTableView alloc]initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 50 - topWithBottomHeight) initWithCommentType:CommentTypeAll];
    self.commentTableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.commentTableView.commentDelegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.commentTableView];
    [self.commentTableView setRefreshFooterWithClass:nil automaticallyRefresh:YES delegate:self];
    [self.commentTableView resetCurrentPageNumber];
    self.currentPage = 1;
    self.commentTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
      self.toolbar.hidden = YES;
}

- (void)tableViewTouchInSide{
    // ------结束编辑，隐藏键盘
    [self.view endEditing:YES];
}

// 橱窗评论
- (void)loadCommentData {

    if (self.currentPage == 1) {
        if (self.isNeedLocalHud) {
            [SVProgressHUD thn_show];
        } else {
            [self showHud];
        }
    }
    self.requestUrl = self.isFromShopWindow ? kUrlShopWindowsComments : KUrlLifeRecordsComments;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(self.currentPage);
    params[@"rid"] = self.rid;
    THNRequest *request = [THNAPI getWithUrlString:self.requestUrl requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
#ifdef DEBUG
        THNLog(@"评论列表：%@", [NSString jsonStringWithObject:result.responseDict]);
#endif
        if (self.isNeedLocalHud) {
            [SVProgressHUD dismiss];
        } else {
            [self hiddenHud];
        }
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        self.totalCommentCount = [result.data[@"total_count"]integerValue];
        self.navigationBarView.title = [NSString stringWithFormat:@"%ld条评论", self.totalCommentCount];
        [self.commentTableView endFooterRefreshAndCurrentPageChange:YES];
        [self.subComments removeAllObjects];
        NSArray *comments = [THNCommentModel mj_objectArrayWithKeyValuesArray:result.data[@"comments"]];
        [self.comments addObjectsFromArray:comments];
        
        if (![result.data[@"next"] boolValue] && self.comments.count != 0) {
            [self.commentTableView noMoreData];
        }
        
        for (THNCommentModel *commentModel in self.comments) {
            commentModel.height = [self getSizeByString:commentModel.content AndFontSize:[UIFont fontWithName:@"PingFangSC-Regular" size:14]];
            NSMutableArray *lessThanSubComments = [NSMutableArray array];
            
            for (NSDictionary *dict in commentModel.sub_comments) {
                
                THNCommentModel *subCommentModel = [THNCommentModel mj_objectWithKeyValues:dict];
                subCommentModel.height = [self getSizeByString:subCommentModel.content AndFontSize:[UIFont fontWithName:@"PingFangSC-Regular" size:12]];
                [lessThanSubComments addObject:subCommentModel];
            }
            
            [self.subComments addObject:lessThanSubComments];
        }

        self.commentTableView.isShopWindow = self.isFromShopWindow;
        [self.commentTableView setComments:self.comments initWithSubComments:self.subComments];


        [self.commentTableView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        if (self.isNeedLocalHud) {
            [SVProgressHUD dismiss];
        } else {
            [self hiddenHud];
        }
    }];
}

- (IBAction)showToolView:(id)sender {
    if (![THNLoginManager isLogin]) {
        [[THNLoginManager sharedManager] openUserLoginController];
        return;
    }

    self.isSecondComment = NO;
    [self layoutToolView];
}

- (void)layoutToolView {
    if (self.toolbar) {
        self.toolbar.hidden = NO;
        [self.toolbar.textView becomeFirstResponder];
    }
    self.toolbar.delegate = self;
    // 监听键盘
    [[YYTextKeyboardManager defaultManager] addObserver:self];
    [self.view addSubview:self.toolbar];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - THNToolBarViewDelegate
// 添加评论
- (void)addComment:(NSString *)text {
    [self layoutToolView];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = self.rid;
    if (self.isSecondComment) {
        params[@"reply_id"] = @(self.pid);
    }
    params[@"content"] = text;

    THNRequest *request = [THNAPI postWithUrlString:self.requestUrl requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }

        if (self.isSecondComment) {
            self.totalCommentCount += 1;
            self.navigationBarView.title = [NSString stringWithFormat:@"%ld条评论", self.totalCommentCount];
            [self.commentTableView loadMoreSubCommentData:self.section];
        } else {
            self.currentPage = 1;
            [self.commentTableView resetCurrentPageNumber];
            [self.comments removeAllObjects];
            [self.subComments removeAllObjects];
            self.isNeedLocalHud = YES;
            [self loadCommentData];
        }
        
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

#pragma mark - THNMJRefreshDelegate
- (void)beginLoadingMoreDataWithCurrentPage:(NSNumber *)currentPage {
    self.currentPage = currentPage.integerValue;
    [self loadCommentData];
}

#pragma mark - THNCommentTableViewDelegate
// 回复评论
- (void)replyComment:(NSInteger)pid withSection:(NSInteger)section {
    if (![THNLoginManager isLogin]) {
        [[THNLoginManager sharedManager] openUserLoginController];
        return;
    }

    self.isSecondComment = YES;
    [self layoutToolView];
    self.pid = pid;
    self.section = section;
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
