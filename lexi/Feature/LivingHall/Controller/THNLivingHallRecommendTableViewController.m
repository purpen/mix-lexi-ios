//
//  THNLivingHallRecommendTableViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/12/13.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLivingHallRecommendTableViewController.h"
#import "THNLivingHallRecommendTableViewCell.h"
#import "THNLoginManager.h"
#import "THNProductModel.h"
#import "THNShareViewController.h"

static NSString *const kLivingHallRecommendCellIdentifier = @"kLivingHallRecommendCellIdentifier";
// 馆长推荐
static NSString *const kUrlCuratorRecommended = @"/core_platforms/products/by_store";
// 删除商品
static NSString *const kUrlDeleteProduct = @"/core_platforms/fx_distribute/remove";

@interface THNLivingHallRecommendTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *recommendedArray;
@property (nonatomic, strong) NSMutableArray *recommendedMutableArray;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, assign) NSInteger curatorPerPageCount;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation THNLivingHallRecommendTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self initPageNumber];
    [self loadCuratorRecommendedData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)setupUI {
    self.navigationBarView.title = @"馆主推荐";
    [self.view addSubview:self.tableView];
}

// 初始化页码
- (void)initPageNumber {
    self.pageCount = 1;
    self.curatorPerPageCount = 10;
}

// 馆长推荐
- (void)loadCuratorRecommendedData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(self.pageCount);
    params[@"per_page"] = @(self.curatorPerPageCount);
    params[@"sid"] = [THNLoginManager sharedManager].storeRid;
    params[@"is_distributed"] = @(2);
    
    THNRequest *request = [THNAPI getWithUrlString:kUrlCuratorRecommended requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return;
        }
        
        [self.recommendedMutableArray removeAllObjects];
        
        NSArray *array = result.data[@"products"];
        [self.recommendedMutableArray addObjectsFromArray:[THNProductModel mj_objectArrayWithKeyValuesArray:array]];
        [self.tableView reloadData];
        
    } failure:^(THNRequest *request, NSError *error) {
    
    }];
}

// 删除馆长推荐商品
- (void)deleteProduct:(NSString *)rid initCellIndex:(NSInteger)index {
    [SVProgressHUD thn_show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = rid;
    params[@"sid"] = [THNLoginManager sharedManager].storeRid;
    THNRequest *request = [THNAPI deleteWithUrlString:kUrlDeleteProduct requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [SVProgressHUD dismiss];
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        // 刷新THNLivingHallViewController的馆长推荐商品
        [[NSNotificationCenter defaultCenter]postNotificationName:kShelfSuccess object:nil];
        [self.recommendedMutableArray removeObjectAtIndex:index];
        [self.tableView deleteRow:index inSection:0 withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

/**
 打开分享视图
 */
- (void)thn_openShareController:(THNProductModel *)productModel {
    if (productModel) return;
    
    THNShareViewController *shareVC = [[THNShareViewController alloc] initWithType:(THNSharePosterTypeGoods)
                                                                         requestId:productModel.rid];
    [shareVC shareObjectWithTitle:productModel.name
                            descr:productModel.stick_text
                        thumImage:productModel.cover
                           webUrl:[NSString stringWithFormat:@"%@%@", kShareProductUrlPrefix, productModel.rid]];
    shareVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:shareVC animated:NO completion:nil];
}

#pragma mark - UITableViewDataSource method 实现
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recommendedmutableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNLivingHallRecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLivingHallRecommendCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    THNProductModel *productModel = self.recommendedmutableArray[indexPath.row];
    // 设置喜欢用户头像
    [cell loadLikeProductUserData:productModel.rid];
    // 设置馆长头像
    [cell setCurtorAvatar:self.storeAvatarUrl];
    [cell setProductModel:productModel];
    
    __weak typeof(self)weakSelf = self;
    cell.deleteProductBlock = ^(UITableViewCell *cell) {
        NSIndexPath *indexPath = [weakSelf.tableView indexPathForCell:cell];
        THNProductModel *productModel = [THNProductModel mj_objectWithKeyValues:weakSelf.recommendedmutableArray[indexPath.row]];
        [weakSelf deleteProduct:productModel.rid initCellIndex:indexPath.row];
    };
    
    cell.shareProductBlock = ^(THNProductModel *productModel) {
        [weakSelf thn_openShareController:productModel];
    };
    
    return cell;
}

- (NSMutableArray *)recommendedmutableArray {
    if (!_recommendedMutableArray) {
        _recommendedMutableArray = [NSMutableArray array];
    }
    return _recommendedMutableArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        
        CGFloat tableHeight = kDeviceiPhoneX ? SCREEN_HEIGHT - 88 : SCREEN_HEIGHT - 64;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, tableHeight) style:UITableViewStylePlain];
        _tableView.estimatedRowHeight = 400;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"THNLivingHallRecommendTableViewCell" bundle:nil] forCellReuseIdentifier:kLivingHallRecommendCellIdentifier];
    }
    return _tableView;
}

@end
