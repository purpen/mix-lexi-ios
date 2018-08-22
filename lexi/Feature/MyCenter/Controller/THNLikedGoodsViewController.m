//
//  THNLikedGoodsViewController.m
//  lexi
//
//  Created by FLYang on 2018/8/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLikedGoodsViewController.h"
#import "THNLikedGoodsCollectionViewCell.h"
#import "THNFunctionButtonView.h"
#import "THNFunctionPopupView.h"

static NSString *const kCollectionViewCellId = @"THNLikedGoodsCollectionViewCellId";

@interface THNLikedGoodsViewController () <
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    THNFunctionButtonViewDelegate
>

/// 喜欢的商品列表
@property (nonatomic, strong) UICollectionView *goodsCollectionView;
/// 商品数据
@property (nonatomic, strong) NSMutableArray *modelArray;
/// 功能按钮
@property (nonatomic, strong) THNFunctionButtonView *functionView;
/// 功能视图
@property (nonatomic, strong) THNFunctionPopupView *popupView;
/// 显示的商品类型
@property (nonatomic, assign) THNProductsType productsType;

@end

@implementation THNLikedGoodsViewController

- (instancetype)initWithShowProductsType:(THNProductsType)type {
    self = [super init];
    if (self) {
        self.productsType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self thn_getProductsWithType:self.productsType ? self.productsType : THNProductsTypeLikedGoods];
}

// 获取商品数据
- (void)thn_getProductsWithType:(THNProductsType)type {
    [THNUserManager getProductsWithType:type params:@{} completion:^(NSArray *goodsData, NSError *error) {
        if (error || !goodsData.count) return;
        
        for (NSDictionary *product in goodsData) {
            THNProductModel *model = [THNProductModel mj_objectWithKeyValues:product];
            [self.modelArray addObject:model];
        }
        
        [self.goodsCollectionView reloadData];
    }];
}

#pragma mark - custom delegate
- (void)thn_functionButtonSelectedWithIndex:(NSInteger)index {
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
    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"打开商品 == %zi", indexPath.row]];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat itemWidth = (indexPath.row + 1) % 5 ? (SCREEN_WIDTH - 50) / 2 : SCREEN_WIDTH - 40;
    
    return CGSizeMake(itemWidth, itemWidth + 50);
}

#pragma mark - setup UI
- (void)setupUI {
    [self.view addSubview:self.goodsCollectionView];
    [self.view addSubview:self.functionView];
    
    [[UIApplication sharedApplication].windows.firstObject addSubview:self.popupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.title = self.title;
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
        _functionView = [[THNFunctionButtonView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, 40)
                                                        buttonTitles:@[@"筛选", @"排序"]];
        _functionView.delegate = self;
    }
    return _functionView;
}

- (THNFunctionPopupView *)popupView {
    if (!_popupView) {
        _popupView = [THNFunctionPopupView initWithFunctionType:(THNFunctionPopupViewTypeSort)];
    }
    return _popupView;
}


@end
