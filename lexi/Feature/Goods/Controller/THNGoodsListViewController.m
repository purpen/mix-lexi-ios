//
//  THNGoodsListViewController.m
//  lexi
//
//  Created by FLYang on 2018/8/27.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsListViewController.h"
#import "THNLikedGoodsCollectionViewCell.h"
#import "THNFunctionButtonView.h"
#import "THNFunctionPopupView.h"

static NSString *const kCollectionViewCellId = @"THNLikedGoodsCollectionViewCellId";

@interface THNGoodsListViewController () <
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    THNFunctionButtonViewDelegate
>

/// 商品列表
@property (nonatomic, strong) UICollectionView *goodsCollectionView;
/// 商品数据
@property (nonatomic, strong) NSMutableArray *modelArray;
/// 功能按钮
@property (nonatomic, strong) THNFunctionButtonView *functionView;
/// 功能视图
@property (nonatomic, strong) THNFunctionPopupView *popupView;
/// 获取商品的类型
@property (nonatomic, assign) THNProductsType productsType;
/// 创建商品视图类型
@property (nonatomic, assign) THNGoodsListViewType goodsListType;
/// 分类的 id
@property (nonatomic, assign) NSInteger categoryId;

@end

@implementation THNGoodsListViewController

- (instancetype)initWithGoodsListType:(THNGoodsListViewType)type title:(NSString *)title {
    self = [super init];
    if (self) {
        self.navigationBarView.title = title;
        self.goodsListType = type;
    }
    return self;
}

- (instancetype)initWithCategoryId:(NSInteger)categoryId categoryName:(NSString *)name {
    self = [super init];
    if (self) {
        self.navigationBarView.title = name;
        self.goodsListType = THNGoodsListViewTypeCategory;
        self.categoryId = categoryId;
    }
    return self;
}

- (instancetype)initWithUserCenterGoodsType:(THNProductsType)type title:(NSString *)title {
    self = [super init];
    if (self) {
        self.navigationBarView.title = title;
        self.goodsListType = THNGoodsListViewTypeUserCenter;
        self.productsType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self thn_requestProductsDataWithType:self.goodsListType];
    [self setupUI];
}

#pragma mark - network
- (void)thn_requestProductsDataWithType:(THNGoodsListViewType)type {
    switch (type) {
        case THNGoodsListViewTypeUserCenter: {
            [self thn_getUserCenterProductsWithType:self.productsType];
            self.popupView.productsType = self.productsType;
            [self.functionView thn_createFunctionButtonWithType:(THNFunctionButtonViewTypeUserGoods)];
        }
            break;
            
        case THNGoodsListViewTypeCategory: {
            [self thn_getCategoryProductsWithId:self.categoryId];
            [self.popupView thn_setCategoryId:self.categoryId];
            [self.functionView thn_createFunctionButtonWithType:(THNFunctionButtonViewTypeDefault)];
        }
            
        default:
            break;
    }
}

// 获取个人中心商品数据
- (void)thn_getUserCenterProductsWithType:(THNProductsType)type {
    [THNGoodsManager getUserCenterProductsWithType:type params:@{} completion:^(NSArray *goodsData, NSInteger count, NSError *error) {
        if (error || !goodsData.count) return;
        
        [self.popupView thn_setDoneButtonTitleWithGoodsCount:count show:YES];
        
        for (NSDictionary *product in goodsData) {
            THNProductModel *model = [THNProductModel mj_objectWithKeyValues:product];
            [self.modelArray addObject:model];
        }

        [self.goodsCollectionView reloadData];
    }];
}

// 获取分类商品数据
- (void)thn_getCategoryProductsWithId:(NSInteger)categoryId {
    [THNGoodsManager getCategoryProductsWithId:categoryId params:@{} completion:^(NSArray *goodsData, NSInteger count, NSError *error) {
        if (error || !goodsData.count) return;
        
        [self.popupView thn_setDoneButtonTitleWithGoodsCount:count show:YES];
        
        for (NSDictionary *product in goodsData) {
            THNProductModel *model = [THNProductModel mj_objectWithKeyValues:product];
            [self.modelArray addObject:model];
        }
        
        [self.goodsCollectionView reloadData];
    }];
}

#pragma mark - custom delegate
- (void)thn_functionViewSelectedWithIndex:(NSInteger)index {
    if (self.goodsListType == THNGoodsListViewTypeCategory && index == 1) {
        [SVProgressHUD showInfoWithStatus:@"新品"];
        return;
    }
    
    [self.popupView thn_showFunctionViewWithType:(THNFunctionPopupViewType)index];
}

#pragma mark - collectionView delegate & dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNLikedGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellId
                                                                                      forIndexPath:indexPath];
    
    if (self.modelArray.count) {
        [cell thn_setGoodsModel:self.modelArray[indexPath.row] showInfoView:YES];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    THNProductModel *model = self.modelArray[indexPath.row];
    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"打开商品 == %@", model.rid]];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    CGFloat itemWidth = (indexPath.row + 1) % 5 ? (SCREEN_WIDTH - 50) / 2 : SCREEN_WIDTH - 40;
    CGFloat itemWidth = (SCREEN_WIDTH - 50) / 2;
    return CGSizeMake(itemWidth, itemWidth + 50);
}

#pragma mark - setup UI
- (void)setupUI {
    [self.view addSubview:self.goodsCollectionView];
    [self.view addSubview:self.functionView];
    
    [[UIApplication sharedApplication].windows.firstObject addSubview:self.popupView];
}

#pragma mark - getters and setters
- (UICollectionView *)goodsCollectionView {
    if (!_goodsCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _goodsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
        _goodsCollectionView.backgroundColor = [UIColor whiteColor];
        _goodsCollectionView.contentInset = UIEdgeInsetsMake(94, 20, 20, 20);
        _goodsCollectionView.delegate = self;
        _goodsCollectionView.dataSource = self;
        _goodsCollectionView.showsVerticalScrollIndicator = NO;
        [_goodsCollectionView registerClass:[THNLikedGoodsCollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCellId];
    }
    return _goodsCollectionView;
}

- (NSMutableArray *)modelArray {
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

- (THNFunctionButtonView *)functionView {
    if (!_functionView) {
        _functionView = [[THNFunctionButtonView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, 40)];
        _functionView.delegate = self;
    }
    return _functionView;
}

- (THNFunctionPopupView *)popupView {
    if (!_popupView) {
        _popupView = [[THNFunctionPopupView alloc] init];
        [_popupView thn_setLocalControllerType:self.goodsListType == THNGoodsListViewTypeUserCenter ? \
              THNLocalControllerTypeUserGoods : THNLocalControllerTypeDefault];
    }
    return _popupView;
}

@end
