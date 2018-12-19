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
#import "THNWebKitViewViewController.h"
#import "UIView+Helper.h"
#import "THNShopWindowDetailViewController.h"
#import "THNSetDetailViewController.h"

static NSString *const kUrlBrandHallFeatured = @"/column/handpick_store";
static NSString *const kUrlBrandHallBannerStore = @"/banners/store_ad";
static NSString *const kBrandHallFeaturedCollectionCellIdentifier = @"kBrandHallFeaturedCollectionCellIdentifier";

@interface THNBrandHallFeaturedViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, THNBannerViewDelegate>

@property (nonatomic, strong) THNBannerView *bannerView;
@property (nonatomic, strong) NSArray *handpickStores;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation THNBrandHallFeaturedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.bannerView removeTimer];
}

- (void)setupUI {
    [self.view addSubview:self.bannerView];
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

- (void)loadData {
    //创建信号量
    self.semaphore = dispatch_semaphore_create(0);
    //创建全局并行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    [self showHud];
    
    dispatch_group_async(group, queue, ^{
        [self showHud];
        [self loadBrandHallBannerData];
    });
    dispatch_group_async(group, queue, ^{
        [self loadBrandHallFeaturedData];
    });
    
    dispatch_group_notify(group, queue, ^{
        
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hiddenHud];
            [self.collectionView reloadData];
        });
    });
}

// 品牌馆列表
- (void)loadBrandHallFeaturedData {
    THNRequest *request = [THNAPI getWithUrlString:kUrlBrandHallFeatured requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        dispatch_semaphore_signal(self.semaphore);

        if (!result.success) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return;
        }

        self.handpickStores = result.data[@"handpick_store"];
        [self.collectionView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
}

// banner
- (void)loadBrandHallBannerData {
    THNRequest *request = [THNAPI getWithUrlString:kUrlBrandHallBannerStore requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        dispatch_semaphore_signal(self.semaphore);
        if (!result.success) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return;
        }
        
        self.bannerView.carouselBannerType = CarouselBannerTypeBrandHallFeatured;
        [self.bannerView setBannerView:result.data[@"banner_images"]];
    } failure:^(THNRequest *request, NSError *error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
}

#pragma mark UICollectionViewDelegate && UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.handpickStores.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNBrandHallFeaturedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBrandHallFeaturedCollectionCellIdentifier forIndexPath:indexPath];
    THNFeaturedBrandModel *brandModel = [THNFeaturedBrandModel mj_objectWithKeyValues:self.handpickStores[indexPath.row]];
    if (brandModel) {
        [cell setBrandModel:brandModel];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
     THNFeaturedBrandModel *brandModel = [THNFeaturedBrandModel mj_objectWithKeyValues:self.handpickStores[indexPath.row]];
    [self bannerPushBrandHall:brandModel.rid];
}

#pragma mark - THNBannerViewDelegate

- (void)bannerPushWeb:(NSString *)url {
    THNWebKitViewViewController *webVC = [[THNWebKitViewViewController alloc]init];
    webVC.url = url;
    [self.navigationController pushViewController:webVC animated:YES];
}

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

- (void)bannerPushCategorie:(NSString *)name initWithCategoriesID:(NSString *)categorieID {
    THNGoodsListViewController *goodsListVC = [[THNGoodsListViewController alloc] initWithCategoryId:categorieID categoryName:name];
    [self.navigationController pushViewController:goodsListVC animated:YES];
}

- (void)bannerPushSet:(NSInteger)collectionID {
    THNSetDetailViewController *setDetailVC = [[THNSetDetailViewController alloc]init];
    setDetailVC.collectionID = collectionID;
    [self.navigationController pushViewController:setDetailVC animated:YES];
}

- (void)bannerPushShowWindow:(NSString *)shopWindowRid {
    THNShopWindowDetailViewController *shopWindowDetail = [[THNShopWindowDetailViewController alloc]init];
    shopWindowDetail.rid = shopWindowRid;
    [self.navigationController pushViewController:shopWindowDetail animated:YES];
}

#pragma mark - lazy
- (THNBannerView *)bannerView {
    if (!_bannerView) {
        CGFloat fixedHeight = 60 + 130 + 47;
        CGFloat collectionViewY = kDeviceiPhoneX ? SCREEN_HEIGHT - 88 - fixedHeight : SCREEN_HEIGHT - 64 - fixedHeight;
        _bannerView = [[THNBannerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, collectionViewY - 20)];
        _bannerView.delegate = self;
    }
    return _bannerView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]initWithLineSpacing:15 initWithWidth:73 initwithHeight:130];
        CGFloat fixedHeight = 60 + 130 + 47;
        CGFloat collectionViewY = kDeviceiPhoneX ? SCREEN_HEIGHT - 88 - fixedHeight : SCREEN_HEIGHT - 64 - fixedHeight;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, collectionViewY, SCREEN_WIDTH, 130) collectionViewLayout:layout];
        layout.sectionInset = UIEdgeInsetsMake(10, 20, 0, 20);
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"THNBrandHallFeaturedCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kBrandHallFeaturedCollectionCellIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

@end
