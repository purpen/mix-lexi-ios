//
//  THNArticleViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/10/12.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNArticleViewController.h"
#import "THNDealContentTableViewCell.h"
#import "UITableViewCell+DealContent.h"
#import "YYLabel+Helper.h"
#import "UIImage+Helper.h"
#import "UIView+Helper.h"
#import "THNGrassListModel.h"
#import "THNArticleHeaderView.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "UIViewController+THNHud.h"
#import "THNArticleStoreTableViewCell.h"
#import "THNFeaturedBrandModel.h"
#import "THNArticleStoryTableViewCell.h"
#import "THNArticleProductTableViewCell.h"
#import "THNGoodsInfoViewController.h"
#import <SDWebImage/SDWebImageManager.h>
#import "THNBrandHallViewController.h"
#import "THNCommentTableViewCell.h"
#import "THNCommentModel.h"
#import "THNSaveTool.h"
#import "THNCommentView.h"
#import "THNToolBarView.h"
#import "YYKit.h"
#import "THNCommentTableView.h"
#import "THNCommentViewController.h"

static NSString *const kUrlLifeRecordsDetail = @"/life_records/detail";
static NSString *const kUrlLifeRecordsRecommendProducts = @"/life_records/recommend_products";
static NSString *const kUrlLifeRecordsRecommendStory = @"/life_records/similar";
static NSString *const kUrlLifeRecordsComments = @"/life_records/comments";

static NSString *const kArticleContentCellIdentifier = @"kArticleContentCellIdentifier";
static NSString *const kArticleStoreCellIdentifier  = @"kArticleStoreCellIdentifier";
static NSString *const kArticleProductCellIdentifier = @"kArticleProductCellIdentifier";
static NSString *const kArticleStoryCellIdentifier = @"kArticleStoryCellIdentifier";
static NSString *const KArticleCellTypeArticle = @"article";
static NSString *const kArticleCellTypeStore = @"store";
static NSString *const kArticleCellTypeProduct = @"product";
static NSString *const kArticleCellTypeStory = @"story";
static NSString *const KArticleCellTypeComment = @"comment";
static CGFloat const commentViewHeight = 50;
static NSInteger maxShowComment = 3;

typedef NS_ENUM(NSUInteger, ArticleCellType) {
    ArticleCellTypeArticle,
    ArticleCellTypeComment,
    ArticleCellTypeStore,
    ArticleCellTypeProduct,
    ArticleCellTypeStory
};

@interface THNArticleViewController () <
UITableViewDelegate,
UITableViewDataSource,
THNCommentViewDelegate,
YYTextKeyboardObserver,
THNToolBarViewDelegate,
THNCommentTableViewDelegate
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) THNGrassListModel *grassListModel;
@property (nonatomic, strong) THNFeaturedBrandModel *featuredBrandModel;
@property (nonatomic, strong) NSMutableArray *contentModels;
@property (nonatomic, strong) NSArray *lifeRecords;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, strong) THNArticleHeaderView *articleHeaderView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) ArticleCellType articleCellType;
@property (nonatomic, assign) CGFloat lifeRecordsDetailCellHeight;
@property (nonatomic, assign) CGFloat storyCellHeight;
@property (nonatomic, assign) NSInteger allCommentCount;
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
@property (nonatomic, strong) THNCommentView *commentView;
@property (nonatomic, strong) THNToolBarView *toolbar;
@property (nonatomic, assign) BOOL isNeedLocalHud;
// 评论的父级ID
@property (nonatomic, assign) NSInteger pid;
// 点击回复的节头位置
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) BOOL isSecondComment;

@end

@implementation THNArticleViewController {
    CGFloat tableViewY;
    CGFloat articleHeaderViewHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushCommentVC) name:kLookAllCommentData object:nil];
    tableViewY = kDeviceiPhoneX ? -44 : -22;
    articleHeaderViewHeight = 335 + 64 + 22;
    [self setupUI];
    [self loadLifeRecordsDetailData];
}

- (void)setupUI {
    self.navigationBarView.transparent = YES;
    [self.navigationBarView setNavigationCloseButton];
    [self.navigationBarView setNavigationCloseButtonHidden:YES];
    self.commentView.delegate = self;
    [self.view addSubview:self.commentView];
    [self.view addSubview:self.tableView];
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
    commentVC.rid = [NSString stringWithFormat:@"%ld",self.rid];
    commentVC.commentCount = self.allCommentCount;
    [self.navigationController pushViewController:commentVC animated:YES];
}

