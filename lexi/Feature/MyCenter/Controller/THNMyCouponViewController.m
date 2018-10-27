//
//  THNMyCouponViewController.m
//  lexi
//
//  Created by FLYang on 2018/10/16.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNMyCouponViewController.h"
#import "THNMyCouponDefaultView.h"
#import "THNUserManager.h"
#import "THNCouponDataModel.h"
#import "NSObject+EnumManagement.h"
#import "THNMyCouponTableViewCell.h"
#import "THNBrandHallViewController.h"
#import "THNSelectButtonView.h"
#import "THNBaseTabBarController.h"
#import "UIScrollView+THNMJRefresh.h"

static NSString *const kMyCouponTableViewCellId = @"THNMyCouponTableViewCellId";
/// text
static NSString *const kTitleCoupon         = @"优惠券";
static NSString *const kTextCouponBrand     = @"品牌券";
static NSString *const kTextCouponOfficial  = @"乐喜券";
static NSString *const kTextCouponFail      = @"已失效";
/// key
static NSString *const kKeyPage     = @"page";

@interface THNMyCouponViewController () <
    UITableViewDelegate,
    UITableViewDataSource,
    THNSelectButtonViewDelegate,
    THNMJRefreshDelegate
>

@property (nonatomic, strong) THNSelectButtonView *selectButtonView;
@property (nonatomic, strong) THNMyCouponDefaultView *couponDefaultView;
@property (nonatomic, strong) UITableView *couponTable;
/// 优惠券
@property (nonatomic, strong) NSMutableArray *couponDataArr;
/// 优惠券列表类型
@property (nonatomic, assign) THNUserCouponType couponType;
@property (nonatomic, assign) BOOL backHome;

@end

@implementation THNMyCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.backHome = NO;
    [self setupUI];
}

#pragma mark - custom delegate
- (void)selectButtonsDidClickedAtIndex:(NSInteger)index {
    self.couponType = (THNUserCouponType)index;
    
    [self.couponDataArr removeAllObjects];
    [self.couponTable reloadData];
    [self.couponTable beginHeaderRefresh];
    [self thn_getUserCouponDataWithPage:1 refresh:YES];
}

- (void)beginRefreshing {
    [self thn_getUserCouponDataWithPage:1 refresh:YES];
}

- (void)beginLoadingMoreDataWithCurrentPage:(NSNumber *)currentPage {
    [self thn_getUserCouponDataWithPage:currentPage.integerValue refresh:NO];
}

