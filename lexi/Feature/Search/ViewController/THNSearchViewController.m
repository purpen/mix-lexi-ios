//
//  THNSearchViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/9/26.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSearchViewController.h"
#import "THNSearchView.h"
#import "THNMarco.h"
#import "THNSearchHeaderView.h"
#import "UIView+Helper.h"
#import "THNSearchHistoryCollectionViewCell.h"
#import "NSString+Helper.h"
#import "THNProductCollectionViewCell.h"
#import "THNProductModel.h"
#import "THNSearchHotRecommendCollectionViewCell.h"
#import "THNSearchHotSearchCollectionViewCell.h"
#import "THNSearchHotRecommendModel.h"
#import "THNRecentlyViewedCollectionView.h"
#import "UICollectionViewFlowLayout+THN_flowLayout.h"
#import "THNSearchIndexTableViewController.h"
#import "THNSearchDetailViewController.h"
#import "THNSaveTool.h"
#import "THNGoodsListViewController.h"
#import "THNGoodsInfoViewController.h"
#import "THNBrandHallViewController.h"
#import "UIViewController+THNHud.h"
#import <SVProgressHUD/SVProgressHUD.h>

/**
 搜索提示内容

 - SearchTintTypeHistory: 历史
 - SearchTintTypeRecentlyViewed: 最近查看的商品
 - SearchTintTypePopularRecommend: 热门推荐
 - SearchTintTypePopularSearch: 热门搜索
 */
typedef NS_ENUM(NSUInteger, SearchTintType) {
    SearchTintTypeHistory,
    SearchTintTypeRecentlyViewed,
    SearchTintTypePopularRecommend,
    SearchTintTypePopularSearch
};

static NSString *const KSearchHistoryTitle = @"历史搜索";
static NSString *const KSearchRecentlyViewedTitle = @"最近查看";
static NSString *const KSearchHotRecommendTitle = @"热门推荐";
static NSString *const kSearchHotSearchTitle = @"热门搜索";

static NSString *const kSearchHeaderViewIdentifier = @"kSearchHeaderViewIdentifier";
static NSString *const kSearchHistoryCellIdentifier = @"kSearchHistoryCellIdentifier";
static NSString *const kSearchHotRecommendCellIdentifier = @"kSearc hHotRecommendCellIdentifier";
static NSString *const kSearchHotSearchCellIdentifier = @"kSearchHotSearchCellIdentifier";
static NSString *const KSearchDefaultCellIdentifier = @"KSearchDefaultCellIdentifier";

static NSString *const kUrlUserBrowses = @"/user_browses";
static NSString *const kUrlHotRecommend = @"/core_platforms/search/hot_recommend";
static NSString *const kUrlHotSearch = @"/core_platforms/search/week_hot";
static NSString *const kUrlSearchIndex = @"/core_platforms/search";

@interface THNSearchViewController ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
THNSearchViewDelegate,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) THNSearchView *searchView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *historyWords;
@property (nonatomic, strong) NSArray *recentlyViewedProducts;
@property (nonatomic, strong) NSMutableArray *popularRecommends;
@property (nonatomic, strong) NSArray *popularSearchs;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) NSMutableArray *sectionTitles;
// 搜索索引数据
@property (nonatomic, strong) NSArray *searchIndexs;
@property (nonatomic, assign) SearchTintType searchTintType;
@property (nonatomic, strong) THNRecentlyViewedCollectionView *productCollectionView;
@property (nonatomic, assign) CGFloat totalHistoryWordWidth;
@property (nonatomic, strong) THNSearchIndexTableViewController *searchIndexVC;
@property (nonatomic, assign) SearchChildVCType childVCType;
@property (nonatomic, assign) BOOL isClickTextField;

@end

@implementation THNSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadUserBrowseData];
}

- (void)setupUI {
    self.navigationBarView.hidden = YES;
    [self.searchView layoutSearchView:SearchViewTypeDefault withSearchKeyword:nil];
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.collectionView];
}