// 文章详情
- (void)loadLifeRecordsDetailData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = @(self.rid);
    self.loadViewY = NAVIGATION_BAR_HEIGHT;
    [self showHud];
    THNRequest *request = [THNAPI getWithUrlString:kUrlLifeRecordsDetail requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }

        self.grassListModel = [THNGrassListModel mj_objectWithKeyValues:result.data];
        self.featuredBrandModel = [THNFeaturedBrandModel mj_objectWithKeyValues:self.grassListModel.recommend_store];
        for (NSDictionary *dict in self.grassListModel.deal_content) {
            THNDealContentModel *contenModel = [[THNDealContentModel alloc] initWithDictionary:dict];
            [self.contentModels addObject:contenModel];
        }
        [self.dataArray addObject:KArticleCellTypeArticle];

        if (self.grassListModel.recommend_store.count > 0) {
            [self.dataArray addObject:kArticleCellTypeStore];
        }
        
        [self.commentView setGrassListModel:self.grassListModel];
        [self loadLifeRecordsCommentData];
        
    } failure:^(THNRequest *request, NSError *error) {

    }];
}

- (void)loadLifeRecordsCommentData {
    if (self.isNeedLocalHud) {
        [SVProgressHUD thn_show];
    } else {
        [self showHud];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = @(self.rid);
    THNRequest *request = [THNAPI getWithUrlString:kUrlLifeRecordsComments requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [SVProgressHUD dismiss];
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        self.allCommentCount = [result.data[@"total_count"] integerValue];
        [THNSaveTool setObject:@(self.allCommentCount) forKey:kCommentCount];
        [self.comments addObjectsFromArray:[THNCommentModel mj_objectArrayWithKeyValuesArray:result.data[@"comments"]]];
        
        if (self.comments.count > maxShowComment) {
             [self.comments removeObjectsInRange:NSMakeRange(maxShowComment, self.comments.count - maxShowComment)];
        }
        
        for (THNCommentModel *commentModel in self.comments) {
            commentModel.height = [self getHeightByString:commentModel.content AndFontSize:[UIFont fontWithName:@"PingFangSC-Regular" size:14]];
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
                    subCommentModel.height = [self getHeightByString:contentStr AndFontSize:[UIFont fontWithName:@"PingFangSC-Regular" size:12]];
                    [lessThanSubComments addObject:subCommentModel];
                    [self.lessThanSubComments addObject:subCommentModel];
                    self.subCommentHeight += subCommentModel.height;
                }

                [self.subComments addObject:lessThanSubComments];
            }
        }
        
        if (self.isNeedLocalHud) {
            [UIView performWithoutAnimation:^{
                 [self.tableView reloadData];
            }];
            return;
        }

        if (self.comments.count > 0) {
            [self.dataArray addObject:KArticleCellTypeComment];
        }
        [self loadRecommendProductData];
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

// 推荐商品
- (void)loadRecommendProductData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = @(self.rid);
    THNRequest *request = [THNAPI getWithUrlString:kUrlLifeRecordsRecommendProducts requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.products = result.data[@"products"];
        [self.dataArray addObject:kArticleCellTypeProduct];
        [self loadRecommendStoryData];
    } failure:^(THNRequest *request, NSError *error) {
        [self hiddenHud];
    }];
}

// 推荐故事
- (void)loadRecommendStoryData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = @(self.rid);
    THNRequest *request = [THNAPI getWithUrlString:kUrlLifeRecordsRecommendStory requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [self hiddenHud];
        self.lifeRecords = result.data[@"life_records"];
        [self.dataArray addObject:kArticleCellTypeStory];
        [self.tableView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        [self hiddenHud];
    }];
}

/**
 获取故事cell的高度
 */
