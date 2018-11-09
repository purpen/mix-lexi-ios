//
//  THNSetDetailViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/9/4.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSetDetailViewController.h"
#import "THNProductCollectionViewCell.h"
#import "THNProductModel.h"
#import "THNAPI.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+THNHud.h"
#import "THNGoodsInfoViewController.h"

static NSString *const kSetDetailProductCellIdentifier = @"kSetDetailProductCellIdentifier";
static NSString *const kSetDetailHeaderViewIdentifier = @"kSetDetailHeaderViewIdentifier";
static NSString *const kUrlCollectionsDetail = @"/column/collections/detail";

@interface THNSetDetailViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, THNNavigationBarViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *setTitle;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *productCountLabel;

@end

@implementation THNSetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadCollectionsDetailData];
}

- (void)setupUI {
    self.navigationBarView.delegate = self;
    [self.navigationBarView setNavigationRightButtonOfImageNamed:@"icon_share_gray"];
    self.navigationBarView.title = @"集合详情";
    [self.view addSubview:self.collectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"THNProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kSetDetailProductCellIdentifier];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSetDetailHeaderViewIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

- (void)loadCollectionsDetailData {
    [self showHud];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = @(self.collectionID);
    THNRequest *request = [THNAPI getWithUrlString:kUrlCollectionsDetail requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [self hiddenHud];
        self.products = result.data[@"products"];
        self.cover = result.data[@"cover"];
        self.setTitle = result.data[@"name"];
        [self.collectionView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        [self hiddenHud];
    }];
}

#pragma mark - UICollectionViewDataSourse
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.products.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSetDetailProductCellIdentifier forIndexPath:indexPath];
    THNProductModel *productModel = [THNProductModel mj_objectWithKeyValues:self.products[indexPath.row]];
    [cell setProductModel:productModel initWithType:THNHomeTypeFeatured];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSetDetailHeaderViewIdentifier forIndexPath:indexPath];
   
    self.titleLabel.text = self.setTitle;
    self.productCountLabel.text = [NSString stringWithFormat:@"%ld件商品",self.products.count];
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:self.cover] placeholderImage:[UIImage imageNamed:@"default_image_place"]];
    [headerView addSubview:self.coverImageView];
    [headerView addSubview:self.titleLabel];
    [headerView addSubview:self.productCountLabel];
    return headerView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWidth = (indexPath.row + 1) % 5 ? (SCREEN_WIDTH - 50) / 2 : SCREEN_WIDTH - 40;
    
    return CGSizeMake(itemWidth, itemWidth + 50);
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize size = CGSizeMake(SCREEN_WIDTH, 200);
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    THNProductModel *productModel = [THNProductModel mj_objectWithKeyValues:self.products[indexPath.row]];
    THNGoodsInfoViewController *goodInfo = [[THNGoodsInfoViewController alloc]initWithGoodsId:productModel.rid];
    [self.navigationController pushViewController:goodInfo animated:YES];
}

#pragma mark - lazy
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 20;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10, 20, 0, 20);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 70, 0);
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    }
    return _coverImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 135, SCREEN_WIDTH - 40, 24)];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:24];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}
- (UILabel *)productCountLabel {
    if (!_productCountLabel) {
        _productCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 170, SCREEN_WIDTH - 40, 12)];
        _productCountLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _productCountLabel.textColor = [UIColor whiteColor];
    }
    return _productCountLabel;
}

@end
