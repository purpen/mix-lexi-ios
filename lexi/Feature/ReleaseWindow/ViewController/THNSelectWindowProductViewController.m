//
//  THNSelectWindowProductViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/11/14.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSelectWindowProductViewController.h"
#import "THNSelectButtonView.h"
#import "THNSelectProducCollectionView.h"
#import "THNAPI.h"
#import "THNSelectPruductCoverCollectionViewCell.h"
#import "UIViewController+THNHud.h"
#import "SVProgressHUD+Helper.h"
#import "UIImageView+WebImage.h"
#import "THNTableViewFooterView.h"
#import "UIView+Helper.h"

typedef NS_ENUM(NSUInteger, SelectProductType) {
    SelectProductLike,
    SelectProductTypeWish,
    SelectProductTypeRecentlyViewed
};

static NSString *const kUrlUserLikeProduct = @"/userlike";
// 心愿单
static NSString *const kUrlWishlist = @"/wishlist";
// 最近查看
static NSString *const kUrlRecentlyViewedProduct = @"/user_browses";
static NSString *const kUrlProductImages = @"/products/images";
static NSString *const kProductCoverCellIdentifier = @"kProductCoverCellIdentifier";

@interface THNSelectWindowProductViewController ()<
THNSelectButtonViewDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
THNMJRefreshDelegate
>

@property (nonatomic, strong) THNSelectButtonView *selectButtonView;
@property (nonatomic, strong) THNSelectProducCollectionView *productCollectionView;
@property (nonatomic, strong) UICollectionView *productCoverCollectionView;
@property (nonatomic, strong) UIView *selectProductCoverView;
@property (nonatomic, strong) NSArray *productCovers;
@property (nonatomic, strong) NSMutableArray *likeProducts;
@property (nonatomic, strong) NSMutableArray *wishProducts;
@property (nonatomic, strong) NSMutableArray *recentlyViewedProducts;
@property (nonatomic, assign) SelectProductType selectProductType;
/// 当前页码
@property (nonatomic, assign) NSInteger currentPage;
// 之前记录的页码
@property (nonatomic, assign) NSInteger lastPage;
// 之前选择的Cell
@property (nonatomic, strong) NSIndexPath *selectIndex;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) NSString *selectCover;
@property (nonatomic, assign) NSInteger coverID;
@property (nonatomic, strong) NSString *productRid;
@property (nonatomic, strong) NSString *storeRid;
@property (nonatomic, strong) THNTableViewFooterView *footerView;

@end

@implementation THNSelectWindowProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectProductType = SelectProductLike;
    [self setupUI];
    [self loadData];
}

- (void)setupUI {
    self.navigationBarView.title = @"选择商品";
    [self.view addSubview:self.selectButtonView];
    
    WEAKSELF;
    self.productCollectionView.selectProductBlcok = ^(NSString *rid, NSString *storeRid) {
        [weakSelf loadProductCover:rid];
        weakSelf.storeRid = storeRid;
    };
    
    [self.view addSubview:self.productCollectionView];
    [self.view addSubview:self.selectProductCoverView];
    [self.view addSubview:self.productCoverCollectionView];
    [self.productCollectionView setRefreshFooterWithClass:nil automaticallyRefresh:YES delegate:self];
    [self.productCollectionView resetCurrentPageNumber];
    self.currentPage = 1;
}

- (void)loadData {
    [self loadUserLikeProductData];
}

