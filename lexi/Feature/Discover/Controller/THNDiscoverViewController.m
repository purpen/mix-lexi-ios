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
#import "THNWebKitViewViewController.h"
#import "UIViewController+THNHud.h"

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
@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@end

@implementation THNDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
}

- (void)loadData {
    [self loadBannerData];
    //创建信号量
    self.semaphore = dispatch_semaphore_create(0);
    //创建全局并行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    self.isAddWindow = YES;
    self.loadViewY = kDeviceiPhoneX ? 88 : 64;
    [self showHud];
    
    dispatch_group_async(group, queue, ^{
        [self loadWonderfulStoriesData];
    });
    dispatch_group_async(group, queue, ^{
        [self loadGuessLikesData];
    });
    
    dispatch_group_notify(group, queue, ^{
        
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hiddenHud];
            [self.tableView reloadData];
        });
    });
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
        dispatch_semaphore_signal(self.semaphore);
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        self.guessLikes = result.data[@"life_records"];
    } failure:^(THNRequest *request, NSError *error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
}

// 精彩故事
- (void)loadWonderfulStoriesData {
    THNRequest *request = [THNAPI getWithUrlString:kUrWonderfulStories requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        dispatch_semaphore_signal(self.semaphore);
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        self.wonderfulStories = result.data[@"life_records"];
    } failure:^(THNRequest *request, NSError *error) {
        dispatch_semaphore_signal(self.semaphore);
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
    
    WEAKSELF;
    cell.collectionView.textCollectionBlock = ^(NSInteger rid) {
        THNArticleViewController *articleVC = [[THNArticleViewController alloc]init];
        articleVC.rid = rid;
        [weakSelf.navigationController pushViewController:articleVC animated:YES];
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
    return 158 * 2 + customGrassCellHeight + 30 + 70;
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
