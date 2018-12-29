//
//  THNShopWindowDetailViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/8/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNShopWindowDetailViewController.h"
#import "THNFeatureTableViewCell.h"
#import "THNExploreTableViewCell.h"
#import "THNShopWindowTableViewCell.h"
#import "THNCommentTableViewCell.h"
#import "UIView+Helper.h"
#import "THNShopWindowModel.h"
#import "THNAPI.h"
#import "UITableView+Helper.h"
#import "THNCommentViewController.h"
#import "UIViewController+THNHud.h"
#import "THNGoodsInfoViewController.h"
#import "THNCommentModel.h"
#import "THNSaveTool.h"
#import "THNCommentViewController.h"
#import "THNToolBarView.h"
#import "THNCommentTableView.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "THNShareViewController.h"
#import "THNLoginManager.h"
#import "THNUserCenterViewController.h"

static NSString *const kUrlShowWindowGuessLike = @"/shop_windows/guess_like";
static NSString *const kUrlShowWindowSimilar = @"/shop_windows/similar";
static NSString *const kUrlShowWindowDetail = @"/shop_windows/detail";
static NSString *const kFeatureCellIdentifier = @"kFeatureCellIdentifier";
// shopWindowCell页面的分享喜欢等被隐藏的高度
static CGFloat const shopWindowCellHiddenHeight = 50;

@interface THNShopWindowDetailViewController () <
UITableViewDelegate,
UITableViewDataSource,
THNExploreTableViewCellDelegate,
THNFeatureTableViewCellDelegate,
YYTextKeyboardObserver,
THNToolBarViewDelegate,
THNCommentTableViewDelegate,
THNShopWindowTableViewCellDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) THNCommentTableViewCell *cell;
@property (nonatomic, assign) ShopWindowDetailCellType cellType;
@property (nonatomic, assign) NSInteger allCellCount;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopConstraint;
@property (nonatomic, assign) ShopWindowImageType imageType;
@property (nonatomic, strong) NSArray *guessLikeArray;
@property (nonatomic, strong) NSArray *similarShowWindowArray;
// 所有一级
@property (nonatomic, strong) NSMutableArray *comments;
// 组合 lessThanSubComments 和 moreThanSubComments
@property (nonatomic, strong) NSMutableArray *subComments;
// 小于最大显示行数的所有子评论数组
@property (nonatomic, strong) NSMutableArray *lessThanSubComments;
// 大于最大显示行数的所有子评论数组
@property (nonatomic, strong) NSMutableArray *moreThanSubComments;
@property (nonatomic, assign) CGFloat commentHeight;
@property (nonatomic, assign) CGFloat subCommentHeight;
@property (weak, nonatomic) IBOutlet UIView *fieldBackgroundView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentViewheightConstraint;
@property (nonatomic, assign) NSInteger allCommentCount;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) THNToolBarView *toolbar;
// 评论的父级ID
@property (nonatomic, assign) NSInteger pid;
// 点击回复的节头位置
@property (nonatomic, assign) NSInteger section;
@property (weak, nonatomic) IBOutlet UIButton *likeCountButton;
@property (weak, nonatomic) IBOutlet UIButton *commentCountButton;
@property (nonatomic, assign) BOOL isNeedLocalHud;
@property (nonatomic, assign) NSInteger likeWindowCount;
@property (nonatomic, assign) BOOL isLike;
@property (nonatomic, strong) NSString *replyUserName;

@end

@implementation THNShopWindowDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushCommentVC) name:kLookAllCommentData object:nil];
    [self setupUI];
    [self loadData];
}

// 解决键盘toolView偏移和重复点击闪烁的问题
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

- (void)loadData {
    [self.dataArray addObject:@(ShopWindowDetailCellTypeMain)];
     [self loadShopWindowDetailData];
}

- (IBAction)like:(id)sender {
    if (![THNLoginManager isLogin]) {
        [[THNLoginManager sharedManager] openUserLoginController];
        return;
    }

    if (self.likeCountButton.selected) {
        [self deleteUserLikes];
    } else {
        [self addUserLikes];
    }
}

