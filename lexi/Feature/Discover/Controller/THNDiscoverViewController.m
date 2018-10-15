//
//  THNDiscoverViewController.m
//  lexi
//
//  Created by FLYang on 2018/7/20.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNDiscoverViewController.h"
#import "THNDiscoverThemeViewController.h"
#import "THNAPI.h"
#import "THNDiscoverTableViewCell.h"
#import "THNTextCollectionView.h"
#import "THNGrassListModel.h"
#import "THNBannerView.h"
#import "THNDidcoverSetView.h"
#import "UIView+Helper.h"
#import "THNArticleViewController.h"
#import "THNGoodsInfoViewController.h"
#import "THNBrandHallViewController.h"
#import "THNArticleViewController.h"
#import "THNGoodsListViewController.h"

static NSString *const kUrGuessLikes = @"/life_records/guess_likes";
static NSString *const kUrWonderfulStories = @"/life_records/wonderful_stories";
static NSString *const kDiscoverCellIdentifier = @"kDiscoverCellIdentifier";
// banner
static NSString *const kUrlDiscoverBanner = @"/banners/discover_ad";

@interface THNDiscoverViewController () <THNBannerViewDelegate>

@property (nonatomic, strong) NSArray *guessLikes;
@property (nonatomic, strong) NSArray *wonderfulStories;
@property (nonatomic, strong) THNBannerView *bannerView;
@property (nonatomic, strong) THNDidcoverSetView *setView;

@end

@implementation THNDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWonderfulStoriesData];
    [self loadGuessLikesData];
    [self loadBannerData];
    [self setupUI];
}

- (void)psuhNext {
    THNDiscoverThemeViewController *theme = [[THNDiscoverThemeViewController alloc]init];
    [self.navigationController pushViewController:theme animated:YES];
}

#pragma mark - 请求数据
// banner
- (void)loadBannerData {
    
    THNRequest *request = [THNAPI getWithUrlString:kUrlDiscoverBanner requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        
        [self.bannerView setBannerView:result.data[@"banner_images"]];
    } failure:^(THNRequest *request, NSError *error) {
        
        
    }];
}

// 猜你喜欢
- (void)loadGuessLikesData {
    THNRequest *request = [THNAPI getWithUrlString:kUrGuessLikes requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.guessLikes = result.data[@"life_records"];
        [self.tableView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

// 精彩故事
- (void)loadWonderfulStoriesData {
    THNRequest *request = [THNAPI getWithUrlString:kUrWonderfulStories requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.wonderfulStories = result.data[@"life_records"];
        [self.tableView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

- (void)setupUI {
    self.navigationBarView.title = kTitleDiscover;
    [self.tableView registerNib:[UINib nibWithNibName:@"THNDiscoverTableViewCell" bundle:nil] forCellReuseIdentifier:kDiscoverCellIdentifier];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNDiscoverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDiscoverCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0:
            cell.titleLabel.text = @"猜你喜欢";
            cell.collectionView.dataArray = self.guessLikes;
            break;
            
        default:
            cell.titleLabel.text = @"精彩故事";
            cell.collectionView.dataArray = self.wonderfulStories;
            break;
    }
    
    cell.collectionView.textCollectionBlock = ^(NSInteger rid) {
        THNArticleViewController *articleVC = [[THNArticleViewController alloc]init];
        articleVC.rid = rid;
        [self.navigationController pushViewController:articleVC animated:YES];
    };
    
    [cell.collectionView reloadData];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
            return [self getCellHeight:self.guessLikes];
        default:
            return [self getCellHeight:self.wonderfulStories];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(self.setView.frame) + 20)];
    headerView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:self.bannerView];
    [headerView addSubview:self.setView];
    __weak typeof(self)weakSelf = self;
    
    self.setView.discoverSetBlcok = ^(NSInteger selectIndex, NSString *title) {
        THNDiscoverThemeViewController *themeVC = [[THNDiscoverThemeViewController alloc]init];
        themeVC.themeType = selectIndex;
        themeVC.navigationBarViewTitle = title;
        [weakSelf.navigationController pushViewController:themeVC animated:YES];
    };
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGRectGetMaxY(self.setView.frame) + 20;
}

- (CGFloat)getCellHeight:(NSArray *)array {
    __block CGFloat firstRowMaxtitleHeight = 0;
    __block CGFloat firstRowMaxcontentHeight = 0;
    __block CGFloat secondRowMaxtitleHeight = 0;
    __block CGFloat secondRowMaxcontentHeight = 0;
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        THNGrassListModel *grassListModel = [THNGrassListModel mj_objectWithKeyValues:obj];
        //  设置最大size
        CGFloat titleMaxWidth = (SCREEN_WIDTH - 40 - 9) / 2 - 7.5;
        CGFloat contentMaxWidth = (SCREEN_WIDTH - 40 - 9) / 2 - 10.5;
        CGSize titleSize = CGSizeMake(titleMaxWidth, 35);
        CGSize contentSize = CGSizeMake(contentMaxWidth, 33);
        NSDictionary *titleFont = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:12]};
        NSDictionary *contentFont = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:12]};
        CGFloat titleHeight = [grassListModel.title boundingRectWithSize:titleSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:titleFont context:nil].size.height;
        CGFloat contentHeight = [grassListModel.des boundingRectWithSize:contentSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:contentFont context:nil].size.height;
        
        // 取出第一列最大的titleLabel和contentLabel的高度
        if (idx <= 1) {
            
            if (titleHeight > firstRowMaxtitleHeight) {
                firstRowMaxtitleHeight = titleHeight;
            }
            
            if (contentHeight > secondRowMaxtitleHeight ) {
                firstRowMaxcontentHeight = contentHeight;
            }
            // 取出第二列最大的titleLabel和contentLabel的高度
        } else {
            
            if (titleHeight > secondRowMaxtitleHeight) {
                secondRowMaxtitleHeight = titleHeight;
            }
            
            if (contentHeight > secondRowMaxcontentHeight) {
                secondRowMaxcontentHeight = titleHeight;
            }
            
        }
    }];
    
    CGFloat customGrassCellHeight = firstRowMaxtitleHeight + secondRowMaxtitleHeight + firstRowMaxcontentHeight + secondRowMaxcontentHeight;
    return 158 * 2 + customGrassCellHeight + 20 + 70;
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

#pragma mark -lazy
- (THNBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[THNBannerView alloc]initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH - 20 * 2, 180)];
        _bannerView.delegate = self;
    }
    return _bannerView;
}

- (THNDidcoverSetView *)setView {
    if (!_setView) {
        _setView = [THNDidcoverSetView viewFromXib];
        _setView.frame = CGRectMake(0, CGRectGetMaxY(self.bannerView.frame), SCREEN_WIDTH, 230);
    }
    return _setView;
}


@end
