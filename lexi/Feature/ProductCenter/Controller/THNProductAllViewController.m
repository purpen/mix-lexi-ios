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

static NSString *const KUrlDistributeCenterAll = @"/fx_distribute/choose_center";
static NSString *const kProductCenterCellIdentifier = @"kProductCenterCellIdentifier";
static CGFloat collectionViewX = 20;
static CGFloat interitemSpacing = 10;

@interface THNProductAllViewController ()<THNSelectButtonViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) THNSelectButtonView *selectButtonView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation THNProductAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadProdctCenterAllData];
    [self setupUI];
}

- (void)setupUI {
    [self.collectionView registerNib:[UINib nibWithNibName:@"THNProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kProductCenterCellIdentifier];
    [self.view addSubview:self.selectButtonView];
    UIView *lineView = [UIView initLineView:CGRectMake(0, CGRectGetMaxY(self.selectButtonView.frame), SCREEN_WIDTH, 0.5)];
    [self.view addSubview:lineView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
}

- (void)loadProdctCenterAllData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @1;
    params[@"per_page"] = @10;
    THNRequest *request = [THNAPI getWithUrlString:KUrlDistributeCenterAll requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.dataArray = result.data[@"products"];
        [self.collectionView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

#pragma mark - lazy
- (THNSelectButtonView *)selectButtonView {
    if (!_selectButtonView) {
        NSArray *titleArray = @[@"综合排序", @"利润的", @"筛选"];
        _selectButtonView = [[THNSelectButtonView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) titles:titleArray initWithButtonType:ButtonTypeTriangle];
        _selectButtonView.delegate = self;
    }
    return _selectButtonView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake((SCREEN_WIDTH - interitemSpacing - collectionViewX * 2) / 2, 250);
        layout.minimumInteritemSpacing = interitemSpacing;
        layout.minimumLineSpacing = 20;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.selectButtonView.frame) + 10, SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.selectButtonView.frame)) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 220, 0);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

#pragma mark - THNSelectButtonViewDelegate Method 实现
- (void)selectButtonsDidClickedAtIndex:(NSInteger)index {
  
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

@end
