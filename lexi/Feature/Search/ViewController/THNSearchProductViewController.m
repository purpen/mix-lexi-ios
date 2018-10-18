//
//  THNSearchProductViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/9/27.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSearchProductViewController.h"
#import "THNFunctionPopupView.h"
#import "THNFunctionButtonView.h"
#import "UIView+Helper.h"
#import "THNMarco.h"
#import "THNAPI.h"
#import "THNProductCollectionViewCell.h"
#import "THNProductModel.h"
#import "THNSaveTool.h"
#import "THNGoodsInfoViewController.h"

static CGFloat interitemSpacing = 10;
static NSString *const kSearchProductCellIdentifier = @"kSearchProductCellIdentifier";
static NSString *const kUrlSearchProduct = @"/core_platforms/search/products";

@interface THNSearchProductViewController ()<
THNFunctionButtonViewDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
THNFunctionPopupViewDelegate
>

@property (nonatomic, strong) UICollectionView *collectionView;
// 设置商品的弹窗
@property (nonatomic, strong) THNFunctionPopupView *popupView;
// 设置商品的buttonView
@property (nonatomic, strong) THNFunctionButtonView *functionView;
@property (nonatomic, strong) NSArray *dataArray;
// 商品筛选的参数
@property (nonatomic, strong) NSDictionary *producrConditionParams;

@end

@implementation THNSearchProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSearchProductData];
    [self setupUI];
}

- (void)setupUI {
    self.navigationBarView.hidden = YES;
    [self.collectionView registerNib:[UINib nibWithNibName:@"THNProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kSearchProductCellIdentifier];
    [self.view addSubview:self.functionView];
    [self.functionView thn_createFunctionButtonWithType:THNGoodsListViewTypeSearch];
    [[UIApplication sharedApplication].windows.firstObject addSubview:self.popupView];
    UIView *lineView = [UIView initLineView:CGRectMake(0, CGRectGetMaxY(self.functionView.frame), SCREEN_WIDTH, 0.5)];
    [self.view addSubview:lineView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
}

- (void)loadSearchProductData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @1;
    params[@"per_page"] = @10;
    params[@"qk"] = [THNSaveTool objectForKey:kSearchKeyword];
    [params setValuesForKeysWithDictionary:self.producrConditionParams];
    THNRequest *request = [THNAPI getWithUrlString:kUrlSearchProduct requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.dataArray = result.data[@"products"];
        [self.popupView thn_setDoneButtonTitleWithGoodsCount:[result.data[@"count"] integerValue] show:YES];
        [self.collectionView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        
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
    [self loadSearchProductData];
}

- (void)thn_functionPopupViewType:(THNFunctionPopupViewType)viewType sortType:(NSInteger)type title:(NSString *)title {
    [self.functionView thn_setFunctionButtonSelected:NO];
    [self.functionView thn_setSelectedButtonTitle:title];
    self.producrConditionParams = @{@"sort_type": @(type)};
    [self loadSearchProductData];
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSearchProductCellIdentifier forIndexPath:indexPath];
    THNProductModel *productModel = [THNProductModel mj_objectWithKeyValues:self.dataArray[indexPath.row]];
    [cell setProductModel:productModel initWithType:THNHomeTypeFeatured];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWidth = (indexPath.row + 1) % 5 ? (SCREEN_WIDTH - 50) / 2 : SCREEN_WIDTH - 40;
    return CGSizeMake(itemWidth, itemWidth + 50);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    THNProductModel *productModel = [THNProductModel mj_objectWithKeyValues:self.dataArray[indexPath.row]];
    THNGoodsInfoViewController *goodInfoVC = [[THNGoodsInfoViewController alloc]initWithGoodsId:productModel.rid];
    [self.navigationController pushViewController:goodInfoVC animated:YES];
}

#pragma mark - lazy
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumInteritemSpacing = interitemSpacing;
        layout.minimumLineSpacing = 20;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.functionView.frame) + 10, SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.functionView.frame)) collectionViewLayout:layout];
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
        [_popupView thn_setViewStyleWithGoodsListType:THNGoodsListViewTypeSearch];
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

@end