- (void)layoutLikeButtonStatus:(BOOL)isLike {
    [[NSNotificationCenter defaultCenter] postNotificationName:kChangeStatusWindowSuccess object:nil userInfo:@{@"isLike":@(isLike)}];
    
    self.likeCountButton.selected = isLike;
    
    if (isLike) {
        self.likeWindowCount++;
    } else {
        self.likeWindowCount--;
    }
    
    NSString *commentLikeCountBtnTitle = self.likeWindowCount == 0 ? @"喜欢" : [NSString stringWithFormat:@"%ld",self.likeWindowCount];
    [self.likeCountButton setTitle:commentLikeCountBtnTitle forState:UIControlStateNormal];
}

- (void)addUserLikes {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = self.rid.length > 0 ? self.rid : self.shopWindowModel.rid;
    THNRequest *request = [THNAPI postWithUrlString:kUrlShopWindowsUserLikes requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
            [SVProgressHUD showInfoWithStatus:result.statusMessage];
            return;
        }
        
        [self layoutLikeButtonStatus:YES];
    } failure:^(THNRequest *request, NSError *error) {

    }];
}

- (void)deleteUserLikes {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = self.rid.length > 0 ? self.rid : self.shopWindowModel.rid;
    THNRequest *request = [THNAPI deleteWithUrlString:kUrlShopWindowsUserLikes requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
            [SVProgressHUD showInfoWithStatus:result.statusMessage];
            return;
        }

        [self layoutLikeButtonStatus:NO];
    } failure:^(THNRequest *request, NSError *error) {

    }];
}

- (IBAction)showToolView:(id)sender {
    if (![THNLoginManager isLogin]) {
        [[THNLoginManager sharedManager] openUserLoginController];
        return;
    }

    [self layoutToolView];
}

- (void)layoutToolView {
    if (self.toolbar) {
        self.toolbar.hidden = NO;
        [self.toolbar.textView becomeFirstResponder];
    }
    // 监听键盘
    [[YYTextKeyboardManager defaultManager] addObserver:self];
    self.toolbar.delegate = self;
    [self.view addSubview:self.toolbar];
    
    if (self.replyUserName.length == 0) {
        return;
    }
    
    self.toolbar.textView.placeholderText = [NSString stringWithFormat:@"回复 %@:",self.replyUserName];
    self.toolbar.textView.placeholderFont = [UIFont systemFontOfSize:14];
}


- (IBAction)comment:(id)sender {
    
    [self pushCommentVC];
}

- (IBAction)share:(id)sender {
    if (!self.shopWindowModel.rid.length) return;
    
    THNShareViewController *shareVC = [[THNShareViewController alloc] initWithType:(THNSharePosterTypeWindow)
                                                                         requestId:self.shopWindowModel.rid];
    [shareVC shareObjectWithTitle:self.shopWindowModel.title
                            descr:self.shopWindowModel.des
                        thumImage:self.shopWindowModel.product_covers[0]
                           webUrl:[kShareShowWindowPrefix stringByAppendingString:self.shopWindowModel.rid]];
    shareVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:shareVC animated:NO completion:nil];
}

//猜你喜欢
- (void)loadShowWindowGuessLikeData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = self.rid.length > 0 ? self.rid : self.shopWindowModel.rid;
    THNRequest *request = [THNAPI getWithUrlString:kUrlShowWindowGuessLike requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        self.guessLikeArray = result.data[@"products"];
        if (self.guessLikeArray.count > 0) {
            [self.dataArray addObject:@(ShopWindowDetailCellTypeExplore)];
        }
        [self loadShowWindowSimilarData];
        
    } failure:^(THNRequest *request, NSError *error) {
        [self hiddenHud];
    }];
}

// 相似橱窗
- (void)loadShowWindowSimilarData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = self.rid.length > 0 ? self.rid : self.shopWindowModel.rid;
    THNRequest *request = [THNAPI getWithUrlString:kUrlShowWindowSimilar requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {

        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        self.similarShowWindowArray = result.data[@"shop_windows"];
        if (self.similarShowWindowArray.count > 0) {
            [self.dataArray addObject:@(ShopWindowDetailCellTypeFeature)];
        }
        
        [self.tableView reloadData];
    } failure:^(THNRequest *request, NSError *error) {

    }];
}