// 最近查看
- (void)loadUserBrowseData {
    [self showHud];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    THNRequest *request = [THNAPI getWithUrlString:kUrlUserBrowses requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [self.searchView readHistorySearch];
        self.recentlyViewedProducts = result.data[@"products"];
        if (self.recentlyViewedProducts.count > 0) {
            [self.sectionTitles addObject:KSearchRecentlyViewedTitle];
            [self.sections addObject:self.recentlyViewedProducts];
        }
        // 按展示顺序往下请求
        [self loadHotRecommendData];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

// 热门推荐
- (void)loadHotRecommendData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    THNRequest *request = [THNAPI getWithUrlString:kUrlHotRecommend requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [self.popularRecommends addObjectsFromArray:result.data[@"hot_recommends"]];
        if (self.popularRecommends.count > 0) {
            [self.sectionTitles addObject:KSearchHotRecommendTitle];
            [self.sections addObject:self.popularRecommends];
        }

        [self loadHotSearchData];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

// 热门搜索
- (void)loadHotSearchData {
    THNRequest *request = [THNAPI getWithUrlString:kUrlHotSearch requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [self hiddenHud];
        self.popularSearchs = result.data[@"search_items"];
        if (self.popularSearchs.count > 0) {
            [self.sectionTitles addObject:kSearchHotSearchTitle];
        }
        [self.sections addObject:self.popularSearchs];
        [self.collectionView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        [self hiddenHud];
    }];
}

// 关键字索引数据
- (void)loadSearchIndexData:(NSString *)textFieldText {
    // 过滤空格
    NSMutableString *mutableStr = [[textFieldText stringByReplacingOccurrencesOfString:@" " withString:@""] mutableCopy];
    // 搜索关键词为nil ，清除视图
    if (mutableStr.length == 0) {
        [self removeSearchIndexView];
        return;
    }
    
    [SVProgressHUD thn_show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"qk"] = mutableStr;
    
    THNRequest *request = [THNAPI getWithUrlString:kUrlSearchIndex requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [SVProgressHUD dismiss];
        self.searchIndexs = result.data[@"search_items"];
        [self.view addSubview:self.searchIndexVC.view];
        self.searchIndexVC.searchIndexs = self.searchIndexs;
        self.searchIndexVC.textFieldText = mutableStr;
        [self.searchIndexVC didMoveToParentViewController:self];
        [self.searchIndexVC.tableView reloadData];
        [self addChildViewController:self.searchIndexVC];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)clearSearchHistoryData {
    self.historyWords = nil;
    [self.sections removeObjectAtIndex:0];
    [self.sectionTitles removeObjectAtIndex:0];
    [self.searchView.historySearchArr removeAllObjects];
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [Path stringByAppendingPathComponent:@"historySearch.data"];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return self.sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    NSString *sectionTitle = self.sectionTitles[section];
    if ([sectionTitle isEqualToString:KSearchRecentlyViewedTitle]) {
        return 1;
    } else {
        NSArray *items = self.sections[section];
        return items.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *sectionTitle = self.sectionTitles[indexPath.section];
    if ([sectionTitle isEqualToString:KSearchHistoryTitle]) {
        THNSearchHistoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSearchHistoryCellIdentifier forIndexPath:indexPath];
        [cell setupCellViewUI];
        [cell setHistoryStr:self.historyWords[indexPath.row]];
        return cell;
    } else if ([sectionTitle isEqualToString:KSearchRecentlyViewedTitle]) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KSearchDefaultCellIdentifier forIndexPath:indexPath];
        
        __weak typeof(self)weakSelf = self;
        self.productCollectionView.recentlyViewedBlock = ^(NSString *goodID) {
            THNGoodsInfoViewController *goodInfoVC = [[THNGoodsInfoViewController alloc]initWithGoodsId:goodID];
            [weakSelf.navigationController pushViewController:goodInfoVC animated:YES];
        };
        
         self.productCollectionView.recentlyViewedProducts = self.recentlyViewedProducts;
        [cell addSubview:self.productCollectionView];
        return cell;
    } else if ([sectionTitle isEqualToString:KSearchHotRecommendTitle]) {
        THNSearchHotRecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSearchHotRecommendCellIdentifier forIndexPath:indexPath];
        THNSearchHotRecommendModel *hotRecommendModel = [THNSearchHotRecommendModel mj_objectWithKeyValues:self.popularRecommends[indexPath.row]];
        [cell setHotRecommentModel:hotRecommendModel];
        return cell;
    } else {
        THNSearchHotSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSearchHotSearchCellIdentifier forIndexPath:indexPath];
        if (indexPath.row < 3) {
            cell.hotSearchImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_search_%ld",indexPath.row]];
        } else {
            cell.hotSearchImageView.image = [UIImage imageNamed:@"icon_search_other"];
        }
     
        [cell setHotSerarchStr:self.popularSearchs[indexPath.row][@"query_word"]];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *sectionTitle = self.sectionTitles[indexPath.section];
    if ([sectionTitle isEqualToString:KSearchHistoryTitle]) {
        [THNSaveTool setObject:self.historyWords[indexPath.row] forKey:kSearchKeyword];
        [self pushSearchDetailVC];
    } else if ([sectionTitle isEqualToString:KSearchHotRecommendTitle]) {
        // 接单定制
        if (indexPath.row == 0) {
            // FYNN 实现 目前假的跳转
            THNGoodsListViewController *goodListVC = [[THNGoodsListViewController alloc]initWithGoodsListType:THNGoodsListViewTypeCustomization title:@"接单定制"];
            [self.navigationController pushViewController:goodListVC animated:YES];
        } else {
            THNSearchHotRecommendModel *hotRecommendModel = [THNSearchHotRecommendModel mj_objectWithKeyValues:self.popularRecommends[indexPath.row]];
            
            // 1=商品, 2=店铺
            if (hotRecommendModel.target_type == 1) {
                THNGoodsInfoViewController *goodInfoVC = [[THNGoodsInfoViewController alloc]initWithGoodsId:hotRecommendModel.rid];
                [self.navigationController pushViewController:goodInfoVC animated:YES];
            } else {
                THNBrandHallViewController *brandHallVC = [[THNBrandHallViewController alloc]init];
                brandHallVC.rid = hotRecommendModel.rid;
                [self.navigationController pushViewController:brandHallVC animated:YES];
            }
        }
    } else {
        NSString *queryWord = self.popularSearchs[indexPath.row][@"query_word"];
        [self.searchView addHistoryModelWithText:queryWord];
        [THNSaveTool setObject:queryWord forKey:kSearchKeyword];
        [self pushSearchDetailVC];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *sectionTitle = self.sectionTitles[indexPath.section];
    if ([sectionTitle isEqualToString:KSearchHistoryTitle]) {
        self.searchTintType = SearchTintTypeHistory;
        CGFloat historyWordWidth = [self.historyWords[indexPath.row] boundingSizeWidthWithFontSize:14] + 20;
        return CGSizeMake(historyWordWidth, 30);
        
    } else if ([sectionTitle isEqualToString:KSearchRecentlyViewedTitle]) {
        self.searchTintType = SearchTintTypeRecentlyViewed;
        return CGSizeMake(SCREEN_WIDTH, 129);
    } else if ([sectionTitle isEqualToString:KSearchHotRecommendTitle]) {
        self.searchTintType = SearchTintTypePopularRecommend;
        return CGSizeMake(75, 72);
    } else {
        self.searchTintType = SearchTintTypePopularSearch;
        return CGSizeMake(SCREEN_WIDTH, 50);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSearchHeaderViewIdentifier forIndexPath:indexPath];
    THNSearchHeaderView *searchHeaderView = [THNSearchHeaderView viewFromXib];
    searchHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    NSString *sectionTitle = self.sectionTitles[indexPath.section];
    searchHeaderView.deleteButton.hidden = ![sectionTitle isEqualToString:KSearchHistoryTitle];
    [searchHeaderView.deleteButton addTarget:self action:@selector(clearSearchHistoryData) forControlEvents:UIControlEventTouchUpInside];
    [searchHeaderView setSectionTitle:self.sectionTitles[indexPath.section]];
    
    [headerView addSubview:searchHeaderView];
    return headerView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_WIDTH, 20);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    switch (self.searchTintType) {
        case SearchTintTypeHistory:
            return 15;
        default:
            return 0;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    switch (self.searchTintType) {
        case SearchTintTypePopularRecommend:
            return UIEdgeInsetsMake(15, 10, 20, 20);
        default:
            return UIEdgeInsetsMake(15, 20, 20, 20);
    }
}

// 隐藏键盘
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - THNSearchViewDelegate
- (void)back {
    if (!self.isClickTextField) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self pushSearchDetailVC];
    }
}

