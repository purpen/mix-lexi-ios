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

/**
 搜索提示内容

 - SearchTintTypeHistory: 历史testfsafsf f
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

static NSString *const kSearchHeaderViewIdentifier = @"kSearchHeaderViewIdentifier";
static NSString *const kSearchHistoryCellIdentifier = @"kSearchHistoryCellIdentifier";
static NSString *const kSearchProductCellIdentifier = @"kSearchProductCellIdentifier";
static NSString *const kSearchHotRecommendCellIdentifier = @"kSearchHotRecommendCellIdentifier";
static NSString *const kSearchHotSearchCellIdentifier = @"kSearchHotSearchCellIdentifier";

static NSString *const kUrlSearchHistory = @"/core_platforms/search/history";
static NSString *const kUrlUserBrowses = @"/user_browses";
static NSString *const kUrlHotRecommend = @"/core_platforms/search/hot_recommend";
static NSString *const kUrlHotSearch = @"/core_platforms/search/week_hot";

@interface THNSearchViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) THNSearchView *searchView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *historyWords;
@property (nonatomic, strong) NSArray *recentlyViewedProducts;
@property (nonatomic, strong) NSArray *popularRecommends;
@property (nonatomic, strong) NSArray *popularSearchs;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, assign) SearchTintType searchTintType;


@end

@implementation THNSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSearchHistoryData];
    [self setupUI];
}

- (void)setupUI {
    self.navigationBarView.hidden = YES;
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.collectionView];
    
    __weak typeof(self)weakSelf = self;
    self.searchView.popBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}

// 历史搜索关键词
- (void)loadSearchHistoryData {
    THNRequest *request = [THNAPI getWithUrlString:kUrlSearchHistory requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.historyWords = result.data[@"search_items"];
        if (self.historyWords.count > 0) {
            [self.sections addObject:@"历史搜索"];
        }
        [self loadUserBrowseData];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

// 最近查看
- (void)loadUserBrowseData {
    THNRequest *request = [THNAPI getWithUrlString:kUrlUserBrowses requestDictionary:nil     delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.recentlyViewedProducts = result.data[@"products"];
        if (self.recentlyViewedProducts.count > 0) {
            [self.sections addObject:@"最近查看"];
        }
        [self loadHotRecommendData];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

// 热门推荐
- (void)loadHotRecommendData {
    THNRequest *request = [THNAPI getWithUrlString:kUrlHotRecommend requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.popularRecommends = result.data[@"hot_recommends"];
        if (self.popularRecommends.count > 0) {
            [self.sections addObject:@"热门推荐"];
        }
        [self loadHotSearchData];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

// 热门搜索
- (void)loadHotSearchData {
    THNRequest *request = [THNAPI getWithUrlString:kUrlHotSearch requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.popularSearchs = result.data[@"search_items"];
        if (self.popularSearchs.count > 0) {
            [self.sections addObject:@"热门搜索"];
        }
        [self.collectionView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (section) {
        case 0:{
            if (self.historyWords.count > 0) {
                self.searchTintType = SearchTintTypeHistory;
                return self.historyWords.count;
            } else if (self.recentlyViewedProducts.count > 0) {
                self.searchTintType = SearchTintTypeRecentlyViewed;
                return self.recentlyViewedProducts.count;
            } else if (self.popularRecommends.count > 0) {
                self.searchTintType = SearchTintTypePopularRecommend;
                return self.popularRecommends.count;
            } else if (self.popularSearchs.count > 0) {
                self.searchTintType = SearchTintTypePopularSearch;
                return self.popularSearchs.count;
            }
        }
            
        case 1:{
            if (self.recentlyViewedProducts.count > 0) {
                self.searchTintType = SearchTintTypeRecentlyViewed;
                return self.recentlyViewedProducts.count;
            } else if (self.popularRecommends.count > 0) {
                self.searchTintType = SearchTintTypePopularRecommend;
                return self.popularRecommends.count;
            } else if (self.popularSearchs.count > 0) {
                self.searchTintType = SearchTintTypePopularSearch;
                return self.popularSearchs.count;
            }
        }
        
        case 2:{
            if (self.popularRecommends.count > 0) {
                self.searchTintType = SearchTintTypePopularRecommend;
                return self.popularRecommends.count;
            } else if (self.popularSearchs.count > 0) {
                self.searchTintType = SearchTintTypePopularSearch;
                return self.popularSearchs.count;
            }
        }
            
        default:
            self.searchTintType = SearchTintTypePopularSearch;
            return self.popularSearchs.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:{
            if (self.historyWords.count > 0) {
                THNSearchHistoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSearchHistoryCellIdentifier forIndexPath:indexPath];
                [cell setHistoryStr:self.historyWords[indexPath.row][@"query_word"]];
                return cell;
            } else if (self.recentlyViewedProducts.count > 0) {
                THNProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSearchProductCellIdentifier forIndexPath:indexPath];
                THNProductModel *productModel = [THNProductModel mj_objectWithKeyValues:self.recentlyViewedProducts[indexPath.row]];
                [cell setProductModel:productModel initWithType:THNHomeTypeExplore];
            } else if (self.popularRecommends.count > 0) {
                THNSearchHotRecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSearchHotRecommendCellIdentifier forIndexPath:indexPath];
                return cell;
            } else if (self.popularSearchs.count > 0) {
                THNSearchHotSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSearchHotSearchCellIdentifier forIndexPath:indexPath];
                return cell;
            }
        }
            
        case 1:{
            if (self.recentlyViewedProducts.count > 0) {
                THNProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSearchProductCellIdentifier forIndexPath:indexPath];
                THNProductModel *productModel = [THNProductModel mj_objectWithKeyValues:self.recentlyViewedProducts[indexPath.row]];
                [cell setProductModel:productModel initWithType:THNHomeTypeExplore];
            } else if (self.popularRecommends.count > 0) {
                THNSearchHotRecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSearchHotRecommendCellIdentifier forIndexPath:indexPath];
                return cell;
            } else if (self.popularSearchs.count > 0) {
                THNSearchHotSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSearchHotSearchCellIdentifier forIndexPath:indexPath];
                return cell;
            }
        }
            
        case 2:{
            if (self.popularRecommends.count > 0) {
                THNSearchHotRecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSearchHotRecommendCellIdentifier forIndexPath:indexPath];
                return cell;
            } else if (self.popularSearchs.count > 0) {
                THNSearchHotSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSearchHotSearchCellIdentifier forIndexPath:indexPath];
                return cell;
            }
        }
            
        default:
            self.searchTintType = SearchTintTypePopularSearch;
            THNSearchHotSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSearchHotSearchCellIdentifier forIndexPath:indexPath];
            return cell;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:{
            if (self.historyWords.count > 0) {
                self.searchTintType = SearchTintTypeHistory;
                return CGSizeMake([self.historyWords[indexPath.row][@"query_word"] boundingSizeWidthWithFontSize:14] + 12, 30);;
            } else if (self.recentlyViewedProducts.count > 0) {
                self.searchTintType = SearchTintTypeRecentlyViewed;
                return CGSizeMake(100, 129);
            } else if (self.popularRecommends.count > 0) {
                self.searchTintType = SearchTintTypePopularRecommend;
                return CGSizeMake(45, 67);
            } else if (self.popularSearchs.count > 0) {
                self.searchTintType = SearchTintTypePopularSearch;
                return CGSizeMake(SCREEN_WIDTH, 50);
            }
        }
            
        case 1:{
            if (self.recentlyViewedProducts.count > 0) {
                self.searchTintType = SearchTintTypeRecentlyViewed;
                return CGSizeMake(100, 129);
            } else if (self.popularRecommends.count > 0) {
                self.searchTintType = SearchTintTypePopularRecommend;
                return CGSizeMake(45, 67);
            } else if (self.popularSearchs.count > 0) {
                self.searchTintType = SearchTintTypePopularSearch;
                return CGSizeMake(SCREEN_WIDTH, 50);
            }
        }
            
        case 2:{
            if (self.popularRecommends.count > 0) {
                self.searchTintType = SearchTintTypePopularRecommend;
                return CGSizeMake(45, 67);
            } else if (self.popularSearchs.count > 0) {
                self.searchTintType = SearchTintTypePopularSearch;
                return CGSizeMake(SCREEN_WIDTH, 50);
            }
        }
            
        default:
            self.searchTintType = SearchTintTypePopularSearch;
            return CGSizeMake(SCREEN_WIDTH, 50);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSearchHeaderViewIdentifier forIndexPath:indexPath];
    THNSearchHeaderView *searchHeaderView = [THNSearchHeaderView viewFromXib];
    searchHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    
    searchHeaderView.deleteButton.hidden = indexPath.section !=  0;
    [searchHeaderView setSectionTitle:self.sections[indexPath.section]];
    
    [headerView addSubview:searchHeaderView];
    return headerView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_WIDTH, 20);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

#pragma mark - lazy
- (THNSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[THNSearchView alloc]initWithFrame:CGRectMake(20, STATUS_BAR_HEIGHT + 7, SCREEN_WIDTH, 30)];;
    }
    return _searchView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.sectionInset = UIEdgeInsetsMake(15, 20, 20, 20);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT + 20, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 70, 0);
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[THNSearchHistoryCollectionViewCell class] forCellWithReuseIdentifier:kSearchHistoryCellIdentifier];
        [_collectionView registerNib:[UINib nibWithNibName:@"THNProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kSearchProductCellIdentifier];
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


@end
