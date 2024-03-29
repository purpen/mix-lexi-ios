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
#import "UIImageView+WebImage.h"
#import "UIViewController+THNHud.h"
#import "THNGoodsInfoViewController.h"
#import "THNShareViewController.h"

static NSString *const kSetDetailProductCellIdentifier = @"kSetDetailProductCellIdentifier";
static NSString *const kSetDetailHeaderViewIdentifier = @"kSetDetailHeaderViewIdentifier";
static NSString *const kUrlCollectionsDetail = @"/column/collections/detail";

@interface THNSetDetailViewController () <
UICollectionViewDataSource,
UICollectionViewDelegate,
THNNavigationBarViewDelegate,
THNMJRefreshDelegate
>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *products;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *setTitle;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *productCountLabel;
@property(nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UIImageView *maskImageView;

@end

@implementation THNSetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadCollectionsDetailData];
}

- (void)setupUI {
    self.navigationBarView.delegate = self;
    [self.navigationBarView setNavigationRightButtonOfImageNamed:@"icon_share"];
    self.navigationBarView.title = @"集合";
    
    WEAKSELF;
    [self.navigationBarView didNavigationRightButtonCompletion:^{
        THNShareViewController *shareVC = [[THNShareViewController alloc] initWithType:(THNSharePosterTypeBrandStore)];
        [shareVC shareObjectWithTitle:weakSelf.setTitle
                                descr:weakSelf.subTitle
                            thumImage:weakSelf.cover
                               webUrl:[kShareCollectionPrefix stringByAppendingString:[NSString stringWithFormat:@"%ld",weakSelf.collectionID]]];
        shareVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [weakSelf presentViewController:shareVC animated:NO completion:nil];
    }];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"THNProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kSetDetailProductCellIdentifier];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSetDetailHeaderViewIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView setRefreshFooterWithClass:nil automaticallyRefresh:YES delegate:self];
    [self.collectionView resetCurrentPageNumber];
    self.currentPage = 1;
}

- (void)loadCollectionsDetailData {
    if (self.currentPage == 1) {
        [self showHud];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = @(self.collectionID);
    params[@"page"] = @(self.currentPage);
    THNRequest *request = [THNAPI getWithUrlString:kUrlCollectionsDetail requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [self hiddenHud];
        if (!result.success) {
            [SVProgressHUD showWithStatus:result.statusMessage];
            return;
        }

        [self.collectionView endFooterRefreshAndCurrentPageChange:YES];
        NSArray *products = result.data[@"products"];
        [self.products addObjectsFromArray:products];
       
        if (![result.data[@"next"] boolValue] && self.products.count != 0) {
            
            [self.collectionView noMoreData];
        }
        
        self.cover = result.data[@"cover"];
        self.title = result.data[@"name"];
        self.subTitle = result.data[@"sub_name"];
        self.setTitle = [NSString stringWithFormat:@"%@-%@", self.title, self.subTitle];
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
    [self.coverImageView loadImageWithUrl:[self.cover loadImageUrlWithType:(THNLoadImageUrlTypeBannerDefault)]];
    [headerView addSubview:self.coverImageView];
    [headerView addSubview:self.maskImageView];
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

#pragma mark - THNMJRefreshDelegate
-(void)beginLoadingMoreDataWithCurrentPage:(NSNumber *)currentPage {
    self.currentPage = currentPage.integerValue;
    [self loadCollectionsDetailData];
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
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.layer.masksToBounds = YES;
    }
    return _coverImageView;
}

- (UIImageView *)maskImageView {
    if (!_maskImageView) {
        _maskImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 130, SCREEN_WIDTH, 70)];
        _maskImageView.image = [UIImage imageNamed:@"icon_setDetail_mask"];
    }
    return _maskImageView;
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

- (NSMutableArray *)products {
    if (!_products) {
        _products = [NSMutableArray array];
    }
    return _products;
}

@end