- (CGFloat)getCellHeight:(NSArray *)array {
    __block CGFloat maxtitleHeight = 0;
    __block CGFloat totalTitleHeight = 0;

    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        THNGrassListModel *grassListModel = [THNGrassListModel mj_objectWithKeyValues:obj];
        //  设置最大size
        CGFloat titleMaxWidth = (SCREEN_WIDTH - 40 - 9) / 2 - 7.5;
        CGSize titleSize = CGSizeMake(titleMaxWidth, 35);
        NSDictionary *titleFont = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:12]};
        CGFloat titleHeight = [grassListModel.title boundingRectWithSize:titleSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:titleFont context:nil].size.height + 15;

        if (idx % 2 == 0) {
            maxtitleHeight = 0;
            if (idx == array.count - 1) {
                totalTitleHeight  += titleHeight;
            }
        }

        if (titleHeight > maxtitleHeight) {
            maxtitleHeight = titleHeight;
        }

        if (idx % 2 == 1) {
            totalTitleHeight  += maxtitleHeight;
        }
    }];

    NSInteger showRow = array.count / 2 + array.count % 2;

    return 175 * showRow + 85 + totalTitleHeight;
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

//获取字符串高度的方法
- (CGFloat)getHeightByString:(NSString*)string AndFontSize:(UIFont *)font
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 80, 999) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
    return size.height;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *articleStr = self.dataArray[indexPath.row];
     WEAKSELF;
    if ([articleStr isEqualToString:KArticleCellTypeArticle]) {
        self.articleCellType = ArticleCellTypeArticle;
        THNDealContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kArticleContentCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell thn_setDealContentData:self.contentModels];
        return cell;

    } else if ([articleStr isEqualToString:KArticleCellTypeComment]) {
        self.articleCellType = ArticleCellTypeComment;
        THNCommentTableViewCell *cell = [THNCommentTableViewCell viewFromXib];
        cell.commentTableView.commentDelegate = self;
        [cell setComments:self.comments initWithSubComments:self.subComments];
        return cell;
    } else if ([articleStr isEqualToString:kArticleCellTypeStore]) {
        self.articleCellType = ArticleCellTypeStore;
        THNArticleStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kArticleStoreCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell setFeaturedBrandModel:self.featuredBrandModel];
        return cell;

    } else if ([articleStr isEqualToString:kArticleCellTypeProduct]){
        THNArticleProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kArticleProductCellIdentifier forIndexPath:indexPath];;
        self.articleCellType = ArticleCellTypeProduct;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.products = self.products;
        cell.articleProductBlcok = ^(NSString *rid) {
            THNGoodsInfoViewController *goodInfo = [[THNGoodsInfoViewController alloc]initWithGoodsId:rid];
            [weakSelf.navigationController pushViewController:goodInfo animated:YES];
        };
        
        return cell;
        
    } else {
        self.articleCellType = ArticleCellTypeStory;
        THNArticleStoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kArticleStoryCellIdentifier forIndexPath:indexPath];
        
        cell.collectionView.textCollectionBlock = ^(NSInteger rid) {
            THNArticleViewController *articleVC = [[THNArticleViewController alloc]init];
            articleVC.rid = rid;
            [weakSelf.navigationController pushViewController:articleVC animated:YES];
        };
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.collectionView.dataArray = self.lifeRecords;
        return cell;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *articleStr = self.dataArray[indexPath.row];
    if ([articleStr isEqualToString:kArticleCellTypeStore]) {
        THNFeaturedBrandModel *featuredBrandModel = [THNFeaturedBrandModel mj_objectWithKeyValues:self.grassListModel.recommend_store];
        THNBrandHallViewController *brandHallVC = [[THNBrandHallViewController alloc]init];
        brandHallVC.rid = featuredBrandModel.store_rid;
        [self.navigationController pushViewController:brandHallVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.articleCellType) {
        case ArticleCellTypeArticle:
            if (!self.lifeRecordsDetailCellHeight) {
               self.lifeRecordsDetailCellHeight = [UITableViewCell heightWithDaelContentData:self.contentModels];
            }
            return self.lifeRecordsDetailCellHeight;
        case ArticleCellTypeComment:{
            CGFloat commentHeight = 45 * self.comments.count + self.commentHeight;
            CGFloat subCommentHeight = 32 * self.moreThanSubComments.count + 18 * self.lessThanSubComments.count + self.subCommentHeight;
            // 间距 + 头部视图和尾部视图 + 一级评论 + 二级评论
            CGFloat headerWithFooterViewHeight = self.allCommentCount > 3 ? 89.5 : 49;
            return  15 * self.comments.count + headerWithFooterViewHeight + commentHeight + subCommentHeight;
        }
        case ArticleCellTypeStore:
            return 110;
        case ArticleCellTypeProduct:
            return 259;
        case ArticleCellTypeStory:
            if (!self.storyCellHeight) {
                self.storyCellHeight = [self getCellHeight:self.lifeRecords] + 10;
            }
            return self.storyCellHeight;
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.grassListModel) {
        [self.articleHeaderView setGrassListModel:self.grassListModel];
    }
   
    return self.articleHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGSize titleSize = CGSizeMake(SCREEN_WIDTH - 40, 56);
    NSDictionary *titleFont = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Semibold" size:20]};
    CGFloat titleHeight = [self.grassListModel.title boundingRectWithSize:titleSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:titleFont context:nil].size.height;
    return articleHeaderViewHeight + titleHeight;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat maxY = kDeviceiPhoneX ? 260 - 110 : 260 - 64;
    if (scrollView.contentOffset.y > maxY) {
        self.navigationBarView.transparent = NO;
        self.navigationBarView.title = self.grassListModel.channel_name;
    } else {
        self.navigationBarView.transparent = YES;
        self.navigationBarView.title = @"";
    }
}

