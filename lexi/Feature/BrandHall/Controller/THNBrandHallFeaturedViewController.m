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

static NSString *const kUrlBrandHallFeatured = @"/column/handpick_store";
static NSString *const kUrlBrandHallBannerStore = @"/banners/store_ad";
static NSString *const kBrandHallFeaturedCollectionCellIdentifier = @"kBrandHallFeaturedCollectionCellIdentifier";
static CGFloat const kBrandHallHeight = 375;

@interface THNBrandHallFeaturedViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

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
    THNRequest *request = [THNAPI getWithUrlString:kUrlBrandHallFeatured requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.handpickStores = result.data[@"handpick_store"];
        [self.collectionView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

// banner
- (void)loadBrandHallBannerData {
    THNRequest *request = [THNAPI getWithUrlString:kUrlBrandHallBannerStore requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.bannerView.carouselBannerType = CarouselBannerTypeBrandHallFeatured;
        [self.bannerView setBannerView:result.data[@"banner_images"]];
    } failure:^(THNRequest *request, NSError *error) {
        
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

#pragma mark - lazy
- (THNBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[THNBannerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kBrandHallHeight)];
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