#pragma mark - network
// 获取自己的优惠券
- (void)thn_getUserCouponDataWithPage:(NSInteger)page refresh:(BOOL)refresh {
    [THNUserManager getUserCouponDataWithType:self.couponType
                                       params:@{kKeyPage: @(page)}
                                   completion:^(NSArray *couponData, NSError *error) {
                                       if (error) {
                                           [self thn_reloadTableStatus];
                                           
                                           if (refresh) {
                                               [self.couponTable endHeaderRefreshAndCurrentPageChange:NO];
                                               
                                           } else {
                                               [self.couponTable endFooterRefreshAndCurrentPageChange:NO];
                                           }
                                           
                                           [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
                                           return ;
                                       }
                                       
                                       if (refresh) {
                                           [self.couponTable endHeaderRefreshAndCurrentPageChange:YES];
                                           [self.couponDataArr removeAllObjects];
                                           [self thn_getCouponModelOfData:couponData];
                                           [self.couponTable resetNoMoreData];
                                           
                                       } else {
                                           [self.couponTable endFooterRefreshAndCurrentPageChange:YES];
                                           
                                           if (couponData.count) {
                                               [self thn_getCouponModelOfData:couponData];
                                               
                                           } else {
                                               [self.couponTable noMoreData];
                                           }
                                       }
                                   }];
}

#pragma mark - private methods
- (void)thn_getCouponModelOfData:(NSArray *)couponData {
    if (self.couponType == THNUserCouponTypeBrand) {
        for (NSDictionary *couponDict in couponData) {
            THNCouponDataModel *model = [THNCouponDataModel mj_objectWithKeyValues:couponDict];
            [self.couponDataArr addObject:model];
        }
        
    } else {
        for (NSDictionary *couponDict in couponData) {
            THNCouponModel *model = [THNCouponModel mj_objectWithKeyValues:couponDict];
            [self.couponDataArr addObject:model];
        }
    }
    
    [self thn_reloadTableStatus];
}

// 刷新优惠券列表状态
- (void)thn_reloadTableStatus {
    NSInteger couponCount = self.couponDataArr.count;
    self.couponTable.tableHeaderView = couponCount == 0 ? self.couponDefaultView : [UIView new];
    [self.couponTable reloadData];
}

// 打开品牌馆
- (void)thn_openBrandHallControllerWithId:(NSString *)rid {
    if (!rid.length) return ;
    
    THNBrandHallViewController *brandHall = [[THNBrandHallViewController alloc] init];
    brandHall.rid = rid;
    [self.navigationController pushViewController:brandHall animated:YES];
}

#pragma mark - tableView datasource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.couponDataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNMyCouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMyCouponTableViewCellId];
    if (!cell) {
        cell = [[THNMyCouponTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault)
                                               reuseIdentifier:kMyCouponTableViewCellId
                                                          type:self.couponType];
    }
    
    if (self.couponDataArr.count) {
        if (self.couponType == THNUserCouponTypeBrand) {
            [cell thn_setMyBrandCouponInfoData:self.couponDataArr[indexPath.row]];
            
        } else if (self.couponType == THNUserCouponTypeOfficial) {
            [cell thn_setMyOfficialCouponInfoData:self.couponDataArr[indexPath.row]];
            
        } else if (self.couponType == THNUserCouponTypeFail) {
            [cell thn_setMyFailCouponInfoData:self.couponDataArr[indexPath.row]];
            
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.couponType == THNUserCouponTypeBrand) {
        THNCouponDataModel *model = self.couponDataArr[indexPath.row];
        [self thn_openBrandHallControllerWithId:model.store_rid];
    
    } else if (self.couponType == THNUserCouponTypeOfficial) {
        self.backHome = YES;
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.backHome) {
        THNBaseTabBarController *rootTab = (THNBaseTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        rootTab.selectedIndex = 0;
    }
}

#pragma mark - setup UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
    
    [self.view addSubview:self.couponTable];
    [self.view addSubview:self.selectButtonView];
    
    // 添加刷新&加载更多
    [self.couponTable setRefreshHeaderWithClass:nil beginRefresh:YES animation:YES delegate:self];
    [self.couponTable setRefreshFooterWithClass:nil automaticallyRefresh:YES delegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.title = kTitleCoupon;
}

#pragma mark - getters and setters
- (UITableView *)couponTable {
    if (!_couponTable) {
        _couponTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:(UITableViewStylePlain)];
        _couponTable.delegate = self;
        _couponTable.dataSource = self;
        _couponTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _couponTable.showsVerticalScrollIndicator = NO;
        _couponTable.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
        _couponTable.tableFooterView = [UIView new];
        _couponTable.contentInset = UIEdgeInsetsMake(104, 0, 20, 0);
    }
    return _couponTable;
}

- (THNMyCouponDefaultView *)couponDefaultView {
    if (!_couponDefaultView) {
        _couponDefaultView = [[THNMyCouponDefaultView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 150)];
    }
    return _couponDefaultView;
}

- (THNSelectButtonView *)selectButtonView {
    if (!_selectButtonView) {
        _selectButtonView = [[THNSelectButtonView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, 40)
                                                                titles:@[kTextCouponBrand, kTextCouponOfficial, kTextCouponFail]
                                                    initWithButtonType:ButtonTypeLine];
        _selectButtonView.backgroundColor = [UIColor whiteColor];
        _selectButtonView.delegate = self;
    }
    return _selectButtonView;
}

- (NSMutableArray *)couponDataArr {
    if (!_couponDataArr) {
        _couponDataArr = [NSMutableArray array];
    }
    return _couponDataArr;
}

@end