// 评论列表和橱窗详情
- (void)loadShopWindowDetailData {
    if (self.isNeedLocalHud) {
        [SVProgressHUD thn_show];
    } else {
        [self showHud];
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = self.rid.length > 0 ? self.rid : self.shopWindowModel.rid;
    THNRequest *request = [THNAPI getWithUrlString:kUrlShowWindowDetail requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (self.isNeedLocalHud) {
            [SVProgressHUD dismiss];
        } else {
            [self hiddenHud];
        }
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }

        self.shopWindowModel = [THNShopWindowModel mj_objectWithKeyValues:result.data];
        [self layoutCommentView];
        
        self.allCommentCount = [result.data[@"comment_count"] integerValue];
        [THNSaveTool setObject:@(self.allCommentCount) forKey:kCommentCount];
        [self.comments addObjectsFromArray:[THNCommentModel mj_objectArrayWithKeyValuesArray:result.data[@"comments"]]];
        
        for (THNCommentModel *commentModel in self.comments) {
            commentModel.height = [self getSizeByString:commentModel.content withFontSize:[UIFont fontWithName:@"PingFangSC-Regular" size:14] withMaxWidth:SCREEN_WIDTH - 80];
            self.commentHeight += commentModel.height;
            // 记录单个评论下的子评论
            NSMutableArray *moreThanSubComments = [NSMutableArray array];
            NSMutableArray *lessThanSubComments = [NSMutableArray array];
            if (commentModel.sub_comment_count > 2) {
                THNCommentModel *subCommentModel = [THNCommentModel mj_objectWithKeyValues:commentModel.sub_comments[0]];
                [moreThanSubComments addObject:subCommentModel];
                [self.moreThanSubComments addObject:subCommentModel];
                [self.subComments addObject:moreThanSubComments];
                self.subCommentHeight += subCommentModel.height;
            } else {
                
                for (NSDictionary *dict in commentModel.sub_comments) {
                  
                    THNCommentModel *subCommentModel = [THNCommentModel mj_objectWithKeyValues:dict];
                    NSString *contentStr = [NSString stringWithFormat:@"%@ : %@",subCommentModel.user_name, subCommentModel.content];
                    subCommentModel.height = [self getSizeByString:contentStr withFontSize:[UIFont fontWithName:@"PingFangSC-Regular" size:12] withMaxWidth:SCREEN_WIDTH - 85 - 35];
                    [lessThanSubComments addObject:subCommentModel];
                    [self.lessThanSubComments addObject:subCommentModel];
                    self.subCommentHeight += subCommentModel.height;
                }
                
                [self.subComments addObject:lessThanSubComments];
            }
        }
        
        if (self.comments.count > 0 && ![self.dataArray containsObject:@(ShopWindowDetailCellTypeComment)]) {
            // 评论插入第一个
            [self.dataArray insertObject:@(ShopWindowDetailCellTypeComment) atIndex:1];
        }

        if (self.isNeedLocalHud) {
            [self.tableView reloadData];
            return;
        }
        
        [self.tableView reloadData];
        [self loadShowWindowGuessLikeData];

    } failure:^(THNRequest *request, NSError *error) {
        [self hiddenHud];
    }];
}

- (void)layoutCommentView {
    NSString *commentCountBtnTitle = self.shopWindowModel.comment_count == 0 ? @"评论" : [NSString stringWithFormat:@"%ld",self.shopWindowModel.comment_count];
    NSString *commentLikeCountBtnTitle = self.shopWindowModel.like_count == 0 ? @"喜欢" : [NSString stringWithFormat:@"%ld",self.shopWindowModel.like_count];
    self.likeWindowCount = self.shopWindowModel.like_count;
    [self.commentCountButton setTitle:commentCountBtnTitle forState:UIControlStateNormal];
    [self.likeCountButton setTitle:commentLikeCountBtnTitle forState:UIControlStateNormal];
    self.likeCountButton.selected = self.shopWindowModel.is_like;
    self.isLike = self.shopWindowModel.is_like;
}

- (void)setupUI {
    self.commentViewheightConstraint.constant = shopWindowCellHiddenHeight;
    [self.fieldBackgroundView drawCornerWithType:0 radius:self.fieldBackgroundView.viewHeight / 2];
    self.tableViewTopConstraint.constant = NAVIGATION_BAR_HEIGHT;
    self.navigationBarView.title = @"橱窗";
    //TableView刷新后位置偏移的问题
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    self.toolbar.hidden = YES;
}

