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
THNCommentTableViewDelegate
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


@end

@implementation THNShopWindowDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushCommentVC) name:kLookAllCommentData object:nil];
    [self setupUI];
    [self loadData];
}

- (void)loadData {
    [self.dataArray addObject:@(ShopWindowDetailCellTypeMain)];
     [self loadShopWindowDetailData];
}

- (IBAction)like:(id)sender {
    if (self.likeCountButton.selected) {
        [self deleteUserLikes];
    } else {
        [self addUserLikes];
    }
}

- (void)addUserLikes {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = self.shopWindowModel.rid;
    THNRequest *request = [THNAPI postWithUrlString:kUrlShopWindowsUserLikes requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
            [SVProgressHUD showInfoWithStatus:result.statusMessage];
            return;
        }

        self.shopWindowModel.is_like = YES;
        self.likeCountButton.selected = YES;
        self.shopWindowModel.like_count += 1;
        [self.likeCountButton setTitle:[NSString stringWithFormat:@"%ld", self.shopWindowModel.like_count] forState:UIControlStateNormal];
    } failure:^(THNRequest *request, NSError *error) {

    }];
}

- (void)deleteUserLikes {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = self.shopWindowModel.rid;
    THNRequest *request = [THNAPI deleteWithUrlString:kUrlShopWindowsUserLikes requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
            [SVProgressHUD showInfoWithStatus:result.statusMessage];
            return;
        }

        self.shopWindowModel.is_like = NO;
        self.likeCountButton.selected = NO;
        self.shopWindowModel.like_count -= 1;
        [self.likeCountButton setTitle:[NSString stringWithFormat:@"%ld", self.shopWindowModel.like_count] forState:UIControlStateNormal];
    } failure:^(THNRequest *request, NSError *error) {

    }];
}

- (IBAction)showToolView:(id)sender {
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
}


- (IBAction)comment:(id)sender {
    [self pushCommentVC];
}

- (IBAction)share:(id)sender {
    
}

//猜你喜欢
- (void)loadShowWindowGuessLikeData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = self.shopWindowModel.rid;
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
    params[@"rid"] = self.shopWindowModel.rid;
    THNRequest *request = [THNAPI getWithUrlString:kUrlShowWindowSimilar requestDictionary:params delegate:nil];
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
        
        self.similarShowWindowArray = result.data[@"shop_windows"];
        if (self.similarShowWindowArray.count > 0) {
            [self.dataArray addObject:@(ShopWindowDetailCellTypeFeature)];
        }
        
        [self.tableView reloadData];
    } failure:^(THNRequest *request, NSError *error) {

    }];
}

// 评论列表
- (void)loadShopWindowDetailData {
    if (self.isNeedLocalHud) {
        [SVProgressHUD thn_show];
    } else {
        [self showHud];
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = self.shopWindowModel.rid;
    THNRequest *request = [THNAPI getWithUrlString:kUrlShowWindowDetail requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        
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
            commentModel.height = [self getSizeByString:commentModel.content AndFontSize:[UIFont fontWithName:@"PingFangSC-Regular" size:14]];
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
                    subCommentModel.height = [self getSizeByString:contentStr AndFontSize:[UIFont fontWithName:@"PingFangSC-Regular" size:12]];
                    [lessThanSubComments addObject:subCommentModel];
                    [self.lessThanSubComments addObject:subCommentModel];
                    self.subCommentHeight += subCommentModel.height;
                }
                
                [self.subComments addObject:lessThanSubComments];
            }
        }

        if (self.isNeedLocalHud) {
            [self.tableView reloadData];
            return;
        }

        if (self.comments.count > 0) {
            [self.dataArray addObject:@(ShopWindowDetailCellTypeComment)];
        }
        
        [self loadShowWindowGuessLikeData];

    } failure:^(THNRequest *request, NSError *error) {
        [self hiddenHud];
    }];
}

