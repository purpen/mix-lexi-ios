//
//  THNLikedWindowViewController.m
//  lexi
//
//  Created by FLYang on 2018/8/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNWindowListViewController.h"
#import "THNLikedWindowCollectionViewCell.h"
#import "THNShopWindowDetailViewController.h"
#import "THNShopWindowModel.h"
#import "UIScrollView+THNMJRefresh.h"

static NSString *const kCollectionViewCellId = @"THNLikedWindowCollectionViewCellId";
///
static NSString *const kURLLikedWindow      = @"/shop_windows/user_likes";
static NSString *const kURLOtherLikedWindow = @"/shop_windows/other_user_likes";

@interface THNWindowListViewController () <UICollectionViewDelegate, UICollectionViewDataSource, THNMJRefreshDelegate>

/// 橱窗列表
@property (nonatomic, strong) UICollectionView *windowCollectionView;
/// 橱窗数据
@property (nonatomic, strong) NSMutableArray *windowArray;
/// 用户id
@property (nonatomic, strong) NSString *userId;
/// 当前页数
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation THNWindowListViewController

- (instancetype)initWithUserId:(NSString *)userId {
    self = [super init];
    if (self) {
        self.userId = userId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self thn_requestWindowListDataOfLoading:NO];
}

#pragma mark - custom delegate
- (void)beginLoadingMoreDataWithCurrentPage:(NSNumber *)currentPage {
    self.currentPage = currentPage.integerValue;
    [self thn_requestWindowListDataOfLoading:YES];
}

#pragma mark - network
- (void)thn_requestWindowListDataOfLoading:(BOOL)loading {
    if (!loading) {
        [SVProgressHUD thn_show];
    }
    
    NSString *urlStr = self.userId.length ? kURLOtherLikedWindow : kURLLikedWindow;
    
    WEAKSELF;
    
    THNRequest *request = [THNAPI getWithUrlString:urlStr requestDictionary:[self thn_requestParams] delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.isSuccess) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            [weakSelf.windowCollectionView endFooterRefreshAndCurrentPageChange:NO];
            return ;
        };
        
        [weakSelf.windowCollectionView endFooterRefreshAndCurrentPageChange:YES];
        
        THNWindowModel *model = [[THNWindowModel alloc] initWithDictionary:result.data];
        
        if (model.shopWindows.count) {
            [weakSelf.windowArray addObjectsFromArray:model.shopWindows];
            
        } else {
            [weakSelf.windowCollectionView noMoreData];
        }
        
        [weakSelf.windowCollectionView reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
    }];
}

// 橱窗列表默认的请求参数
- (NSDictionary *)thn_requestParams {
    NSDictionary *params = @{@"page": @(self.currentPage),
                             @"per_page": @(10)};
    
    if (self.userId.length) {
        NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithDictionary:params];
        [paramDict setObject:self.userId forKey:@"uid"];
        
        return [paramDict copy];
    }
    
    return params;
}

#pragma mark - open other controller
// 橱窗主页
- (void)thn_openWindowDetailContollerWithModel:(THNWindowModelShopWindows *)model {
    if (!model.rid) return;
    
    THNShopWindowModel *shopWindowModel = [THNShopWindowModel mj_objectWithKeyValues:[model toDictionary]];
    
    THNShopWindowDetailViewController *shopWindowDetail = [[THNShopWindowDetailViewController alloc] init];
    shopWindowDetail.shopWindowModel = shopWindowModel;
    [self.navigationController pushViewController:shopWindowDetail animated:YES];
}

#pragma mark - collectionView delegate & dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
        return self.windowArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNLikedWindowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellId
                                                                                       forIndexPath:indexPath];
    if (self.windowArray.count) {
        [cell thn_setWindowShopModel:self.windowArray[indexPath.row]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self thn_openWindowDetailContollerWithModel:(THNWindowModelShopWindows *)self.windowArray[indexPath.row]];
}

#pragma mark - setup UI
- (void)setupUI {
    [self.view addSubview:self.windowCollectionView];
    
    [self.windowCollectionView setRefreshFooterWithClass:nil automaticallyRefresh:YES delegate:self];
    self.currentPage = 1;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.title = kTitleLikedWindow;
}

#pragma mark - getters and setters
- (UICollectionView *)windowCollectionView {
    if (!_windowCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, kWPercentage(248.0));
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _windowCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
        _windowCollectionView.backgroundColor = [UIColor whiteColor];
        _windowCollectionView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
        _windowCollectionView.delegate = self;
        _windowCollectionView.dataSource = self;
        _windowCollectionView.showsVerticalScrollIndicator = NO;
        [_windowCollectionView registerClass:[THNLikedWindowCollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCellId];
    }
    return _windowCollectionView;
}

- (NSMutableArray *)windowArray {
    if (!_windowArray) {
        _windowArray = [NSMutableArray array];
    }
    return _windowArray;
}

@end
