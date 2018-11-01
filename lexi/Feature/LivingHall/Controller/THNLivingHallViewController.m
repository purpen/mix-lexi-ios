//
//  THNLivingHallViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/7/25.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLivingHallViewController.h"
#import "THNLivingHallHeaderView.h"
#import "UIView+Helper.h"
#import "THNFeatureTableViewCell.h"
#import "UIColor+Extension.h"
#import "THNLivingHallRecommendTableViewCell.h"
#import "THNMarco.h"
#import "THNLoginManager.h"
#import "THNAPI.h"
#import <MJExtension/MJExtension.h>
#import "THNProductModel.h"
#import "THNLivingHallExpandView.h"
#import "THNSaveTool.h"
#import "THNConst.h"
#import "THNPruductCenterViewController.h"
#import "THNGoodsInfoViewController.h"
#import "UIViewController+THNHud.h"
#import "THNPhotoManager.h"
#import "THNQiNiuUpload.h"
#import "THNShareViewController.h"

static CGFloat const livingHallHeaderViewHeight = 500;
static CGFloat const expandViewHeight = 59;
static CGFloat const cellSpacing = 15;

static NSString *const kLivingHallRecommendCellIdentifier = @"kLivingHallRecommendCellIdentifier";
// 馆长推荐
static NSString *const kUrlCuratorRecommended = @"/core_platforms/products/by_store";
// 删除商品
static NSString *const kUrlDeleteProduct = @"/core_platforms/fx_distribute/remove";
// 本周最受欢迎
static NSString *const kUrlWeekPopular = @"/fx_distribute/week_popular";

@interface THNLivingHallViewController ()<THNFeatureTableViewCellDelegate>

@property (nonatomic, strong) THNLivingHallHeaderView *livingHallHeaderView;
// 本周最受人气欢迎Cell
@property (nonatomic, strong) THNFeatureTableViewCell *featureCell;
@property (nonatomic, strong)  THNLivingHallExpandView *expandView;
@property (nonatomic, strong) NSArray *recommendedArray;
@property (nonatomic, strong) NSArray *weekPopularArray;
@property (nonatomic, strong) NSMutableArray *recommendedMutableArray;
@property (nonatomic, strong) NSArray *likeProductUserArray;
@property (nonatomic, assign) CGFloat recommenLabelHegiht;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, assign) NSInteger curatorPerPageCount;
@property (nonatomic, assign) NSInteger weekPopularPerPageCount;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, assign) BOOL isLoadMoreData;
@property (nonatomic, assign) CGFloat footerViewHeight;
@property (nonatomic, assign) CGFloat featureCellHeight;

@end

@implementation THNLivingHallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadCuratorRecommendedData) name:kShelfSuccess object:nil];
    [self initPageNumber];
    [self.livingHallHeaderView setLifeStore];
    [self setupUI];
    [self loadData];
}

- (void)loadData {
    //创建信号量
    self.semaphore = dispatch_semaphore_create(0);
    //创建全局并行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    self.isAddWindow = YES;
    self.isFromMain = YES;
    self.loadViewY = 135 + 22;
    [self showHud];
    dispatch_group_async(group, queue, ^{
        [self loadCuratorRecommendedData];
    });
    dispatch_group_async(group, queue, ^{
        [self loadWeekPopularData];
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

// 初始化页码
- (void)initPageNumber {
    self.pageCount = 1;
    self.curatorPerPageCount = 3;
    self.weekPopularPerPageCount = 4;
}

// 解决HeaderView和footerView悬停的问题
- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)setupUI {
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"THNLivingHallRecommendTableViewCell" bundle:nil] forCellReuseIdentifier:kLivingHallRecommendCellIdentifier];
    self.tableView.estimatedRowHeight = 400;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

// 馆长推荐
- (void)loadCuratorRecommendedData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(self.pageCount);
    params[@"per_page"] = @(self.curatorPerPageCount);
    params[@"sid"] = [THNLoginManager sharedManager].storeRid;
    
    THNRequest *request = [THNAPI getWithUrlString:kUrlCuratorRecommended requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
       NSInteger signalQuantity =  dispatch_semaphore_signal(self.semaphore);
        if (!result.success) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return;
        }
        
        [self.recommendedMutableArray removeAllObjects];
        self.recommendedArray = result.data[@"products"];
        
        for (NSDictionary *dict in self.recommendedArray) {
            [self.recommendedmutableArray addObject:dict];
        }
        
        if (self.recommendedmutableArray.count > 0) {
            self.livingHallHeaderView.noProductView.hidden = YES;
        } else {
            self.livingHallHeaderView.noProductView.hidden = NO;
        }
        
        if (signalQuantity == 0) {
            [self.tableView reloadData];
        }
        
    } failure:^(THNRequest *request, NSError *error) {
       dispatch_semaphore_signal(self.semaphore);
    }];
}