// 表情和文字输入切换改变toolbar的位置
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

#pragma mark - THNToolBarViewDelegate
- (void)addComment:(NSString *)text {
    [self layoutToolView];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = @(self.rid);
    if (self.isSecondComment) {
        params[@"pid"] = @(self.pid);
    }
    params[@"content"] = text;
    THNRequest *request = [THNAPI postWithUrlString:kUrlLifeRecordsComments requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }

        self.subCommentHeight = 0;
        self.commentHeight = 0;
        [self.comments removeAllObjects];
        [self.subComments removeAllObjects];
        [self.lessThanSubComments removeAllObjects];
        [self.moreThanSubComments removeAllObjects];
        self.isNeedLocalHud = YES;
        [self loadLifeRecordsCommentData];
    } failure:^(THNRequest *request, NSError *error) {

    }];
}

#pragma mark - THNCommentTableViewDelegate
- (void)replyComment:(NSInteger)pid withSection:(NSInteger)section {
    self.pid = pid;
    self.section = section;
    self.isSecondComment = YES;
    [self layoutToolView];
}

- (void)lookAllSubComment {
    [self pushCommentVC];
}

#pragma mark - THNCommentViewDelegate
- (void)showKeyboard {
    self.isSecondComment = NO;
    [self layoutToolView];
}

- (void)lookComment {
    [self pushCommentVC];
}

#pragma mark - lazy
- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat bottomHeight = kDeviceiPhoneX ? 34 : 0;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, tableViewY, SCREEN_WIDTH, SCREEN_HEIGHT - tableViewY - commentViewHeight - bottomHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[THNDealContentTableViewCell class] forCellReuseIdentifier:kArticleContentCellIdentifier];
        [_tableView registerNib:[UINib nibWithNibName:@"THNArticleStoreTableViewCell" bundle:nil] forCellReuseIdentifier:kArticleStoreCellIdentifier];
        [_tableView registerNib:[UINib nibWithNibName:@"THNArticleProductTableViewCell" bundle:nil] forCellReuseIdentifier:kArticleProductCellIdentifier];
        [_tableView registerNib:[UINib nibWithNibName:@"THNArticleStoryTableViewCell" bundle:nil] forCellReuseIdentifier:kArticleStoryCellIdentifier];
    }
    return _tableView;
}

- (THNArticleHeaderView *)articleHeaderView {
    if (!_articleHeaderView) {
        _articleHeaderView = [THNArticleHeaderView viewFromXib];
    }
    return _articleHeaderView;
}

- (NSMutableArray *)contentModels {
    if (!_contentModels) {
        _contentModels = [NSMutableArray array];
    }
    return _contentModels;
}

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


- (THNCommentView *)commentView {
    if (!_commentView) {
        _commentView = [THNCommentView viewFromXib];
        CGFloat bottomHeight = kDeviceiPhoneX ? 34 : 0;
        _commentView.frame = CGRectMake(0, SCREEN_HEIGHT - commentViewHeight - bottomHeight, SCREEN_WIDTH, commentViewHeight);
    }
    return _commentView;
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