- (void)layoutCommentView {
    [self.likeCountButton setTitle:[NSString stringWithFormat:@"%ld", self.shopWindowModel.like_count] forState:UIControlStateNormal];
    self.likeCountButton.selected = self.shopWindowModel.is_like;
    [self.commentCountButton setTitle:[NSString stringWithFormat:@"%ld", self.shopWindowModel.comment_count] forState:UIControlStateNormal];
}

//获取字符串长度的方法
- (CGFloat)getHeightByString:(NSString*)string AndFontSize:(CGFloat)font
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 80, 999) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    return size.height;
}

- (void)setupUI {
    self.commentViewheightConstraint.constant = shopWindowCellHiddenHeight;
    [self.fieldBackgroundView drawCornerWithType:0 radius:self.fieldBackgroundView.viewHeight / 2];
    self.tableViewTopConstraint.constant = NAVIGATION_BAR_HEIGHT;
    self.navigationBarView.title = @"橱窗";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTouchInSide)];
    tableViewGesture.numberOfTapsRequired = 1;//几个手指点击
    tableViewGesture.cancelsTouchesInView = NO;//是否取消点击处的其他action
    [self.tableView addGestureRecognizer:tableViewGesture];
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
    WEAKSELF;
    if ([self.dataArray[indexPath.row] integerValue]== ShopWindowDetailCellTypeMain) {
        self.cellType = ShopWindowDetailCellTypeMain;
        THNShopWindowTableViewCell *cell = [THNShopWindowTableViewCell viewFromXib];
        
        
        if (self.shopWindowModel.products.count == 3) {
             self.imageType = ShopWindowImageTypeThree;
        } else if (self.shopWindowModel.products.count == 5) {
            self.imageType = ShopWindowImageTypeFive;
        } else {
            self.imageType = ShopWindowImageTypeSeven;
        }
        
        cell.shopWindowCellBlock = ^(NSString *rid) {
            THNGoodsInfoViewController *goodInfoVC = [[THNGoodsInfoViewController alloc]initWithGoodsId:rid];
            [weakSelf.navigationController pushViewController:goodInfoVC animated:YES];
        };
        
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
    switch (self.cellType) {
        case ShopWindowDetailCellTypeMain:

            switch (self.imageType) {
                case ShopWindowImageTypeThree:
                    return  180 + threeImageHeight + [self getSizeByString:self.shopWindowModel.des AndFontSize:[UIFont fontWithName:@"PingFangSC-Regular" size:14]];
                case ShopWindowImageTypeFive:
                    return  180 + threeImageHeight + fiveToGrowImageHeight + [self getSizeByString:self.shopWindowModel.des AndFontSize:[UIFont fontWithName:@"PingFangSC-Regular" size:14]];
                default:
                    return  180 + threeImageHeight + sevenToGrowImageHeight + [self getSizeByString:self.shopWindowModel.des AndFontSize:[UIFont fontWithName:@"PingFangSC-Regular" size:14]];
            }
        case ShopWindowDetailCellTypeComment: {
           
            CGFloat commentHeight = 45 * self.comments.count + self.commentHeight;
            CGFloat subCommentHeight = 32 * self.moreThanSubComments.count + 18 * self.lessThanSubComments.count + self.subCommentHeight;
             // 间距 + 头部视图和尾部视图 + 一级评论 + 二级评论
            CGFloat headerWithFooterViewHeight = self.allCommentCount > 3 ? 89.5 : 49;
            return  15 * self.comments.count + headerWithFooterViewHeight + commentHeight + subCommentHeight;
        }
        case ShopWindowDetailCellTypeExplore:
            return cellOtherHeight + 87;
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
- (CGFloat)getSizeByString:(NSString*)string AndFontSize:(UIFont *)font
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 80, 999) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
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
    params[@"rid"] = self.shopWindowModel.rid;
    if (self.pid) {
        params[@"pid"] = @(self.pid);
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
- (void)replyComment:(NSInteger)pid withSection:(NSInteger)section {
    self.pid = pid;
    self.section = section;
    [self layoutToolView];
}

- (void)lookAllSubComment {
    [self pushCommentVC];
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