- (void)tableViewTouchInSide{
    // ------结束编辑，隐藏键盘
    [self.view endEditing:YES];
}

- (void)pushCommentVC {
    THNCommentViewController *commentVC = [[THNCommentViewController alloc]init];
    commentVC.rid = self.shopWindowModel.rid;
    commentVC.commentCount = self.allCommentCount;
    commentVC.isFromShopWindow = YES;
    [self.navigationController pushViewController:commentVC animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataArray[indexPath.row] integerValue]== ShopWindowDetailCellTypeMain) {
        self.cellType = ShopWindowDetailCellTypeMain;
        THNShopWindowTableViewCell *cell = [THNShopWindowTableViewCell viewFromXib];
        cell.delegate = self;
        
        
        if (self.shopWindowModel.products.count == 3) {
             self.imageType = ShopWindowImageTypeThree;
        } else if (self.shopWindowModel.products.count == 5) {
            self.imageType = ShopWindowImageTypeFive;
        } else {
            self.imageType = ShopWindowImageTypeSeven;
        }
        
        cell.imageType = self.imageType;
        cell.flag = @"shopWindowDetail";
        [cell setShopWindowModel:self.shopWindowModel];
        return cell;
        
    } else if ([self.dataArray[indexPath.row] integerValue] == ShopWindowDetailCellTypeComment) {
        self.cellType = ShopWindowDetailCellTypeComment;
        THNCommentTableViewCell *cell = [THNCommentTableViewCell viewFromXib];
        cell.isShopWindow = YES;
        cell.commentTableView.commentDelegate = self;
        [cell setComments:self.comments initWithSubComments:self.subComments];
        return cell;
        
    } else if ([self.dataArray[indexPath.row] integerValue] == ShopWindowDetailCellTypeExplore) {
        self.cellType = ShopWindowDetailCellTypeExplore;
        THNExploreTableViewCell *cell = [THNExploreTableViewCell viewFromXib];
        cell.isHiddenLoadMoreTitle = YES;
        if (self.comments.count > 0) {
            cell.isRewriteCellHeight = YES;
        }
        
        [cell setCellTypeStyle:ExploreRecommend initWithDataArray:self.guessLikeArray initWithTitle:@"猜你喜欢"];
        cell.delagate = self;
        return cell;
        
    } else {
        self.cellType = ShopWindowDetailCellTypeFeature;
        THNFeatureTableViewCell *cell = [THNFeatureTableViewCell viewFromXib];
        if (self.guessLikeArray.count > 0) {
            cell.isRewriteCellHeight = YES;
        }
        cell.delagate = self;
        [cell setCellTypeStyle:FeaturedLifeAesthetics initWithDataArray:self.similarShowWindowArray initWithTitle:@"相关橱窗"];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat fixedHeight = self.shopWindowModel.keywords.count == 0 ? 113 : 135;
    CGFloat titleHeight = [self getSizeByString:self.shopWindowModel.title withFontSize:[UIFont fontWithName:@"PingFangSC-Medium" size:15] withMaxWidth:SCREEN_WIDTH - 35];
    CGFloat contentHeight = [self getSizeByString:[self.shopWindowModel.des  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] withFontSize:[UIFont fontWithName:@"PingFangSC-Regular" size:14] withMaxWidth:SCREEN_WIDTH - 35];
    CGFloat otherHeight = fixedHeight + titleHeight + contentHeight;
    
    switch (self.cellType) {
        case ShopWindowDetailCellTypeMain:
            
            switch (self.imageType) {
                case ShopWindowImageTypeThree:
                    return (SCREEN_WIDTH - 2) * 2/3 + otherHeight;
                case ShopWindowImageTypeFive:
                    return otherHeight + (SCREEN_WIDTH - 2) * 230/(230 + 143) + (SCREEN_WIDTH - 2) * 158/(215 + 158) + 2;
                default:
                    return otherHeight + (SCREEN_WIDTH - 2) * 215/(215 + 158) + (SCREEN_WIDTH - 4) * 1/3 + 2;
            }
        case ShopWindowDetailCellTypeComment: {
           
            CGFloat commentHeight = 45 * self.comments.count + self.commentHeight;
            CGFloat subCommentHeight = 32 * self.moreThanSubComments.count + 18 * self.lessThanSubComments.count + self.subCommentHeight;
             // 间距 + 头部视图和尾部视图 + 一级评论 + 二级评论
            CGFloat headerWithFooterViewHeight = self.allCommentCount > 3 ? 89.5 : 49;
            return  15 * self.comments.count + headerWithFooterViewHeight + commentHeight + subCommentHeight;
        }
        case ShopWindowDetailCellTypeExplore:
            return self.comments.count == 0 ? cellOtherHeight + 77 : cellOtherHeight + 77 + 15;
        default:
            return kCellLifeAestheticsHeight + 105;
    }
}

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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}

