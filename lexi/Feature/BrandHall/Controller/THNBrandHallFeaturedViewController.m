//
//  THNBrandHallFeaturedViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/9/3.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBrandHallFeaturedViewController.h"
#import "THNAPI.h"
#import "THNBannerView.h"
#import "THNMarco.h"
#import "THNBrandHallFeaturedCollectionViewCell.h"
#import "UICollectionViewFlowLayout+THN_flowLayout.h"
#import "THNFeaturedBrandModel.h"
#import <MJExtension/MJExtension.h>
#import "THNGoodsInfoViewController.h"
#import "THNBrandHallViewController.h"
#import "THNArticleViewController.h"
#import "THNGoodsListViewController.h"
#import "UIViewController+THNHud.h"

static NSString *const kUrlBrandHallFeatured = @"/column/handpick_store";
static NSString *const kUrlBrandHallBannerStore = @"/banners/store_ad";
static NSString *const kBrandHallFeaturedCollectionCellIdentifier = @"kBrandHallFeaturedCollectionCellIdentifier";
static CGFloat const kBrandHallHeight = 375;

@interface THNBrandHallFeaturedViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, THNBannerViewDelegate>

@property (nonatomic, strong) THNBannerView *bannerView;
@property (nonatomic, strong) NSArray *handpickStores;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation THNBrandHallFeaturedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadBrandHallBannerData];
    [self loadBrandHallFeaturedData];
}

- (void)setupUI {
    [self.view addSubview:self.bannerView];
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

// 品牌馆列表
- (void)loadBrandHallFeaturedData {
    self.isTransparent = YES;
    [self showHud];
    THNRequest *request = [THNAPI getWithUrlString:kUrlBrandHallFeatured requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [self hiddenHud];
        if (!result.success) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return;
        }

        self.handpickStores = result.data[@"handpick_store"];
        [self.collectionView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        [self hiddenHud];
    }];
}

// banner
- (void)loadBrandHallBannerData {
    self.isTransparent = YES;
    [self showHud];
    THNRequest *request = [THNAPI getWithUrlString:kUrlBrandHallBannerStore requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [self hiddenHud];
        if (!result.success) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return;
        }
        
        self.bannerView.carouselBannerType = CarouselBannerTypeBrandHallFeatured;
        [self.bannerView setBannerView:result.data[@"banner_images"]];
    } failure:^(THNRequest *request, NSError *error) {
        [self hiddenHud];
    }];
}

#pragma mark UICollectionViewDelegate && UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.handpickStores.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNBrandHallFeaturedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBrandHallFeaturedCollectionCellIdentifier forIndexPath:indexPath];
    THNFeaturedBrandModel *brandModel = [THNFeaturedBrandModel mj_objectWithKeyValues:self.handpickStores[indexPath.row]];
    [cell setBrandModel:brandModel];
    return cell;
}



#pragma mark - THNBannerViewDelegate

- (void)bannerPushGoodInfo:(NSString *)rid {
    THNGoodsInfoViewController *goodInfo = [[THNGoodsInfoViewController alloc]initWithGoodsId:rid];
    [self.navigationController pushViewController:goodInfo animated:YES];
}

- (void)bannerPushBrandHall:(NSString *)rid {
    THNBrandHallViewController *brandHall = [[THNBrandHallViewController alloc]init];
    brandHall.rid = rid;
    [self.navigationController pushViewController:brandHall animated:YES];
}

- (void)bannerPushArticle:(NSInteger)rid {
    THNArticleViewController *articleVC = [[THNArticleViewController alloc]init];
    articleVC.rid = rid;
    [self.navigationController pushViewController:articleVC animated:YES];
}

- (void)bannerPushCategorie:(NSString *)name initWithCategoriesID:(NSInteger)categorieID {
    THNGoodsListViewController *goodsListVC = [[THNGoodsListViewController alloc] initWithCategoryId:categorieID categoryName:name];
    [self.navigationController pushViewController:goodsListVC animated:YES];
}

#pragma mark - lazy
- (THNBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[THNBannerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kBrandHallHeight)];
        _bannerView.delegate = self;
    }
    return _bannerView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]initWithLineSpacing:15 initWithWidth:73 initwithHeight:130];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.bannerView.frame) + 20, SCREEN_WIDTH - 20, 130) collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"THNBrandHallFeaturedCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kBrandHallFeaturedCollectionCellIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

@end
