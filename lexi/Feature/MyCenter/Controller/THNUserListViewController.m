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

static NSString *const kUserTableViewCellId = @"kUserTableViewCellId";
static NSString *const kTitleLikeGoods = @"喜欢该商品的人";

@interface THNUserListViewController () <UITableViewDelegate, UITableViewDataSource>

/// 类型
@property (nonatomic, assign) THNUserListType listType;
/// id
@property (nonatomic, strong) NSString *requestId;
/// 用户列表
@property (nonatomic, strong) UITableView *userTableView;
/// 用户数据
@property (nonatomic, strong) NSMutableArray *modelArr;

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
    [self thn_getUserDataWithType:self.listType];
}

#pragma mark - network
- (void)thn_getUserDataWithType:(THNUserListType)type {
    switch (type) {
        case THNUserListTypeLikeGoods: {
            [THNGoodsManager getLikeGoodsUserDataWithGoodsId:self.requestId params:@{} completion:^(NSArray *userData, NSError *error) {
                [self.modelArr addObjectsFromArray:userData];
                [self.userTableView reloadData];
            }];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - setup UI
- (void)setupUI {
    [self.view addSubview:self.userTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setTitleWithType:self.listType];
}

- (void)thn_setTitleWithType:(THNUserListType)type {
    switch (type) {
        case THNUserListTypeLikeGoods:
            self.navigationBarView.title = kTitleLikeGoods;
            break;
            
        default:
            break;
    }
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