//获取字符串高度的方法
- (CGFloat)getSizeByString:(NSString *)string withFontSize:(UIFont *)font withMaxWidth:(CGFloat)maxWidth
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(maxWidth, 999) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
    return size.height;
}

#pragma mark - custom Delegate
// 商品详情
- (void)pushGoodInfo:(NSString *)rid {
    THNGoodsInfoViewController *goodInfo = [[THNGoodsInfoViewController alloc]initWithGoodsId:rid];
    [self.navigationController pushViewController:goodInfo animated:YES];
}

// 橱窗主页
- (void)pushShopWindow:(THNShopWindowModel *)shopWindowModel {
    THNShopWindowDetailViewController *shopWindowDetail = [[THNShopWindowDetailViewController alloc]init];
    shopWindowDetail.shopWindowModel = shopWindowModel;
    [self.navigationController pushViewController:shopWindowDetail animated:YES];
}

#pragma mark - THNToolBarViewDelegate
- (void)addComment:(NSString *)text {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = self.rid.length > 0 ? self.rid : self.shopWindowModel.rid;
    if (self.pid) {
        params[@"reply_id"] = @(self.pid);
    }
    params[@"content"] = text;
    THNRequest *request = [THNAPI postWithUrlString:kUrlAddComment requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
            [SVProgressHUD showInfoWithStatus:result.statusMessage];
            return;
        }

        self.subCommentHeight = 0;
        self.commentHeight = 0;
        [self.comments removeAllObjects];
        [self.subComments removeAllObjects];
        [self.lessThanSubComments removeAllObjects];
        [self.moreThanSubComments removeAllObjects];
        self.isNeedLocalHud = YES;
        [self loadShopWindowDetailData];

    } failure:^(THNRequest *request, NSError *error) {

    }];
}

#pragma mark - THNCommentTableViewDelegate
- (void)replyComment:(NSInteger)pid withSection:(NSInteger)section withReplyUserName:(NSString *)replyUserName {
    self.pid = pid;
    self.section = section;
    self.replyUserName = replyUserName;
    [self layoutToolView];
}

- (void)lookAllSubComment {
    [self pushCommentVC];
}

- (void)lookUserCenter:(NSString *)uid {
    THNUserCenterViewController *userCentenVC = [[THNUserCenterViewController alloc]initWithUserId:uid];
    [self.navigationController pushViewController:userCentenVC animated:YES];
}

#pragma mark - THNShopWindowTableViewCellDelegate
- (void)clickImageViewWithRid:(NSString *)productRid {
    THNGoodsInfoViewController *goodInfoVC = [[THNGoodsInfoViewController alloc]initWithGoodsId:productRid];
    [self.navigationController pushViewController:goodInfoVC animated:YES];
}

- (void)clickAvatarImageView:(NSString *)userRid {
    THNUserCenterViewController *userCentenVC = [[THNUserCenterViewController alloc]initWithUserId:userRid];
    [self.navigationController pushViewController:userCentenVC animated:YES];
}

#pragma mark - lazy
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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

- (NSMutableArray *)lessThanSubComments {
    if (!_lessThanSubComments) {
        _lessThanSubComments = [NSMutableArray array];
    }
    return _lessThanSubComments;
}

- (NSMutableArray *)moreThanSubComments {
    if (!_moreThanSubComments) {
        _moreThanSubComments = [NSMutableArray array];
    }
    return _moreThanSubComments;
}

- (THNToolBarView *)toolbar {
    if (!_toolbar) {
        _toolbar = [THNToolBarView viewFromXib];
        _toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _toolbar.frame = CGRectMake(0, 1000, self.view.width, 50);
    }
    return _toolbar;
}


@end
