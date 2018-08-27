//
//  THNRecommendTableViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/8/24.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNRecommendViewController.h"
#import "THNMarco.h"
#import "THNFeaturedCollectionView.h"
#import "THNAPI.h"
#import "THNCollectionViewFlowLayout.h"
#import "THNFeaturedOpeningView.h"
#import "UIView+Helper.h"
#import "THNPopularSingleProductTableViewController.h"
#import "THNExploresViewController.h"

@interface THNRecommendViewController ()

@property (nonatomic, strong) THNFeaturedCollectionView *featuredCollectionView;
@property (nonatomic, strong) THNFeaturedOpeningView *openingView;
@property (nonatomic, strong) UIScrollView *backgroundScrollView;


@end

@implementation THNRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadTopBannerData];
    [self.view addSubview:self.backgroundScrollView];
    self.automaticallyCalculatesItemWidths = YES;
    [self.backgroundScrollView addSubview:self.featuredCollectionView];
    [self.openingView loadLivingHallHeadLineData];
    [self.backgroundScrollView addSubview:self.openingView];
    [self.backgroundScrollView addSubview:self.menuView];
    [self.backgroundScrollView addSubview:self.scrollView];
    self.backgroundScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 2200);
}


// 顶部Banner
- (void)loadTopBannerData {
    THNRequest *request = [THNAPI getWithUrlString:@"/banners/center_ad" requestDictionary:nil isSign:YES delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.featuredCollectionView.dataArray = result.data[@"banner_images"];
        self.featuredCollectionView.bannerType = BannerTypeCenter;
        [self.featuredCollectionView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}


#pragma mark - lazy
- (THNFeaturedCollectionView *)featuredCollectionView {
    if (!_featuredCollectionView) {
        THNCollectionViewFlowLayout *flowLayout = [[THNCollectionViewFlowLayout alloc]init];
        _featuredCollectionView = [[THNFeaturedCollectionView alloc]initWithFrame:CGRectMake(20 , 10, SCREEN_WIDTH, 140) collectionViewLayout:flowLayout];
    }
    return _featuredCollectionView;
}

- (THNFeaturedOpeningView *)openingView {
    if (!_openingView) {
        _openingView = [THNFeaturedOpeningView viewFromXib];
        _openingView.topTintView.hidden = YES;
        _openingView.frame = CGRectMake(15, CGRectGetMaxY(self.featuredCollectionView.frame) + 20, SCREEN_WIDTH - 30, 70);
    }
    return _openingView;
}

- (UIScrollView *)backgroundScrollView {
    if (!_backgroundScrollView) {
        _backgroundScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _backgroundScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + 200);
    }
    return _backgroundScrollView;
    
}

#pragma WMPageController
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 3;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return @"热门单品";
            break;
        case 1:
            return @"官方推荐";
            break;
        default:
            return @"新品首发";
    }
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index % 3) {
        case 0:{
            THNPopularSingleProductTableViewController *popularSingleProduct = [[THNPopularSingleProductTableViewController alloc] init];
            return popularSingleProduct;
        }
        case 1: return [[THNExploresViewController alloc] init];
        default: return [[UITableViewController alloc] init];
    }
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    CGFloat width = [super menuView:menu widthForItemAtIndex:index];
    return width;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    self.selectIndex = 0;
    CGRectGetMaxY(self.navigationController.navigationBar.frame);
    return CGRectMake(20, CGRectGetMaxY(self.openingView.frame) + 16, self.view.frame.size.width - 126, 44);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    CGFloat originY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:self.menuView]);
    return CGRectMake(0, originY, self.view.frame.size.width, 2200);
}

@end
