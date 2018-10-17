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

static NSString *const kMyCouponTableViewCellId = @"THNMyCouponTableViewCellId";
/// text
static NSString *const kTitleCoupon         = @"优惠券";
static NSString *const kTextCouponBrand     = @"品牌券";
static NSString *const kTextCouponOfficial  = @"乐喜券";
static NSString *const kTextCouponFail      = @"已失效";
/// key
static NSString *const kKeyPage     = @"page";

@interface THNMyCouponViewController () <UITableViewDelegate, UITableViewDataSource, THNSelectButtonViewDelegate>

@property (nonatomic, strong) THNSelectButtonView *selectButtonView;
@property (nonatomic, strong) THNMyCouponDefaultView *couponDefaultView;
@property (nonatomic, strong) UITableView *couponTable;
/// 优惠券
@property (nonatomic, strong) NSMutableArray *couponDataArr;
/// 优惠券当前页数
@property (nonatomic, assign) NSInteger currentPage;
/// 优惠券列表类型
@property (nonatomic, assign) THNUserCouponType couponType;

@end

@implementation THNMyCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
}

#pragma mark - network
// 获取自己的优惠券
- (void)thn_getUserCouponDataWithType:(THNUserCouponType)type {
    self.couponType = type;
    
    WEAKSELF;
   
    [THNUserManager getUserCouponDataWithType:type
                                       params:@{kKeyPage: @(self.currentPage += 1)}
                                   completion:^(NSArray *couponData, NSError *error) {
                                       if (error) {
                                           [weakSelf thn_reloadTableStatus];
                                           return ;
                                       }
                                       
                                       [weakSelf thn_getCouponModelOfData:couponData];
                                   }];
}

#pragma mark - custom delegate
- (void)selectButtonsDidClickedAtIndex:(NSInteger)index {
    self.currentPage = 0;
    [self.couponDataArr removeAllObjects];
    [self.couponTable reloadData];
    
    [self thn_getUserCouponDataWithType:(THNUserCouponType)index];
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
    }
}

#pragma mark - setup UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
    
    [self.view addSubview:self.couponTable];
    [self.view addSubview:self.selectButtonView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self setNavigationBar];
    [self thn_getUserCouponDataWithType:(THNUserCouponTypeBrand)];
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
