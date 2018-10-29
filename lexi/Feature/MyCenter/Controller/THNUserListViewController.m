//
//  THNUserListViewController.m
//  lexi
//
//  Created by FLYang on 2018/9/6.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNUserListViewController.h"
#import "THNUserListTableViewCell.h"
#import "THNGoodsManager.h"
#import "THNUserCenterViewController.h"
#import "THNLoginManager.h"
#import "UIScrollView+THNMJRefresh.h"
#import "NSString+Helper.h"

/// url
static NSString *const kURLLikeGoodsUser    = @"/product/userlike";
static NSString *const kURLUserFans         = @"/users/user_fans";
static NSString *const kURLUserFollow       = @"/users/followed_users";
/// key
static NSString *const kKeyRid              = @"rid";
static NSString *const kKeyUid              = @"uid";
static NSString *const kKeyPage             = @"page";
static NSString *const kKeyPerPage          = @"per_page";
static NSString *const kKeyLikeUsers        = @"product_like_users";
static NSString *const kKeyUserFans         = @"user_fans";
static NSString *const kKeyUserFollow       = @"followed_users";
/// text
static NSString *const kUserTableViewCellId = @"kUserTableViewCellId";
static NSString *const kTitleLikeGoods      = @"喜欢该商品的人";
static NSString *const kTitleUserFans       = @"粉丝";
static NSString *const kTitleUserFollow     = @"关注";

@interface THNUserListViewController () <UITableViewDelegate, UITableViewDataSource, THNMJRefreshDelegate>

/// 类型
@property (nonatomic, assign) THNUserListType listType;
/// id
@property (nonatomic, strong) NSString *requestId;
/// 用户列表
@property (nonatomic, strong) UITableView *userTableView;
/// 用户数据
@property (nonatomic, strong) NSMutableArray *modelArr;
/// 当前页码
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation THNUserListViewController

- (instancetype)initWithType:(THNUserListType)type requestId:(NSString *)requestId {
    self = [super init];
    if (self) {
        self.listType = type;
        self.requestId = requestId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - custom delegate
- (void)beginRefreshing {
    self.currentPage = 1;
    [self thn_requestUserListDataWithRefresh:YES];
}

- (void)beginLoadingMoreDataWithCurrentPage:(NSNumber *)currentPage {
    self.currentPage = currentPage.integerValue;
    [self thn_requestUserListDataWithRefresh:NO];
}

#pragma mark - network
- (void)thn_requestUserListDataWithRefresh:(BOOL)refresh {
    NSLog(@"请求参数：%@", [self thn_requestParams]);
    THNRequest *request = [THNAPI getWithUrlString:[self thn_getRequestUrl]
                                 requestDictionary:[self thn_requestParams]
                                          delegate:nil];
    
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        THNLog(@"============ 用户列表：%@", [NSString jsonStringWithObject:result.data]);
        if (!result.isSuccess) {
            if (refresh) {
                [self.userTableView endHeaderRefreshAndCurrentPageChange:NO];
            } else {
                [self.userTableView endFooterRefreshAndCurrentPageChange:NO];
            }
            
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return ;
        }
        
        NSArray *dataArr = [NSArray arrayWithArray:(NSArray *)result.data[[self thn_resultDataKey]]];
        
        if (refresh) {
            [self.userTableView endHeaderRefreshAndCurrentPageChange:YES];
            [self.modelArr removeAllObjects];
            [self.modelArr addObjectsFromArray:[self thn_convertModelWithData:dataArr]];
            [self.userTableView resetNoMoreData];
            
        } else {
            [self.userTableView endFooterRefreshAndCurrentPageChange:YES];
            
            if (dataArr.count) {
                [self.modelArr addObjectsFromArray:[self thn_convertModelWithData:dataArr]];
                
            } else {
                [self.userTableView noMoreData];
            }
        }
    
        [self.userTableView reloadData];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
        
        if (refresh) {
            [self.userTableView endHeaderRefreshAndCurrentPageChange:NO];
        } else {
            [self.userTableView endFooterRefreshAndCurrentPageChange:NO];
        }
    }];
}

