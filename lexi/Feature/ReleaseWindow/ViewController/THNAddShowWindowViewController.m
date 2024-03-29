//
//  THNAddShowWindowViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/11/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNAddShowWindowViewController.h"
#import "THNSearchView.h"
#import "THNSearchHistoryCollectionViewCell.h"
#import "UIView+Helper.h"
#import "THNSearchHeaderView.h"
#import "THNShopWindowHotLabelTableViewCell.h"
#import "THNHotKeywordModel.h"
#import "THNSearchWindowLabelResultViewController.h"

typedef NS_ENUM(NSUInteger, AddShowWindowCellType) {
    AddShowWindowCellTypeHistory,
    AddShowWindowCellTypePopular
};

static NSString *const kShopWindowSearchHeaderViewIdentifier = @"kShopWindowSearchHeaderViewIdentifier";
static NSString *const kShopWindowsHotSearchCellIdentifier = @"kShopWindowsHotSearchCellIdentifier";
static NSString *const kShopWindowsHotSearchKeywords = @"/shop_windows/hot_keywords";
static NSString *const kShopWindowsSearchKeywords = @"/shop_windows/search/keywords";

@interface THNAddShowWindowViewController ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
THNSearchViewDelegate,
UICollectionViewDelegateFlowLayout,
THNMJRefreshDelegate
>

@property (nonatomic, strong) THNSearchView *searchView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *searchTypes;
@property (nonatomic, strong) NSArray *historyWords;
@property (nonatomic, assign) AddShowWindowCellType showWindowCellType;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) NSMutableArray *hotKeyWords;
@property (nonatomic, strong) THNSearchWindowLabelResultViewController *searchIndexVC;
@property(nonatomic, assign) NSInteger currentPage;

@end

@implementation THNAddShowWindowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addShowWindowLabel:) name:@"addLabelSuccess" object:nil];
    [self setupUI];
    [self loadData];
    [self.searchView readHistorySearch];
}

- (void)setupUI {
    self.navigationBarView.title = @"添加标签";
    [self.view addSubview:self.searchView];
    [self.searchView layoutSearchView:SearchViewTypeNoCancel withSearchKeyword:nil];
    [self.view addSubview:self.collectionView];
    [self.collectionView setRefreshFooterWithClass:nil automaticallyRefresh:YES delegate:self];
    [self.collectionView resetCurrentPageNumber];
    self.currentPage = 1;
}

- (void)loadData {
    [self loadPopulatSearchKeywordData];
}

- (void)loadPopulatSearchKeywordData {
    
    if (self.currentPage == 1) {
        [self showHud];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(self.currentPage);
    THNRequest *request = [THNAPI getWithUrlString:kShopWindowsHotSearchKeywords requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [self hiddenHud];
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }

        [self.hotKeyWords addObjectsFromArray:[THNHotKeywordModel mj_objectArrayWithKeyValuesArray:result.data[@"keywords"]]];
        
        if (self.hotKeyWords.count > 0 && ![self.searchTypes containsObject:@(AddShowWindowCellTypePopular)]) {
            [self.searchTypes addObject:@(AddShowWindowCellTypePopular)];
            [self.sections addObject:self.hotKeyWords];
        }
        
        [self.collectionView endFooterRefreshAndCurrentPageChange:YES];
        if (![result.data[@"next"] boolValue] && self.hotKeyWords.count != 0) {
            
            [self.collectionView noMoreData];
        }
        
        [self.collectionView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        [self hiddenHud];
    }];
}