- (void)loadSearchHistory:(NSArray *)historyShowSearchArr {
    self.historyWords = historyShowSearchArr;
    if (self.historyWords.count > 0) {
        [self.sectionTitles addObject:KSearchHistoryTitle];
        [self.sections addObject:self.historyWords];
    }
}

- (void)loadSearchIndex:(NSString *)textFieldText {
    [self loadSearchIndexData:textFieldText];
}

- (void)removeSearchIndexView {
    if (self.childViewControllers.count == 0) {
        return;
    }
    
    UIViewController *vc = [self.childViewControllers lastObject];
    [vc.view removeFromSuperview];
    [vc removeFromParentViewController];
}

- (void)pushSearchDetailVC {
    THNSearchDetailViewController *searchDetailVC = [[THNSearchDetailViewController alloc]init];
    
    searchDetailVC.searchDetailBlock = ^(NSString *searchWord, NSInteger childVCType, BOOL isClickTextField) {
        self.childVCType = childVCType;
        self.isClickTextField = isClickTextField;
        [self.searchView setSearchWord:searchWord];
    };
    
    if (self.childVCType) {
        searchDetailVC.childVCType = self.childVCType;
    } else {
        searchDetailVC.childVCType = SearchChildVCTypeProduct;
    }
    
    [self.navigationController pushViewController:searchDetailVC animated:YES];
}

