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
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "THNShareViewController.h"
#import "THNUserCenterViewController.h"

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
@property (nonatomic, strong) NSString *replyUserName;

@end

@implementation THNArticleViewController {
    CGFloat tableViewY;
    CGFloat articleHeaderViewHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushCommentVC) name:kLookAllCommentData object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushGoodInfoVC:) name:THNGoodInfoVCSeeProductDetail object:nil];
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
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
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

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    self.toolbar.hidden = YES;
}

- (void)pushCommentVC {
    THNCommentViewController *commentVC = [[THNCommentViewController alloc]init];
    commentVC.rid = [NSString stringWithFormat:@"%ld",self.rid];
    commentVC.commentCount = self.allCommentCount;
    [self.navigationController pushViewController:commentVC animated:YES];
}

- (void)pushGoodInfoVC:(NSNotification *)notification {
    NSString *goodInfoRid = notification.userInfo[@"goodInfoRid"];
    THNGoodsInfoViewController *goodInfo = [[THNGoodsInfoViewController alloc]initWithGoodsId:goodInfoRid];
    [self.navigationController pushViewController:goodInfo animated:YES];
}

// 文章详情
- (void)loadLifeRecordsDetailData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = @(self.rid);
    self.loadViewY = NAVIGATION_BAR_HEIGHT;
    [self showHud];
    THNRequest *request = [THNAPI getWithUrlString:kUrlLifeRecordsDetail requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
#ifdef DEBUG
        THNLog(@"文章详情 ----- %@", [NSString jsonStringWithObject:result.responseDict]);
#endif
        [self hiddenHud];
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
        
        if (self.contentModels.count > 0) {
            [self.dataArray addObject:KArticleCellTypeArticle];
        }
    
        if (self.grassListModel.recommend_store.count > 0) {
            [self.dataArray addObject:kArticleCellTypeStore];
        }
        
        [self.tableView reloadData];
        [self loadRecommendProductData];
    } failure:^(THNRequest *request, NSError *error) {

    }];
}

- (void)loadLifeRecordsCommentData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = @(self.rid);
    THNRequest *request = [THNAPI getWithUrlString:kUrlLifeRecordsComments requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        self.allCommentCount = [result.data[@"total_count"] integerValue];
        [self setTotalCommentCount];
        
        [self.comments addObjectsFromArray:[THNCommentModel mj_objectArrayWithKeyValuesArray:result.data[@"comments"]]];
        
        // 最大显示三条
        if (self.comments.count > maxShowComment) {
             [self.comments removeObjectsInRange:NSMakeRange(maxShowComment, self.comments.count - maxShowComment)];
        }
        
        for (THNCommentModel *commentModel in self.comments) {
            commentModel.height = [self getSizeByString:commentModel.content withFontSize:[UIFont fontWithName:@"PingFangSC-Regular" size:12] withMaxWidth:SCREEN_WIDTH - 85 - 35];
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
                    [self.lessThanSubComments addObject:subCommentModel];
                    self.subCommentHeight += subCommentModel.height;
                }

                [self.subComments addObject:lessThanSubComments];
            }
        }
        
        if (self.comments.count > 0 && ![self.dataArray containsObject:KArticleCellTypeComment]) {
            // 评论插入位置,有推荐故事为倒数二,否则为最后一个
            NSInteger insertIndex = self.lifeRecords.count > 0 ? 1 : 0;
            [self.dataArray insertObject:KArticleCellTypeComment atIndex:self.dataArray.count - insertIndex];
        }
        
        if (self.isNeedLocalHud) {
//            NSInteger commentCellIndex = 0;
//            for (UITableViewCell *cell in self.tableView.visibleCells) {
//                if ([cell.class isSubclassOfClass:[THNCommentTableViewCell class]]) {
//                    commentCellIndex = [self.tableView indexPathForCell:cell].row;
//                }
//            }
//
//            NSInteger commentInDataArrayIndex = [self.dataArray indexOfObject:KArticleCellTypeComment];
//
//            if (commentCellIndex == commentInDataArrayIndex) {
//
//            } else {
//                [self.tableView layoutIfNeeded]
//
//                [self.tableView scrollToRow:commentInDataArrayIndex inSection:0 atScrollPosition:UITableViewScrollPositionNone animated:YES];
//            }
            [self.tableView reloadData];
            return;
        }

        
        [self loadRecommendStoryData];
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)setTotalCommentCount {
    [self.commentView setCommentView:self.grassListModel initWithCommentTotalCount:self.allCommentCount];
    [THNSaveTool setObject:@(self.allCommentCount) forKey:kCommentCount];
}