- (void)addShowWindowLabel:(NSNotification *)notification {
    NSString *name = notification.userInfo[@"name"];
    [self.searchView addHistoryModelWithText:name];
    if (self.addShowWindowBlock) {
        self.addShowWindowBlock(name);
    }
    [self.navigationController popViewControllerAnimated:YES];
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

    THNRequest *request = [THNAPI getWithUrlString:kShopWindowsSearchKeywords requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [SVProgressHUD dismiss];
        if (!result.success) {
            [SVProgressHUD showWithStatus:result.statusMessage];
            return;
        }

        self.searchIndexVC.searchIndexs = [THNHotKeywordModel mj_objectArrayWithKeyValuesArray:result.data[@"keywords"]];
        self.searchIndexVC.textFieldText = mutableStr;
        [self.view addSubview:self.searchIndexVC.view];
        [self.searchIndexVC didMoveToParentViewController:self];
        [self.searchIndexVC.tableView reloadData];
        [self addChildViewController:self.searchIndexVC];

    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)removeSearchIndexView {
    if (self.childViewControllers.count == 0) {
        return;
    }

    UIViewController *vc = [self.childViewControllers lastObject];
    [vc.view removeFromSuperview];
    [vc removeFromParentViewController];
}

- (void)clearSearchHistoryData {
    self.historyWords = nil;
    [self.sections removeObjectAtIndex:0];
    [self.searchTypes removeObjectAtIndex:0];
    [self.searchView.historySearchArr removeAllObjects];
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [Path stringByAppendingPathComponent:shopWindowTypePathComponent];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    NSArray *items = self.sections[section];
    return items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AddShowWindowCellType showWindowCellType = [self.searchTypes[indexPath.section] integerValue];
    switch (showWindowCellType) {
            
        case AddShowWindowCellTypeHistory:{
            THNSearchHistoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kShopWindowsHotSearchCellIdentifier forIndexPath:indexPath];
            [cell setupCellViewUI];
            [cell setHistoryStr:self.historyWords[indexPath.row]];
            return cell;
        }
        case AddShowWindowCellTypePopular:{
            THNShopWindowHotLabelTableViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:shopWindowHotLabelCellIdentifier forIndexPath:indexPath];
            [cell setHotKeywordModel:self.hotKeyWords[indexPath.row]];
            return cell;
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    AddShowWindowCellType showWindowCellType = [self.searchTypes[indexPath.section] integerValue];
    THNHotKeywordModel * hotKeywordModel = self.hotKeyWords[indexPath.row];
    NSString *labelName;
    switch (showWindowCellType) {
            
        case AddShowWindowCellTypeHistory:{
            labelName = self.historyWords[indexPath.row];
           [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case AddShowWindowCellTypePopular:{
            labelName = hotKeywordModel.name;
           [self.navigationController popViewControllerAnimated:YES];
            break;
        }
    }

    if (self.addShowWindowBlock) {
        self.addShowWindowBlock(labelName);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    AddShowWindowCellType showWindowCellType = [self.searchTypes[indexPath.section] integerValue];
    self.showWindowCellType = showWindowCellType;
    
    switch (showWindowCellType) {
            
        case AddShowWindowCellTypeHistory:{
            self.showWindowCellType = AddShowWindowCellTypeHistory;
            CGFloat historyWordWidth = [self.historyWords[indexPath.row] boundingSizeWidthWithFontSize:14] + 20;
            return CGSizeMake(historyWordWidth, 30);
        }
        case AddShowWindowCellTypePopular:{
            self.showWindowCellType = AddShowWindowCellTypePopular;
            return CGSizeMake(SCREEN_WIDTH, 50);
        }
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    AddShowWindowCellType showWindowCellType = [self.searchTypes[indexPath.section] integerValue];
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kShopWindowSearchHeaderViewIdentifier forIndexPath:indexPath];
    THNSearchHeaderView *searchHeaderView = [THNSearchHeaderView viewFromXib];
    searchHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    searchHeaderView.deleteButton.hidden = !(showWindowCellType == AddShowWindowCellTypeHistory);
    [searchHeaderView.deleteButton addTarget:self action:@selector(clearSearchHistoryData) forControlEvents:UIControlEventTouchUpInside];
    
    switch (showWindowCellType) {
        case AddShowWindowCellTypeHistory:
            searchHeaderView.sectionTitle = @"历史添加";
            break;
        case AddShowWindowCellTypePopular:{
            self.showWindowCellType = AddShowWindowCellTypePopular;
            searchHeaderView.sectionTitle = @"热门标签";
            break;
        }
    }
    
    [headerView addSubview:searchHeaderView];
    return headerView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_WIDTH, 20);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    switch (self.showWindowCellType) {
        case AddShowWindowCellTypeHistory:
            return 15;
        default:
            return 0;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    switch (self.showWindowCellType) {
        case AddShowWindowCellTypePopular:
            return 0;
        default:
            return 10;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    switch (self.showWindowCellType) {
        case AddShowWindowCellTypeHistory:
            return UIEdgeInsetsMake(15, 20, 20, 20);
        default:
            return UIEdgeInsetsMake(15, 0, 20, 0);
    }
}

#pragma mark - THNMJRefreshDelegate
-(void)beginLoadingMoreDataWithCurrentPage:(NSNumber *)currentPage {
    self.currentPage = currentPage.integerValue;
    [self loadData];
}

#pragma mark - THNSearchViewDelegate
- (void)loadSearchHistory:(NSArray *)historyShowSearchArr {
    self.historyWords = historyShowSearchArr;
    if (self.historyWords.count > 0) {
        [self.searchTypes addObject:@(AddShowWindowCellTypeHistory)];
        [self.sections addObject:self.historyWords];
    }
}

- (void)loadSearchIndex:(NSString *)textFieldText {
    [self loadSearchIndexData:textFieldText];
}

#pragma mark - lazy
- (THNSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[THNSearchView alloc]initWithFrame:CGRectMake(20, NAVIGATION_BAR_HEIGHT + 10, SCREEN_WIDTH - 40, 30)];
        _searchView.historyWordSourceType = HistoryWordSourceTypeShopWindowLabel;
        _searchView.delegate = self;
    }
    return _searchView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGFloat collectionY = kDeviceiPhoneX ? 98 + 30 + 30 : 74 + 30 + 30;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, collectionY, SCREEN_WIDTH, SCREEN_HEIGHT - collectionY) collectionViewLayout:layout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[THNSearchHistoryCollectionViewCell class] forCellWithReuseIdentifier:kShopWindowsHotSearchCellIdentifier];
        [_collectionView registerNib:[UINib nibWithNibName:@"THNShopWindowHotLabelTableViewCell" bundle:nil] forCellWithReuseIdentifier:shopWindowHotLabelCellIdentifier];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kShopWindowSearchHeaderViewIdentifier];
    }
    return _collectionView;
}

- (NSMutableArray *)sections {
    if (!_sections) {
        _sections = [NSMutableArray array];
    }
    return _sections;
}

- (NSMutableArray *)searchTypes {
    if (!_searchTypes) {
        _searchTypes = [NSMutableArray array];
    }
    return _searchTypes;
}

- (THNSearchWindowLabelResultViewController *)searchIndexVC {
    if (!_searchIndexVC) {
        _searchIndexVC = [[THNSearchWindowLabelResultViewController alloc]init];
        _searchIndexVC.view.frame = CGRectMake(0, CGRectGetMaxY(self.searchView.frame) + 10, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    return _searchIndexVC;
}

- (NSMutableArray *)hotKeyWords {
    if (!_hotKeyWords) {
        _hotKeyWords = [NSMutableArray array];
    }
    return _hotKeyWords;
}

@end
