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

/// 橱窗列表
@property (nonatomic, strong) UICollectionView *goodsCollectionView;
/// 橱窗数据
@property (nonatomic, strong) NSMutableArray *goodsArray;
/// 功能按钮
@property (nonatomic, strong) THNFunctionButtonView *functionView;
/// 功能视图
@property (nonatomic, strong) THNFunctionPopupView *popupView;

@end

@implementation THNLikedGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - custom delegate
- (void)thn_functionButtonSelectedWithIndex:(NSInteger)index {
    [self.popupView thn_showFunctionViewWithType:(THNFunctionPopupViewType)index];
}

#pragma mark - collectionView delegate & dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //    return self.goodsArray.count;
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNLikedGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellId
                                                                                    forIndexPath:indexPath];
//    if (self.goodsArray.count) {
        [cell thn_setGoodsModel:[[THNProductModel alloc] init] showInfoView:YES];
//    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"打开橱窗 == %zi", indexPath.row]];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat itemWidth = (indexPath.row + 1) % 5 ? (SCREEN_WIDTH - 50) / 2 : SCREEN_WIDTH - 40;
    
    return CGSizeMake(itemWidth, itemWidth + 40);
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
    self.navigationBarView.title = kTitleLikedGoods;
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
        _goodsCollectionView.contentInset = UIEdgeInsetsMake(kDeviceiPhoneX ? 94 : 72, 20, 20, 20);
        _goodsCollectionView.delegate = self;
        _goodsCollectionView.dataSource = self;
        _goodsCollectionView.showsVerticalScrollIndicator = NO;
        [_goodsCollectionView registerClass:[THNLikedGoodsCollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCellId];
    }
    return _goodsCollectionView;
}

- (NSMutableArray *)goodsArray {
    if (!_goodsArray) {
        _goodsArray = [NSMutableArray array];
    }
    return _goodsArray;
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
