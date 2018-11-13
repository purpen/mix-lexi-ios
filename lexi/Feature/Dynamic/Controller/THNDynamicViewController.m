//
//  THNDynamicViewController.m
//  lexi
//
//  Created by FLYang on 2018/11/12.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNDynamicViewController.h"
#import "THNDynamicHeaderView.h"
#import "THNDynamicUserInfoTableViewCell.h"
#import "THNDynamicImagesTableViewCell.h"
#import "THNDynamicContentTableViewCell.h"
#import "THNDynamicActionTableViewCell.h"
#import "UITableViewCell+DealContent.h"
#import "THNTableViewFooterView.h"
#import "THNShopWindowDetailViewController.h"
#import "THNShopWindowModel.h"

static NSString *const kTitleDynamic    = @"动态";
/// url
static NSString *const kURLMyDynamic    = @"/users/user_dynamic";
static NSString *const kURLUserDynamic  = @"/users/other_user_dynamic";
/// key
static NSString *const kKeyUid  = @"uid";
static NSString *const kKeyPage = @"page";

@interface THNDynamicViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *dynamicTableView;
@property (nonatomic, strong) THNDynamicHeaderView *headerView;
@property (nonatomic, strong) THNTableViewFooterView *footerView;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *dynamicArr;

@end

@implementation THNDynamicViewController

- (instancetype)initWithUserId:(NSString *)uid {
    self = [super init];
    if (self) {
        self.userId = uid;
        self.headerView.viewType = [self thn_getHeaderViewType];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self requestUserDynamicData];
}

#pragma mark - network
- (void)requestUserDynamicData {
    [SVProgressHUD thn_show];
    
    THNRequest *request = [THNAPI getWithUrlString:[self thn_getRequestUrl]
                                 requestDictionary:[self thn_getRequestParams]
                                          delegate:nil];
    
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.isSuccess) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return ;
        }
        
        [self thn_setRequestResultData:result.data];
        [self.dynamicTableView reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - private methods
- (void)thn_setRequestResultData:(NSDictionary *)data {
    THNDynamicModel *model = [[THNDynamicModel alloc] initWithDictionary:data];
    
    [self.headerView thn_setDynamicUserModel:model];
    [self.dynamicArr addObjectsFromArray:model.lines];
    [self thn_showTableViewDefaultView];
}

- (void)thn_showTableViewDefaultView {
    BOOL isShow = self.dynamicArr.count == 0;
    
    self.dynamicTableView.tableFooterView = isShow? self.footerView : [UIView new];
}

- (NSString *)thn_getRequestUrl {
    return self.userId.length ? kURLUserDynamic : kURLMyDynamic;
}

- (NSDictionary *)thn_getRequestParams {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(self.currentPage) forKey:kKeyPage];
    
    if (self.userId.length) {
        [params setObject:self.userId forKey:kKeyUid];
    }
    
    return [params copy];
}

- (THNDynamicHeaderViewType)thn_getHeaderViewType {
    return self.userId.length ? THNDynamicHeaderViewTypeOther : THNDynamicHeaderViewTypeDefault;
}

/**
 打开橱窗主页
 */
- (void)thn_openWindowDetailContollerWithModel:(THNDynamicModelLines *)model {
    if (!model.rid) return;
    
    THNShopWindowModel *shopWindowModel = [THNShopWindowModel mj_objectWithKeyValues:[model toDictionary]];
    
    THNShopWindowDetailViewController *shopWindowDetail = [[THNShopWindowDetailViewController alloc] init];
    shopWindowDetail.shopWindowModel = shopWindowModel;
    [self.navigationController pushViewController:shopWindowDetail animated:YES];
}

#pragma mark - setup UI
- (void)setupUI {
    [self.view addSubview:self.dynamicTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.title = kTitleDynamic;
}

#pragma mark - tableView datasource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dynamicArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 65.0f;
        
    } else if (indexPath.row == 1) {
        return (SCREEN_WIDTH - 60) / 3;
        
    } else if (indexPath.row == 2) {
        if (self.dynamicArr.count) {
            THNDynamicModelLines *model = self.dynamicArr[indexPath.section];
            return [UITableViewCell heightWithText:model.descriptionField fontSize:13 spacing:7 width:SCREEN_WIDTH - 40] + 55;
        }
        
        return 44.0f;
    }
    
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNDynamicModelLines *model = (THNDynamicModelLines *)self.dynamicArr[indexPath.section];
    
    if (indexPath.row == 0) {
        THNDynamicUserInfoTableViewCell *userInfoCell = [THNDynamicUserInfoTableViewCell initDynamicUserInfoCellWithTableView:tableView];
        if (self.dynamicArr.count) {
            [userInfoCell thn_setDynamicUserInfoWithModel:model];
        }
        
        return userInfoCell;
    
    } else if (indexPath.row == 1) {
        THNDynamicImagesTableViewCell *imagesCell = [THNDynamicImagesTableViewCell initDynamicImagesCellWithTableView:tableView];
        if (self.dynamicArr.count) {
            [imagesCell thn_setDynamicImagesWithModel:model];
        }
        
        return imagesCell;
        
    } else if (indexPath.row == 2) {
        THNDynamicContentTableViewCell *contentCell = [THNDynamicContentTableViewCell initDynamicContentCellWithTableView:tableView];
        if (self.dynamicArr.count) {
            [contentCell thn_setDynamicContentWithModel:model];
        }
        
        return contentCell;
        
    } else if (indexPath.row == 3) {
        THNDynamicActionTableViewCell *actionCell = [THNDynamicActionTableViewCell initDynamicActionCellWithTableView:tableView];
        if (self.dynamicArr.count) {
            [actionCell thn_setDynamicAcitonWithModel:model];
        }
        
        return actionCell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dynamicArr.count) {
        [self thn_openWindowDetailContollerWithModel:(THNDynamicModelLines *)self.dynamicArr[indexPath.section]];
    }
}

#pragma mark - getters and setters
- (UITableView *)dynamicTableView {
    if (!_dynamicTableView) {
        _dynamicTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                                                         style:(UITableViewStylePlain)];
        _dynamicTableView.delegate = self;
        _dynamicTableView.dataSource = self;
        _dynamicTableView.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
        _dynamicTableView.contentInset = UIEdgeInsetsMake(44, 0, 15, 0);
        _dynamicTableView.tableFooterView = [UIView new];
        _dynamicTableView.tableHeaderView = self.headerView;
        _dynamicTableView.showsVerticalScrollIndicator = NO;
        _dynamicTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _dynamicTableView;
}

- (THNDynamicHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[THNDynamicHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 206)];
    }
    return _headerView;
}

- (THNTableViewFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[THNTableViewFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
        [_footerView setSubHintLabelTextWithType:(THNHeaderViewSelectedTypeDynamic)];
    }
    return _footerView;
}

- (NSMutableArray *)dynamicArr {
    if (!_dynamicArr) {
        _dynamicArr = [NSMutableArray array];
    }
    return _dynamicArr;
}

@end