// 推荐商品
- (void)loadRecommendProductData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = @(self.rid);
    THNRequest *request = [THNAPI getWithUrlString:kUrlLifeRecordsRecommendProducts requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
            [SVProgressHUD showWithStatus:result.statusMessage];
            return;
        }
        
        self.products = result.data[@"products"];
        
        if (self.products > 0) {
             [self.dataArray addObject:kArticleCellTypeProduct];
        }
       
        [self loadLifeRecordsCommentData];
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
        if (!result.success) {
            [SVProgressHUD showWithStatus:result.statusMessage];
            return;
        }
        
        self.lifeRecords = result.data[@"life_records"];
        
        if (self.lifeRecords.count > 0) {
            [self.dataArray addObject:kArticleCellTypeStory];
        }
        
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
    
    if (self.replyUserName.length == 0) {
        return;
    }
    
    self.toolbar.textView.placeholderText = [NSString stringWithFormat:@"回复 %@:",self.replyUserName];
    self.toolbar.textView.placeholderFont = [UIFont systemFontOfSize:14];
}

//获取字符串高度的方法
- (CGFloat)getSizeByString:(NSString *)string withFontSize:(UIFont *)font withMaxWidth:(CGFloat)maxWidth {
    CGSize size = [string boundingRectWithSize:CGSizeMake(maxWidth, 999) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
    return size.height;
}

/**
 获取文章类型（种草笔记边距不一样）
 */
- (THNDealContentType)thn_getArticleContentType {
    THNArticleType articleType = [self thn_getArticleType];

    if (articleType == THNArticleTypeNote) {
        return THNDealContentTypeGrassNote;
    }
    
    return THNDealContentTypeArticle;
}

/**
 文章类型，区分“种草笔记“
 */
- (THNArticleType)thn_getArticleType {
    BOOL isGrassNote = [self.grassListModel.channel_name isEqualToString:grassNote];
    
    if (isGrassNote) {
        return THNArticleTypeNote;
    }
    
    return THNArticleTypeDefault;
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
        [cell thn_setDealContentData:self.contentModels type:[self thn_getArticleContentType]];
        return cell;

    } else if ([articleStr isEqualToString:KArticleCellTypeComment]) {
        self.articleCellType = ArticleCellTypeComment;
        THNCommentTableViewCell *cell = [THNCommentTableViewCell viewFromXib];
        cell.isRewriteCellHeight = YES;
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
            if (self.lifeRecordsDetailCellHeight == 0) {
                self.lifeRecordsDetailCellHeight = [UITableViewCell heightWithDaelContentData:self.contentModels
                                                                                         type:[self thn_getArticleContentType]];
            }
            return self.lifeRecordsDetailCellHeight;
        case ArticleCellTypeComment:{
            CGFloat commentHeight = 45 * self.comments.count + self.commentHeight;
            CGFloat subCommentHeight = 32 * self.moreThanSubComments.count + 18 * self.lessThanSubComments.count + self.subCommentHeight;
            // 间距 + 头部视图和尾部视图 + 一级评论 + 二级评论
            CGFloat headerWithFooterViewHeight = self.allCommentCount > 3 ? 89.5 : 49;
            return  15 * self.comments.count + headerWithFooterViewHeight + commentHeight + subCommentHeight + 15;
        }
        case ArticleCellTypeStore:
            return 110;
        case ArticleCellTypeProduct:
            return 259;
        case ArticleCellTypeStory:
            if (self.storyCellHeight == 0) {
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
- (void)replyComment:(NSInteger)pid withSection:(NSInteger)section withReplyUserName:(NSString *)replyUserName {
    self.pid = pid;
    self.replyUserName = replyUserName;
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

- (void)lookUserCenter:(NSString *)uid {
    THNUserCenterViewController *userCentenVC = [[THNUserCenterViewController alloc]initWithUserId:uid];
    [self.navigationController pushViewController:userCentenVC animated:YES];
}

- (void)shareArticle {
    if (!self.rid) {
        return;
    }
    
    NSString *requestId = [NSString stringWithFormat:@"%zi", self.rid];
    BOOL isNote = [self thn_getArticleType] == THNArticleTypeNote;
    THNSharePosterType posterType = isNote  ? THNSharePosterTypeNote : THNSharePosterTypeArticle;
    
    NSString *shareUrlPrefix;
    
    if (self.grassListModel.type == DisCoverContentTypeArticle) {
        shareUrlPrefix = kShareArticleUrlPrefix;
        
    } else if (self.grassListModel.type == DisCoverContentTypeGrassList) {
        shareUrlPrefix = kShareGrassUrlPrefix;
    }

    THNShareViewController *shareVC = [[THNShareViewController alloc] initWithType:posterType requestId:requestId];
    [shareVC shareObjectWithTitle:self.grassListModel.title
                            descr:self.grassListModel.des
                        thumImage:self.grassListModel.cover
                           webUrl:[shareUrlPrefix stringByAppendingString:requestId]];
    shareVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:shareVC animated:NO completion:nil];
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
        // 添加数据刷新后，防止tableview滑动(防止reload滑动)
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
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