- (NSArray *)thn_convertModelWithData:(NSArray *)data {
    NSMutableArray *modelArr = [NSMutableArray array];
    
    for (NSDictionary *dict in data) {
        THNUserModel *model = [THNUserModel mj_objectWithKeyValues:dict];
        [modelArr addObject:model];
    }
    
    return [modelArr copy];
}

- (NSString *)thn_resultDataKey {
    NSDictionary *resultDict = @{@(THNUserListTypeLikeGoods):   kKeyLikeUsers,
                                 @(THNUserListTypeFans):        kKeyUserFans,
                                 @(THNUserListTypeFollow):      kKeyUserFollow,
                                 @(THNUserListTypeOtherFans):   kKeyUserFans,
                                 @(THNUserListTypeOtherFollow): kKeyUserFollow};
    
    return resultDict[@(self.listType)];
}

- (NSDictionary *)thn_requestParams {
    NSDictionary *paramsDict = @{kKeyPerPage: @(10),
                                 kKeyPage: @(self.currentPage)};
    
    if (self.requestId.length) {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:paramsDict];
        NSString *paramsKey = self.listType == THNUserListTypeLikeGoods ? kKeyRid : kKeyUid;
        [params setObject:self.requestId forKey:paramsKey];
        
        return [params copy];
    }
    
    return paramsDict;
}

- (NSString *)thn_getRequestUrl {
    NSDictionary *requestUrlDict = @{@(THNUserListTypeLikeGoods):   @"/product/userlike",
                                     @(THNUserListTypeFans):        @"/users/user_fans",
                                     @(THNUserListTypeFollow):      @"/users/followed_users",
                                     @(THNUserListTypeOtherFans):   @"/users/other_user_fans",
                                     @(THNUserListTypeOtherFollow): @"/users/other_followed_users"};
    
    return requestUrlDict[@(self.listType)];
}

#pragma mark - setup UI
- (void)setupUI {
    [self.view addSubview:self.userTableView];
    
    // 添加刷新&加载更多
    [self.userTableView setRefreshHeaderWithClass:nil beginRefresh:YES animation:YES delegate:self];
    [self.userTableView setRefreshFooterWithClass:nil automaticallyRefresh:YES delegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationTitle];
}

- (void)thn_setNavigationTitle {
    NSArray *titlsArr = @[kTitleLikeGoods, kTitleUserFans, kTitleUserFollow, kTitleUserFans, kTitleUserFollow];
    self.navigationBarView.title = titlsArr[(NSUInteger)self.listType];
}

#pragma mark - dataSource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNUserListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserTableViewCellId];
    if (!cell) {
        cell = [[THNUserListTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:kUserTableViewCellId];
    }
    
    if (self.modelArr.count) {
        [cell thn_setUserListCellModel:self.modelArr[indexPath.row]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    THNUserModel *model = [THNUserModel mj_objectWithKeyValues:self.modelArr[indexPath.row]];
    
    if ([[THNLoginManager sharedManager].userId isEqualToString:model.uid]) {
        return;
    }
    
    THNUserCenterViewController *userCenterVC = [[THNUserCenterViewController alloc] initWithUserId:model.uid];
    [self.navigationController pushViewController:userCenterVC animated:YES];
}

#pragma mark - getters and setters
- (UITableView *)userTableView {
    if (!_userTableView) {
        _userTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:(UITableViewStylePlain)];
        _userTableView.contentInset = UIEdgeInsetsMake(44, 0, 20, 0);
        _userTableView.delegate = self;
        _userTableView.dataSource = self;
        _userTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _userTableView.showsVerticalScrollIndicator = NO;
    }
    return _userTableView;
}

- (NSMutableArray *)modelArr {
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

@end
