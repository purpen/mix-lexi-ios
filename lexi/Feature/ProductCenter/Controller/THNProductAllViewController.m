//
//  THNProductAllViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/8/27.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNProductAllViewController.h"
#import "THNSelectButtonView.h"
#import "THNMarco.h"
#import "THNAPI.h"
#import "THNProductCollectionViewCell.h"
#import "THNProductModel.h"
#import "UIView+Helper.h"
#import "THNShelfViewController.h"
#import "THNFunctionPopupView.h"
#import "THNFunctionButtonView.h"
#import "UIViewController+THNHud.h"
#import "THNLoginManager.h"
#import "THNGoodsInfoViewController.h"
#import "SVProgressHUD+Helper.h"

static NSString *const KUrlDistributeCenterAll = @"/fx_distribute/choose_center";
static NSString *const kProductCenterCellIdentifier = @"kProductCenterCellIdentifier";
static CGFloat collectionViewX = 20;
static CGFloat interitemSpacing = 10;

@interface THNProductAllViewController ()<THNFunctionButtonViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, THNFunctionPopupViewDelegate, THNMJRefreshDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
// 设置商品的弹窗
@property (nonatomic, strong) THNFunctionPopupView *popupView;
// 设置商品的buttonView
@property (nonatomic, strong) THNFunctionButtonView *functionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
// 商品筛选的参数
@property (nonatomic, strong) NSDictionary *producrConditionParams;
@property(nonatomic, assign) NSInteger currentPage;

@end

@implementation THNProductAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:kShelfSuccess object:nil];
    [self loadProdctCenterAllData];
    [self setupUI];
}

- (void)setupUI {
    [self.collectionView registerNib:[UINib nibWithNibName:@"THNProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kProductCenterCellIdentifier];
    [self.view addSubview:self.functionView];
    [self.functionView thn_createFunctionButtonWithType:THNGoodsListViewTypeProductCenter];
    [[UIApplication sharedApplication].windows.firstObject addSubview:self.popupView];
    UIView *lineView = [UIView initLineView:CGRectMake(0, CGRectGetMaxY(self.functionView.frame), SCREEN_WIDTH, 0.5)];
    [self.view addSubview:lineView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView setRefreshFooterWithClass:nil automaticallyRefresh:YES delegate:self];
    [self.collectionView resetCurrentPageNumber];
    self.currentPage = 1;
}

- (void)refreshData {
    [self.dataArray removeAllObjects];
    [self.collectionView resetCurrentPageNumber];
    self.currentPage = 1;
    [self loadProdctCenterAllData];
}

- (void)loadProdctCenterAllData {
    
    if (self.currentPage == 1) {
        [SVProgressHUD thn_show];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(self.currentPage);
    params[@"sid"] = [THNLoginManager sharedManager].storeRid;
    [params setValuesForKeysWithDictionary:self.producrConditionParams];
    THNRequest *request = [THNAPI getWithUrlString:KUrlDistributeCenterAll requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [SVProgressHUD dismiss];
        if (!result.success) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return;
        }
        [self.dataArray addObjectsFromArray:result.data[@"products"]];
        [self.collectionView endFooterRefreshAndCurrentPageChange:YES];
        [self.popupView thn_setDoneButtonTitleWithGoodsCount:[result.data[@"count"] integerValue] show:YES];
        [self.collectionView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - THNFunctionButtonViewDelegate  Method 实现
- (void)thn_functionViewSelectedWithIndex:(NSInteger)index {
    switch (index) {
        case 0: {
            [self.popupView thn_showFunctionViewWithType:THNFunctionPopupViewTypeSort];
        }
            break;
            
        case 1: {
            [self.popupView thn_showFunctionViewWithType:THNFunctionPopupViewTypeProfitSort];
        }
            break;
            
        case 2: {
            [self.popupView thn_showFunctionViewWithType:THNFunctionPopupViewTypeScreen];
        }
            break;
    }
}

#pragma mark - THNFunctionPopupViewDelegate
- (void)thn_functionPopupViewClose {
    [self.functionView thn_setFunctionButtonSelected:NO];
}

- (void)thn_functionPopupViewScreenParams:(NSDictionary *)screenParams count:(NSInteger)count {
    [self.functionView thn_setFunctionButtonSelected:NO];
    NSMutableString *screenStr = [NSMutableString stringWithFormat:@"筛选"];
    [screenStr appendString:count > 0 ? [NSString stringWithFormat:@" %zi", count] : @""];
    [self.functionView thn_setSelectedButtonTitle:screenStr];
    self.producrConditionParams = screenParams;
    [self refreshData];
}

- (void)thn_functionPopupViewType:(THNFunctionPopupViewType)viewType sortType:(NSInteger)type title:(NSString *)title {
    [self.functionView thn_setFunctionButtonSelected:NO];
    [self.functionView thn_setSelectedButtonTitle:title];
    
    if (viewType == THNFunctionPopupViewTypeSort) {
        self.producrConditionParams = @{@"sort_type": @(type)};
    } else if (viewType == THNFunctionPopupViewTypeProfitSort) {
        if (type != 0) {
            type -= 1;
        }
        self.producrConditionParams = @{@"profit_type" : @(type )};
    }
    
    [self loadProdctCenterAllData];
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kProductCenterCellIdentifier forIndexPath:indexPath];
    
    cell.shelfBlock = ^(THNProductCollectionViewCell *cell) {
        THNProductModel *productModel = [THNProductModel mj_objectWithKeyValues:self.dataArray[indexPath.row]];
        THNShelfViewController *shelf = [[THNShelfViewController alloc]init];
        shelf.productModel = productModel;
        [self.navigationController pushViewController:shelf animated:YES];
    };
    
    THNProductModel *productModel = [THNProductModel mj_objectWithKeyValues:self.dataArray[indexPath.row]];
    [cell setProductModel:productModel initWithType:THNHomeTypeCenter];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    THNProductModel *productModel = [THNProductModel mj_objectWithKeyValues:self.dataArray[indexPath.row]];
    THNGoodsInfoViewController *goodInfo = [[THNGoodsInfoViewController alloc]initWithGoodsId:productModel.rid];
    [self.navigationController pushViewController:goodInfo animated:YES];
}

#pragma mark - THNMJRefreshDelegate
-(void)beginLoadingMoreDataWithCurrentPage:(NSNumber *)currentPage {
    self.currentPage = currentPage.integerValue;
    [self loadProdctCenterAllData];
}


#pragma mark - lazy
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
        layout.itemSize = CGSizeMake((SCREEN_WIDTH - interitemSpacing - collectionViewX * 2) / 2, 250);
        layout.minimumInteritemSpacing = interitemSpacing;
        layout.minimumLineSpacing = 20;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.functionView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.functionView.frame)) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 220, 0);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (THNFunctionPopupView *)popupView {
    if (!_popupView) {
        _popupView = [[THNFunctionPopupView alloc] init];
        [_popupView thn_setViewStyleWithGoodsListType:THNGoodsListViewTypeProductCenter];
        [_popupView thn_setCategoryId:0];
        _popupView.delegate = self;
    }
    return _popupView;
}

- (THNFunctionButtonView *)functionView {
    if (!_functionView) {
        _functionView = [[THNFunctionButtonView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _functionView.delegate = self;
    }
    return _functionView;
}

- (NSDictionary *)producrConditionParams {
    if (!_producrConditionParams) {
        _producrConditionParams = [NSDictionary dictionary];
    }
    return _producrConditionParams;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
