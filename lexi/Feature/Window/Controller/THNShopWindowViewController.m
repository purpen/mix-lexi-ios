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
#import "UIImageView+WebImage.h"
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
#import "THNReleaseWindowViewController.h"
#import "THNShareViewController.h"
#import "THNShopWindowModel.h"
#import "THNUserCenterViewController.h"

typedef NS_ENUM(NSUInteger, ShowWindowType) {
    ShowWindowTypeFollow,
    ShowWindowTypeRecommend
    
};

static CGFloat const showImageViewHeight = 181;
static NSString *const kShopWindowCellIdentifier = @"kShopWindowCellIdentifier";
static NSString *const kShopWindowsRecommend = @"/shop_windows/recommend";
static NSString *const kShopWindowsFollow = @"/shop_windows/follow";
///
static NSString *const kWindowHeadImageUrl = @"https://static.moebeast.com/image/static/shop_window_head.jpg";

@interface THNShopWindowViewController () <
UITableViewDelegate,
UITableViewDataSource,
THNSelectButtonViewDelegate,
THNMJRefreshDelegate,
THNShopWindowTableViewCellDelegate
>

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
@property (nonatomic, strong) NSIndexPath *selectCellIndexPath;
@property (nonatomic, strong) UIView *windowDesLabelsView;
@property (nonatomic, assign) BOOL isNeedsHud;

@end

@implementation THNShopWindowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLikeButtonStatus:) name:kChangeStatusWindowSuccess object:nil];
    [self setupUI];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.stitchingButton.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.stitchingButton.hidden = YES;
    [self hiddenHud];
}

- (void)setupUI {
    self.showWindowType = ShowWindowTypeRecommend;
    self.navigationBarView.hidden = YES;
    [self.view addSubview:self.tableView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.stitchingButton];
    [self.tableView setRefreshFooterWithClass:nil automaticallyRefresh:YES delegate:self];
    [self.tableView setRefreshHeaderWithClass:nil beginRefresh:NO animation:NO delegate:self];
    [self.tableView resetCurrentPageNumber];
    self.currentPage = 1;
}

- (void)loadData {
    self.isNeedsHud = YES;
    [self loadShopWindowData];
}

- (void)changeLikeButtonStatus:(NSNotification *)notification {
    THNShopWindowTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.selectCellIndexPath];
    BOOL isLike = [notification.userInfo[@"isLike"] boolValue];
    [cell layoutLikeButtonStatus:isLike];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pushLoginVC {
    if (![THNLoginManager isLogin]) {
        [[THNLoginManager sharedManager] openUserLoginController];
        return;
    }
}

- (void)loadShopWindowData {
    NSString *requestUrl;
    if (self.showWindowType == ShowWindowTypeFollow) {
        self.isAddWindow = YES;
        self.loadViewY = 135 + 5;
        if (self.isNeedsHud) {
            [SVProgressHUD thn_show];
        }
        requestUrl = kShopWindowsFollow;
    } else {
        if (self.isNeedsHud) {
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
        [self.tableView endHeaderRefresh];
//        THNLog(@"首页橱窗列表：%@", [NSString jsonStringWithObject:result.responseDict]);
        if (!result.success) {
            [SVProgressHUD showWithStatus:result.statusMessage];
            return;
        }

         NSArray *showWindowFollows = [THNShopWindowModel mj_objectArrayWithKeyValuesArray:result.data[@"shop_windows"]];
        
        [self.tableView endFooterRefreshAndCurrentPageChange:YES];

        if (self.showWindowType == ShowWindowTypeFollow) {
            [self.showWindowFollows addObjectsFromArray:showWindowFollows];
            self.showWindows = self.showWindowFollows;
        } else {
            [self.showWindowRecommends addObjectsFromArray:showWindowFollows];
            self.showWindows = self.showWindowRecommends;
        }
        
        if (![result.data[@"next"] boolValue] && self.showWindows.count != 0) {
            
            [self.tableView noMoreData];
        }
        
        [self.tableView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        [self.tableView endFooterRefreshAndCurrentPageChange:NO];
        [self.tableView endHeaderRefresh];
        [self hiddenHud];
    }];
}


- (void)pushReleaseWindowVC {
    if (![THNLoginManager isLogin]) {
        [self pushLoginVC];
        return;
    }
    THNReleaseWindowViewController *releaseWindowVC = [[THNReleaseWindowViewController alloc]init];
    [self.navigationController pushViewController:releaseWindowVC animated:YES];
}

#pragma UITableViewDataSource method 实现
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showWindows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNShopWindowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kShopWindowCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    THNShopWindowModel *shopWindowModel = self.showWindows[indexPath.row];
    [cell setShopWindowModel:shopWindowModel];
    cell.imageType = ShopWindowImageTypeThree;
    return cell;
}

#pragma UITableViewDelegate method 实现
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(self.lineView.frame))];
    [headerView addSubview:self.showImageView];
    [headerView addSubview:self.windowDesLabelsView];
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
    self.selectCellIndexPath = indexPath;
    shopWindowDetail.shopWindowCellHeight = [tableView rectForRowAtIndexPath:indexPath].size.height;
    shopWindowDetail.shopWindowModel = [THNShopWindowModel mj_objectWithKeyValues:self.showWindows[indexPath.row]];
    [self.navigationController pushViewController:shopWindowDetail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNShopWindowModel *shopWindowModel = self.showWindows[indexPath.row];
    return shopWindowModel.cellHeight;
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
            CGFloat spacing= kDeviceiPhoneX ? 134 : 100;
            self.stitchingButton.viewY = SCREEN_HEIGHT - spacing;
        }];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:THNHomeVCDidScrollView object:nil userInfo:@{kScrollDistance : @(scrollView.contentOffset.y - self.lastContentOffset)}];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.lastContentOffset = scrollView.contentOffset.y;
}

