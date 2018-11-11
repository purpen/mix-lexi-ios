//
//  THNWindowViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/8/14.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNShopWindowViewController.h"
#import "THNSelectButtonView.h"
#import "THNMarco.h"
#import <Masonry/Masonry.h>
#import "THNMarco.h"
#import "UIImageView+WebCache.h"
#import "UIView+Helper.h"
#import "THNShopWindowTableViewCell.h"
#import <MJExtension/MJExtension.h>
#import "THNShopWindowModel.h"
#import "THNShopWindowDetailViewController.h"
#import "THNCommentViewController.h"
#import "UIViewController+THNHud.h"
#import "UIColor+Extension.h"
#import "THNLoginManager.h"
#import "THNLoginViewController.h"
#import "THNBaseNavigationController.h"

typedef NS_ENUM(NSUInteger, ShowWindowType) {
    ShowWindowTypeFollow,
    ShowWindowTypeRecommend
    
};

static CGFloat const showImageViewHeight = 256;
static NSString *const kShopWindowCellIdentifier = @"kShopWindowCellIdentifier";
static NSString *const kShopWindowsRecommend = @"/shop_windows/recommend";
static NSString *const kShopWindowsFollow = @"/shop_windows/follow";

@interface THNShopWindowViewController () <UITableViewDelegate, UITableViewDataSource, THNSelectButtonViewDelegate, THNMJRefreshDelegate>

@property (nonatomic, strong) THNSelectButtonView *selectButtonView;
@property (nonatomic, strong) UIImageView *showImageView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *showWindows;
@property (nonatomic, strong) NSMutableArray *showWindowRecommends;
@property (nonatomic, strong) NSMutableArray *showWindowFollows;
// 拼接橱窗按钮
@property (nonatomic, strong) UIButton *stitchingButton;
@property (nonatomic, assign) ShowWindowType showWindowType;
@property (nonatomic, assign) CGFloat lastContentOffset;
/// 当前页码
@property (nonatomic, assign) NSInteger currentPage;
// 之前记录的页码
@property (nonatomic, assign) NSInteger lastPage;


@end

@implementation THNShopWindowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
}

- (void)setupUI {
    self.showWindowType = ShowWindowTypeRecommend;
    self.navigationBarView.hidden = YES;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.stitchingButton];
    [self.tableView setRefreshFooterWithClass:nil automaticallyRefresh:YES delegate:self];
    [self.tableView resetCurrentPageNumber];
    self.currentPage = 1;
}

- (void)loadData {
    [self loadShopWindowData];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadShopWindowData {
    NSString *requestUrl;
    if (self.showWindowType == ShowWindowTypeFollow) {
        self.isAddWindow = YES;
        self.loadViewY = 135 + 5;
        if (self.currentPage == 1) {
            [SVProgressHUD thn_show];
        }
        requestUrl = kShopWindowsFollow;
    } else {
        if (self.currentPage == 1) {
            [self showHud];
        }
        requestUrl = kShopWindowsRecommend;
    }
  
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(self.currentPage);
    THNRequest *request = [THNAPI getWithUrlString:requestUrl requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [self hiddenHud];
        [SVProgressHUD dismiss];
        if (!result.success) {
            [SVProgressHUD showWithStatus:result.statusMessage];
            return;
        }

         NSArray *showWindowFollows = [THNShopWindowModel mj_objectArrayWithKeyValuesArray:result.data[@"shop_windows"]];
        
        [self.tableView endFooterRefreshAndCurrentPageChange:YES];

        if (self.showWindowType == ShowWindowTypeFollow) {
            if (showWindowFollows.count > 0) {
                [self.showWindowFollows addObjectsFromArray:showWindowFollows];
            } else {
                [self.tableView noMoreData];
            }

            self.showWindows = self.showWindowFollows;
        } else {
            if (showWindowFollows.count > 0) {
                [self.showWindowRecommends addObjectsFromArray:showWindowFollows];
            } else {
                [self.tableView noMoreData];
            }

            self.showWindows = self.showWindowRecommends;
        }
        
        [self.tableView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        [self.tableView endFooterRefreshAndCurrentPageChange:NO];
        [self hiddenHud];
    }];
}

#pragma UITableViewDataSource method 实现
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showWindows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNShopWindowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kShopWindowCellIdentifier forIndexPath:indexPath];
    THNShopWindowModel *shopWindowModel = self.showWindows[indexPath.row];
    [cell setShopWindowModel:shopWindowModel];
    cell.imageType = ShopWindowImageTypeThree;
    
    WEAKSELF;
    cell.contentBlock = ^{
        THNCommentViewController *comment = [[THNCommentViewController alloc]init];
        comment.rid = shopWindowModel.rid;
        comment.commentCount = shopWindowModel.comment_count;
        comment.isFromShopWindow = YES; 
        [weakSelf.navigationController pushViewController:comment animated:YES];
    };
    
    return cell;
}