- (void)loadUserLikeProductData {
    self.loadViewY = CGRectGetMaxY(self.selectButtonView.frame);
    if (self.currentPage == 1) {
        [SVProgressHUD thn_show];
    }
    
    NSString *requestUrl;
    switch (self.selectProductType) {
        case SelectProductLike:
            requestUrl = kUrlUserLikeProduct;
            break;
        case SelectProductTypeWish:
            requestUrl = kUrlWishlist;
            break;
        case SelectProductTypeRecentlyViewed:
            requestUrl = kUrlRecentlyViewedProduct;
            break;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(self.currentPage);
    THNRequest *request = [THNAPI getWithUrlString:requestUrl requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [SVProgressHUD dismiss];
        if (!result.success) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return;
        }

        [self.productCollectionView endFooterRefreshAndCurrentPageChange:YES];
        
        NSArray *products = result.data[@"products"];
        
        switch (self.selectProductType) {
            case SelectProductLike:
                [self.likeProducts addObjectsFromArray:products];
                [self.productCollectionView setProducts:self.likeProducts];
                break;
            case SelectProductTypeWish:
                [self.wishProducts addObjectsFromArray:products];
                [self.productCollectionView setProducts:self.wishProducts];
                break;
            case SelectProductTypeRecentlyViewed:
                [self.recentlyViewedProducts addObjectsFromArray:products];
                [self.productCollectionView setProducts:self.recentlyViewedProducts];
                break;
        }

        if (self.productCollectionView.products.count == 0) {
            self.footerView.hidden = NO;
            switch (self.selectProductType) {
                case SelectProductLike:
                    [self.footerView setHintLabelText:@"你当前还没有喜欢的商品" iconImageName:@"icon_liked_default"];
                    break;
                case SelectProductTypeWish:
                    [self.footerView setHintLabelText:@"你当前还没有心愿单商品" iconImageName:@"icon_collect_default"];
                    break;
                case SelectProductTypeRecentlyViewed:
                    [self.footerView setHintLabelText:@"你当前还没有查看的商品" iconImageName:@"icon_liked_default"];
                    break;
        }

            [self.view addSubview:self.footerView];
            return;
        } else {
            self.footerView.hidden = YES;
        }
        
        if (![result.data[@"next"] boolValue] && self.productCollectionView.products.count != 0) {
            [self.productCollectionView noMoreData];
        }
        
        [self.productCollectionView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)loadProductCover:(NSString *)rid {
    self.productRid = rid;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = rid;
    THNRequest *request = [THNAPI getWithUrlString:kUrlProductImages requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
            [SVProgressHUD showWithStatus:result.statusMessage];
            return;
        }
        
        self.productCovers = result.data[@"images"];
        [self.productCoverCollectionView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

- (void)selectPhotoFinish {
    if (self.selectWindowBlock) {
        int i = 0;
        for (NSString *storeRid in self.storeRids) {
            if ([self.storeRid isEqualToString:storeRid]) {
                i++;
            }
        }

        if (i == 2) {
            [SVProgressHUD setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
            [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
            [SVProgressHUD setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:12]];
            [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"一个橱窗最多可添加同一个设计馆2件商品"];
            [SVProgressHUD dismissWithDelay:2.0 completion:^{
                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
            }];

            return;
        }

        self.selectWindowBlock(self.selectCover, self.coverID, self.productRid, self.storeRid);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.productCovers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNSelectPruductCoverCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kProductCoverCellIdentifier forIndexPath:indexPath];
    cell.selectButton.selected = NO;
    NSString *imageCell = self.productCovers[indexPath.row][@"view_url"];
    [cell.photoImageView loadImageWithUrl:[imageCell loadImageUrlWithType:(THNLoadImageUrlTypeGoodsList)]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 设置选中状态
    THNSelectPruductCoverCollectionViewCell *selectCell = (THNSelectPruductCoverCollectionViewCell *)[collectionView cellForItemAtIndexPath:self.selectIndex];
    selectCell.selectButton.selected = NO;
    THNSelectPruductCoverCollectionViewCell *cell = (THNSelectPruductCoverCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    self.selectIndex = indexPath;
    cell.selectButton.selected = YES;
    self.sureButton.backgroundColor = [UIColor colorWithHexString:@"#5FE4B1"];
    self.sureButton.enabled = YES;
    [self.sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.selectCover = self.productCovers[indexPath.row][@"view_url"];
    self.coverID = [self.productCovers[indexPath.row][@"id"] integerValue];
}

#pragma mark - THNMJRefreshDelegate
- (void)beginLoadingMoreDataWithCurrentPage:(NSNumber *)currentPage {
    
    // 切换页面拿到的数据一直加载第二页数据的问题
    if (self.currentPage == 1 && self.lastPage != 0) {
        self.currentPage = self.lastPage + 1;
    } else {
        self.currentPage = currentPage.integerValue;
    }
    
    [self loadUserLikeProductData];
}

#pragma mark - THNSelectButtonViewDelegate Method 实现
- (void)selectButtonsDidClickedAtIndex:(NSInteger)index {
    
    self.selectProductType = index;
    
    switch (self.selectProductType) {
        case SelectProductLike:
            [self.productCollectionView setProducts:self.likeProducts];
            break;
        case SelectProductTypeWish:
            [self.productCollectionView setProducts:self.wishProducts];
            break;
        case SelectProductTypeRecentlyViewed:
            [self.productCollectionView setProducts:self.recentlyViewedProducts];
            break;
    }
    
    if (self.productCollectionView.products.count == 0) {
        self.lastPage = self.currentPage;
        self.currentPage = 1;
        [self.productCollectionView resetCurrentPageNumber];
        [self loadUserLikeProductData];
    } else {
        // 解决其他列表成为NoMoreData的状态时,该列表也不可下拉的问题
        [self.productCollectionView resetNoMoreData];
        // 隐藏缺省图
        self.footerView.hidden = YES;
        [self.productCollectionView reloadData];
        // 回滚到顶部
        [self.productCollectionView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
}

#pragma mark - lazy
- (THNSelectButtonView *)selectButtonView {
    if (!_selectButtonView) {
        NSArray *titleArray = @[@"喜欢", @"心愿单", @"最近查看"];
        _selectButtonView = [[THNSelectButtonView alloc]initWithFrame:CGRectMake(5, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, 60) titles:titleArray initWithButtonType:ButtonTypeDefault];
        _selectButtonView.delegate = self;
    }
    return _selectButtonView;
}

- (THNSelectProducCollectionView *)productCollectionView {
    if (!_productCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat width = (SCREEN_WIDTH - 4) / 3;
        flowLayout.itemSize = CGSizeMake(width, width);
        flowLayout.minimumInteritemSpacing = 2;
        flowLayout.minimumLineSpacing = 2;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGFloat productCollectionViewY = CGRectGetMaxY(self.selectButtonView.frame) + 10;
        _productCollectionView = [[THNSelectProducCollectionView alloc]initWithFrame:CGRectMake(0, productCollectionViewY, SCREEN_WIDTH, SCREEN_HEIGHT - productCollectionViewY - 156) collectionViewLayout:flowLayout];
    }
    return _productCollectionView;
}

- (THNTableViewFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[THNTableViewFooterView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.selectButtonView.frame), SCREEN_WIDTH, _productCollectionView.viewHeight)];
        _footerView.backgroundColor = [UIColor colorWithHexString:@"F5F7F9"];
    }
    return _footerView;
}

- (UIView *)selectProductCoverView {
    if (!_selectProductCoverView) {
        _selectProductCoverView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 156, SCREEN_WIDTH, 46)];
        UILabel *desLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 180, 14)];
        desLabel.text = @"选择该商品一张图片做封面";
        desLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        desLabel.textColor = [UIColor colorWithHexString:@"333333"];
        [_selectProductCoverView addSubview:desLabel];
        UIButton *sureButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 110, 8, 90, 30)];
        [sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [sureButton setTitleColor:[UIColor colorWithHexString:@"949EA6"] forState:UIControlStateNormal];
        sureButton.backgroundColor = [UIColor colorWithHexString:@"EFF3F2"];
        sureButton.layer.cornerRadius = 15;
        sureButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [sureButton addTarget:self action:@selector(selectPhotoFinish) forControlEvents:UIControlEventTouchUpInside];
        _sureButton = sureButton;
        _sureButton.enabled = NO;
        [_selectProductCoverView addSubview:sureButton];
    }
    return _selectProductCoverView;
}

- (UICollectionView *)productCoverCollectionView {
    if (!_productCoverCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(100, 100);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
        _productCoverCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.selectProductCoverView.frame), SCREEN_WIDTH, 100) collectionViewLayout:flowLayout];
        [_productCoverCollectionView registerNib:[UINib nibWithNibName:@"THNSelectPruductCoverCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kProductCoverCellIdentifier];
        _productCoverCollectionView.delegate = self;
        _productCoverCollectionView.dataSource = self;
        _productCoverCollectionView.backgroundColor = [UIColor whiteColor];
        _productCoverCollectionView.showsHorizontalScrollIndicator = NO;
    }
    return _productCoverCollectionView;
}

- (NSMutableArray *)likeProducts {
    if (!_likeProducts) {
        _likeProducts = [NSMutableArray array];
    }
    return _likeProducts;
}

- (NSMutableArray *)wishProducts {
    if (!_wishProducts) {
        _wishProducts = [NSMutableArray array];
    }
    return _wishProducts;
}

- (NSMutableArray *)recentlyViewedProducts {
    if (!_recentlyViewedProducts) {
        _recentlyViewedProducts = [NSMutableArray array];
    }
    return _recentlyViewedProducts;
}


@end