// 删除馆长推荐商品
- (void)deleteProduct:(NSString *)rid {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = rid;
    params[@"sid"] = [THNLoginManager sharedManager].storeRid;
    THNRequest *request = [THNAPI deleteWithUrlString:kUrlDeleteProduct requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [self loadCuratorRecommendedData];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

// 本周最受人气欢迎
- (void)loadWeekPopularData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(1);
    params[@"per_page"] = @(self.weekPopularPerPageCount);
    THNRequest *request = [THNAPI getWithUrlString:kUrlWeekPopular requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        dispatch_semaphore_signal(self.semaphore);
        if (!result.success) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return;
        }
        
        self.weekPopularArray = result.data[@"products"];
        self.title = result.data[@"title"];
        [self.featureCell setCellTypeStyle:FeaturedNo initWithDataArray:self.weekPopularArray initWithTitle:@"本周最受欢迎"];
    } failure:^(THNRequest *request, NSError *error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
}

#pragma mark - private methods
/**
 选择头像照片
 */
- (void)thn_getSelectImage {
    WEAKSELF;
    [[THNPhotoManager sharedManager] getPhotoOfAlbumOrCameraWithController:self completion:^(NSData *imageData) {
        [weakSelf.livingHallHeaderView setHeaderImageWithData:imageData];
        
        [[THNQiNiuUpload sharedManager] uploadQiNiuWithImageData:imageData
                                                       compltion:^(NSDictionary *result) {
                                                           NSArray *idsArray = result[@"ids"];
                                                           [weakSelf.livingHallHeaderView setHeaderAvatarId:[idsArray[0] integerValue]];
                                                       }];
    }];
}


#pragma mark - UITableViewDataSource method 实现
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recommendedmutableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNLivingHallRecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLivingHallRecommendCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    THNProductModel *productModel = [THNProductModel mj_objectWithKeyValues:self.recommendedmutableArray[indexPath.row]];
    // 设置喜欢用户头像
    [cell loadLikeProductUserData:productModel.rid];
    // 设置馆长头像
    [cell setCurtorAvatar:self.livingHallHeaderView.storeAvatarUrl];
    [cell setProductModel:productModel];
    
    __weak typeof(self)weakSelf = self;
    cell.deleteProductBlock = ^(UITableViewCell *cell) {
        NSIndexPath *indexPath = [tableView indexPathForCell:cell];
         THNProductModel *productModel = [THNProductModel mj_objectWithKeyValues:self.recommendedmutableArray[indexPath.row]];
        [weakSelf deleteProduct:productModel.rid];
    };
    
    cell.shareProductBlock = ^{
        THNShareViewController *shareVC = [[THNShareViewController alloc]init];
        shareVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:shareVC animated:NO completion:nil];
    };
    
    return cell;
}

#pragma mark - UITableViewDelegate method 实现
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if ([THNSaveTool objectForKey:kIsCloseLivingHallView]) {
        return self.livingHallHeaderView.noProductView.hidden ? livingHallHeaderViewHeight - 115 - 100 : livingHallHeaderViewHeight - 100;
    } else {
          return self.livingHallHeaderView.noProductView.hidden ? livingHallHeaderViewHeight - 115 : livingHallHeaderViewHeight;
    }
  
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    __weak typeof(self)weakSelf = self;
    
    self.livingHallHeaderView.changeHeaderViewBlock = ^{
        [weakSelf.tableView reloadData];
    };
    
    self.livingHallHeaderView.pushProductCenterBlock = ^{
        THNPruductCenterViewController *productCenter = [[THNPruductCenterViewController alloc]init];
        [weakSelf.navigationController pushViewController:productCenter animated:YES];
    };
    
    self.livingHallHeaderView.storeLogoBlock = ^{
        [weakSelf thn_getSelectImage];
    };
    
    return self.livingHallHeaderView;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.expandView.viewHeight = expandViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, -15, SCREEN_WIDTH,self.footerViewHeight)];
    self.featureCell.frame = CGRectMake(0, -cellSpacing + expandViewHeight, SCREEN_WIDTH,self.featureCellHeight);
    if (self.recommendedArray.count == self.curatorPerPageCount) {
        self.featureCell.viewY = expandViewHeight - 15;
        [footerView addSubview:self.expandView];
    } else {
        self.featureCell.viewY = 0;
    }

    self.featureCell.backgroundColor = [UIColor whiteColor];
    __weak typeof(self)weakSelf = self;
    
    self.expandView.loadMoreDateBlcok = ^{
        weakSelf.curatorPerPageCount += weakSelf.curatorPerPageCount;
        weakSelf.isLoadMoreData = YES;
        [weakSelf loadCuratorRecommendedData];
    };
    
    [footerView addSubview:self.featureCell];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    NSInteger showCellRow = self.weekPopularArray.count / 2;
    self.featureCellHeight = (kCellOptimalHeight + 10) * showCellRow + 90;
    self.footerViewHeight = self.recommendedArray.count == self.curatorPerPageCount ? self.featureCellHeight + expandViewHeight : self.featureCellHeight;

    return self.footerViewHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    THNProductModel *productModel = [THNProductModel mj_objectWithKeyValues:self.recommendedmutableArray[indexPath.row]];
    [self pushGoodInfo:productModel.rid];
}

#pragma mark - THNFeatureTableViewCellDelegate
// 商品详情
- (void)pushGoodInfo:(NSString *)rid {
    THNGoodsInfoViewController *goodInfo = [[THNGoodsInfoViewController alloc]initWithGoodsId:rid];
    [self.navigationController pushViewController:goodInfo animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - lazy
- (THNLivingHallHeaderView *)livingHallHeaderView {
    if (!_livingHallHeaderView) {
        _livingHallHeaderView = [THNLivingHallHeaderView viewFromXib];
    }
    return _livingHallHeaderView;
}

- (THNFeatureTableViewCell *)featureCell {
    if (!_featureCell) {
        _featureCell = [THNFeatureTableViewCell viewFromXib];
        _featureCell.delagate = self;
    }
    return _featureCell;
}

- (THNLivingHallExpandView *)expandView {
    if (!_expandView) {
        _expandView = [THNLivingHallExpandView viewFromXib];
        _expandView.frame = CGRectMake(0, -cellSpacing, SCREEN_WIDTH, expandViewHeight);
    }
    return _expandView;
}

- (NSMutableArray *)recommendedmutableArray {
    if (!_recommendedMutableArray) {
        _recommendedMutableArray = [NSMutableArray array];
    }
    return _recommendedMutableArray;
}

@end
