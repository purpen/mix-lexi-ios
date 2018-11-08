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

typedef NS_ENUM(NSUInteger, ArticleCellType) {
    ArticleCellTypeArticle,
    ArticleCellTypeStore,
    ArticleCellTypeProduct,
    ArticleCellTypeStory
};

@interface THNArticleViewController ()<UITableViewDelegate, UITableViewDataSource>

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

@end

@implementation THNArticleViewController {
    CGFloat tableViewY;
    CGFloat articleHeaderViewHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    tableViewY = kDeviceiPhoneX ? -44 : -22;
    articleHeaderViewHeight = 335 + 64 + 22;
    [self setupUI];
    [self loadLifeRecordsDetailData];
}

- (void)setupUI {
    self.navigationBarView.transparent = YES;
    [self.navigationBarView setNavigationCloseButton];
    [self.navigationBarView setNavigationCloseButtonHidden:YES];
    [self.view addSubview:self.tableView];
}

// 文章详情
- (void)loadLifeRecordsDetailData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = @(self.rid);
    self.loadViewY = NAVIGATION_BAR_HEIGHT;
    [self showHud];
    THNRequest *request = [THNAPI getWithUrlString:kUrlLifeRecordsDetail requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        THNLog(@"---------- 文章详情：%@", result.responseDict);
        [self hiddenHud];
        [self loadRecommendProductData];

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
        
        [self loadRecommendProductData];
        
    } failure:^(THNRequest *request, NSError *error) {

    }];
}

- (void)loadLifeRecordsCommentData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = @(self.rid);
    THNRequest *request = [THNAPI getWithUrlString:kUrlLifeRecordsComments requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        
    } failure:^(THNRequest *request, NSError *error) {
        
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

#pragma mark - lazy
- (UITableView *)tableView {
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, tableViewY, SCREEN_WIDTH, SCREEN_HEIGHT - tableViewY) style:UITableViewStyleGrouped];
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

@end