#pragma mark - lazy
- (THNSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[THNSearchView alloc]initWithFrame:CGRectMake(20, STATUS_BAR_HEIGHT + 7, SCREEN_WIDTH, 30)];
        _searchView.delegate = self;
    }
    return _searchView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT + 20, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 70, 0);
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:KSearchDefaultCellIdentifier];
        [_collectionView registerClass:[THNSearchHistoryCollectionViewCell class] forCellWithReuseIdentifier:kSearchHistoryCellIdentifier];
        [_collectionView registerNib:[UINib nibWithNibName:@"THNSearchHotRecommendCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kSearchHotRecommendCellIdentifier];
        [_collectionView registerNib:[UINib nibWithNibName:@"THNSearchHotSearchCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kSearchHotSearchCellIdentifier];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSearchHeaderViewIdentifier];
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

- (NSMutableArray *)sections {
    if (!_sections) {
        _sections = [NSMutableArray array];
    }
    return _sections;
}

- (NSMutableArray *)sectionTitles {
    if (!_sectionTitles) {
        _sectionTitles = [NSMutableArray array];
    }
    return _sectionTitles;
}

- (THNRecentlyViewedCollectionView *)productCollectionView {
    if (!_productCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] initWithLineSpacing:25
                                                                                       initWithWidth:100
                                                                                      initwithHeight:129];
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 40);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _productCollectionView = [[THNRecentlyViewedCollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 129) collectionViewLayout:layout];
    }
    return _productCollectionView;
}

- (THNSearchIndexTableViewController *)searchIndexVC {
    if (!_searchIndexVC) {
        _searchIndexVC = [[THNSearchIndexTableViewController alloc]init];
        _searchIndexVC.view.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    return _searchIndexVC;
}

- (NSMutableArray *)popularRecommends {
    if (!_popularRecommends) {
        _popularRecommends = [NSMutableArray arrayWithObject:@{
                                                               @"recommend_title":@"接单定制"
                                                               }];
    }
    return _popularRecommends;
}

@end