#pragma UITableViewDelegate method 实现
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(self.lineView.frame))];
    [headerView addSubview:self.showImageView];
    [headerView addSubview:self.selectButtonView];
    self.lineView = [UIView initLineView:CGRectMake(0, CGRectGetMaxY(self.selectButtonView.frame), SCREEN_WIDTH, 0.5)];
    [headerView addSubview:self.lineView];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGRectGetMaxY(self.selectButtonView.frame) + 0.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    THNShopWindowDetailViewController *shopWindowDetail = [[THNShopWindowDetailViewController alloc]init];
    shopWindowDetail.shopWindowCellHeight = [tableView rectForRowAtIndexPath:indexPath].size.height;
    shopWindowDetail.shopWindowModel = [THNShopWindowModel mj_objectWithKeyValues:self.showWindows[indexPath.row]];
    [self.navigationController pushViewController:shopWindowDetail animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat maxY = kDeviceiPhoneX ? 260 - 110 : 260 - 64;
//    if (scrollView.contentOffset.y > maxY) {
//        self.navigationBarView.transparent = NO;
//        self.navigationBarView.title = @"发现生活美学";
//    } else {
//        self.navigationBarView.transparent = YES;
//        self.navigationBarView.title = @"";
//    }
    
    if (self.lastContentOffset < scrollView.contentOffset.y){
        [UIView animateWithDuration:0.5 animations:^{
            self.stitchingButton.viewY = SCREEN_HEIGHT;
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            self.stitchingButton.viewY = SCREEN_HEIGHT - 100;
        }];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.lastContentOffset = scrollView.contentOffset.y;
}

- (void)selectButtonsDidClickedAtIndex:(NSInteger)index {
    if (index == ShowWindowTypeFollow) {
        self.showWindowType = ShowWindowTypeFollow;
        if (![THNLoginManager isLogin]) {

            dispatch_async(dispatch_get_main_queue(), ^{
                THNLoginViewController *loginVC = [[THNLoginViewController alloc] init];
                THNBaseNavigationController *loginNavController = [[THNBaseNavigationController alloc] initWithRootViewController:loginVC];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:loginNavController animated:YES completion:nil];
            });
            self.showWindows = self.showWindowFollows;
            [self.tableView reloadData];
            return;
        }
        if (self.showWindowFollows.count > 0) {
            self.showWindows = self.showWindowFollows;
            [self.tableView reloadData];
            return;
        }
    } else {
        self.showWindowType = ShowWindowTypeRecommend;
        if (self.showWindowRecommends.count > 0) {
            self.showWindows = self.showWindowRecommends;
            [self.tableView reloadData];
            return;
        }
    }
    
    self.lastPage = self.currentPage;
    self.currentPage = 1;
    [self.tableView resetCurrentPageNumber];
    [self loadData];
}

#pragma mark - THNMJRefreshDelegate
- (void)beginLoadingMoreDataWithCurrentPage:(NSNumber *)currentPage {
    
    // 切换页面拿到的数据一直加载第二页数据的问题
    if (self.currentPage == 1 && self.lastPage != 0) {
        self.currentPage = self.lastPage + 1;
    } else {
        self.currentPage = currentPage.integerValue;
    }
    
    [self loadShopWindowData];
}

#pragma mark - lazy
- (THNSelectButtonView *)selectButtonView {
    if (!_selectButtonView) {
        NSArray *titleArray =  @[@"关注",@"推荐"];
        _selectButtonView = [[THNSelectButtonView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.showImageView.frame), SCREEN_WIDTH, 60) titles:titleArray initWithButtonType:ButtonTypeDefault];
        _selectButtonView.delegate = self;
        _selectButtonView.defaultShowIndex = 1;
        _selectButtonView.backgroundColor = [UIColor whiteColor];
    }
    return _selectButtonView;
}

- (UIImageView *)showImageView {
    if (!_showImageView) {
//        CGFloat showImageViewY = kDeviceiPhoneX ?  44 : 20;
        _showImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, showImageViewHeight)];
        _showImageView.contentMode = UIViewContentModeScaleAspectFill;
        _showImageView.layer.masksToBounds = YES;
        _showImageView.image = [UIImage imageNamed:@"icon_showWindow_bg"];
    }
    return _showImageView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 110) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.estimatedRowHeight = 500;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"THNShopWindowTableViewCell" bundle:nil] forCellReuseIdentifier:kShopWindowCellIdentifier];
    }
    return _tableView;
}

// 业务隐藏
//- (UIButton *)stitchingButton {
//    if (!_stitchingButton) {
//        _stitchingButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 60, SCREEN_HEIGHT - 100, 120, 40)];
//        [_stitchingButton setTitle:@"拼贴我的橱窗" forState:UIControlStateNormal];
//        [_stitchingButton setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
//        [_stitchingButton setImage:[UIImage imageNamed:@"icon_addShopWindow"] forState:UIControlStateNormal];
//        _stitchingButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
//        _stitchingButton.backgroundColor = [UIColor whiteColor];
//        _stitchingButton.layer.cornerRadius = 20;
//        _stitchingButton.layer.shadowColor = [UIColor colorWithHexString:@"#000000"].CGColor;
//        _stitchingButton.layer.shadowOffset = CGSizeMake(0, 2);
//        _stitchingButton.imageEdgeInsets = UIEdgeInsetsMake(-2, 95, 0, 0);
//        _stitchingButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
//        _stitchingButton.layer.shadowOpacity = 0.15;
//    }
//    return _stitchingButton;
//}

- (NSMutableArray *)showWindowFollows {
    if (!_showWindowFollows) {
        _showWindowFollows = [NSMutableArray array];
    }
    return _showWindowFollows;
}

- (NSMutableArray *)showWindowRecommends  {
    if (!_showWindowRecommends) {
        _showWindowRecommends = [NSMutableArray array];
    }
    return _showWindowRecommends;
}

@end