- (void)selectButtonsDidClickedAtIndex:(NSInteger)index {
    if (index == ShowWindowTypeFollow) {
        self.showWindowType = ShowWindowTypeFollow;
        if (![THNLoginManager isLogin]) {

            [self pushLoginVC];
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
    
    self.isNeedsHud = NO;
    [self loadShopWindowData];
}

- (void)beginRefreshing {
    self.currentPage = 1;
    self.isNeedsHud = NO;
    
    if (self.showWindowType == ShowWindowTypeFollow) {
        [self.showWindowFollows removeAllObjects];
    } else {
        [self.showWindowRecommends removeAllObjects];
    }
    
    [self loadShopWindowData];
}

#pragma mark - THNShopWindowTableViewCellDelegate
- (void)lookContentBlock:(THNShopWindowModel *)shopWindowModel {
    THNCommentViewController *comment = [[THNCommentViewController alloc]init];
    comment.rid = shopWindowModel.rid;
    comment.commentCount = shopWindowModel.comment_count;
    comment.isFromShopWindow = YES;
    [self.navigationController pushViewController:comment animated:YES];
}

- (void)showWindowShare:(THNShopWindowModel *)shopWindowModel {
    if (!shopWindowModel.rid.length) return;
    THNShareViewController *shareVC = [[THNShareViewController alloc] initWithType:(THNSharePosterTypeWindow)
                                                                         requestId:shopWindowModel.rid];
    [shareVC shareObjectWithTitle:shopWindowModel.title
                            descr:shopWindowModel.des
                        thumImage:shopWindowModel.product_covers[0]
                           webUrl:[kShareShowWindowPrefix stringByAppendingString:shopWindowModel.rid]];
    shareVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:shareVC animated:NO completion:nil];
}

- (void)clickAvatarImageView:(NSString *)userRid {
    THNUserCenterViewController *userCentenVC = [[THNUserCenterViewController alloc]initWithUserId:userRid];
    [self.navigationController pushViewController:userCentenVC animated:YES];
}

- (void)refreshDesLabelContent:(THNShopWindowTableViewCell *)cell {
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    THNShopWindowModel *shopWindowModel = self.showWindows[indexPath.row];
    shopWindowModel.isOpening = !shopWindowModel.isOpening;
    [self.tableView reloadData];
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
        [_showImageView sd_setImageWithURL:[NSURL URLWithString:@"https://static.moebeast.com/image/static/shop_window_head.jpg"]];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = self.showImageView.bounds;
        gradientLayer.colors =  @[(__bridge id)[UIColor colorWithHexString:@"000000" alpha:0.3].CGColor,
                                  (__bridge id)[UIColor colorWithHexString:@"000000" alpha:0].CGColor];
        gradientLayer.locations = @[@(0.0), @(1)];
        [_showImageView.layer addSublayer:gradientLayer];
    }
    return _showImageView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 110) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"F7F9FB"];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"THNShopWindowTableViewCell" bundle:nil] forCellReuseIdentifier:kShopWindowCellIdentifier];
    }
    return _tableView;
}

- (UIButton *)stitchingButton {
    if (!_stitchingButton) {
        CGFloat spacing= kDeviceiPhoneX ? 134 : 100;
        _stitchingButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 60, SCREEN_HEIGHT - spacing, 120, 40)];
        [_stitchingButton setTitle:@"拼贴我的橱窗" forState:UIControlStateNormal];
        [_stitchingButton setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [_stitchingButton setImage:[UIImage imageNamed:@"icon_addShopWindow"] forState:UIControlStateNormal];
        _stitchingButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        _stitchingButton.backgroundColor = [UIColor whiteColor];
        _stitchingButton.layer.cornerRadius = 20;
        _stitchingButton.layer.shadowColor = [UIColor colorWithHexString:@"#000000"].CGColor;
        _stitchingButton.layer.shadowOffset = CGSizeMake(0, 2);
        _stitchingButton.imageEdgeInsets = UIEdgeInsetsMake(-2, 95, 0, 0);
        _stitchingButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
        _stitchingButton.layer.shadowOpacity = 0.15;
        [_stitchingButton addTarget:self action:@selector(pushReleaseWindowVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stitchingButton;
}

- (UIView *)windowDesLabelsView {
    if (!_windowDesLabelsView) {
        _windowDesLabelsView = [[UIView alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 70)];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 0, SCREEN_WIDTH, 20)];
        titleLabel.text = @"发现生活美学";
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:20];
        UILabel *secondTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, CGRectGetMaxY(titleLabel.frame) + 15, SCREEN_WIDTH, 14)];
        secondTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        secondTitleLabel.text = @"发掘好物，品位生活";
        UILabel *threeTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, CGRectGetMaxY(secondTitleLabel.frame) + 5, SCREEN_WIDTH, 14)];
        threeTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        threeTitleLabel.text = @"寻找搭配灵感,塑造自己的独特风格";
        titleLabel.textColor = [UIColor whiteColor];
        secondTitleLabel.textColor = [UIColor whiteColor];
        threeTitleLabel.textColor = [UIColor whiteColor];
        [_windowDesLabelsView addSubview:titleLabel];
        [_windowDesLabelsView addSubview:secondTitleLabel];
        [_windowDesLabelsView addSubview:threeTitleLabel];
        
    }
    return _windowDesLabelsView;
}

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
