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

static CGFloat const showImageViewHeight = 256;
static NSString *const kShopWindowCellIdentifier = @"kShopWindowCellIdentifier";

@interface THNShopWindowViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) THNSelectButtonView *selectButtonView;
@property (nonatomic, strong) UIImageView *showImageView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *showWindows;
// 拼接橱窗按钮
@property (nonatomic, strong) UIButton *stitchingButton;

@end

@implementation THNShopWindowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadShopWindowData];
}

- (void)loadShopWindowData {
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"showWindow" ofType:@"json"]];
    NSDictionary *result = [data mj_JSONObject];
    self.showWindows = result[@"data"][@"shop_windows"];
}

- (void)setupUI {
    self.navigationBarView.hidden = YES;
    [self.view addSubview:self.tableView];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma UITableViewDataSource method 实现
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showWindows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNShopWindowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kShopWindowCellIdentifier forIndexPath:indexPath];
    THNShopWindowModel *shopWindowModel = [THNShopWindowModel mj_objectWithKeyValues:self.showWindows[indexPath.row]];
    [cell setShopWindowModel:shopWindowModel];
    cell.imageType = ShopWindowImageTypeThree;
    
    cell.contentBlock = ^{
        THNCommentViewController *comment = [[THNCommentViewController alloc]init];
        comment.rid = shopWindowModel.rid;
        [self.navigationController pushViewController:comment animated:YES];
    };
    
    return cell;
}

#pragma UITableViewDelegate method 实现
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, -NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, CGRectGetMaxY(self.lineView.frame))];
    [headerView addSubview:self.showImageView];
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:@"http://kg.erp.taihuoniao.com/static/img/default-logo-540x540.png"]placeholderImage:[UIImage imageNamed:@"default_image_place"]];
    [headerView addSubview:self.selectButtonView];
    self.lineView = [UIView initLineView:CGRectMake(0, CGRectGetMaxY(self.selectButtonView.frame), SCREEN_WIDTH, 0.5)];
    [headerView addSubview:self.lineView ];
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

#pragma mark - lazy
- (THNSelectButtonView *)selectButtonView {
    if (!_selectButtonView) {
        NSArray *titleArray =  @[@"关注",@"推荐"];
        _selectButtonView = [[THNSelectButtonView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.showImageView.frame), SCREEN_WIDTH, 60) titles:titleArray initWithButtonType:ButtonTypeDefault];
        _selectButtonView.backgroundColor = [UIColor whiteColor];
    }
    return _selectButtonView;
}

- (UIImageView *)showImageView {
    if (!_showImageView) {
        CGFloat showImageViewY = kDeviceiPhoneX ?  44 : 20;
        _showImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -showImageViewY, SCREEN_WIDTH, showImageViewHeight)];
        _showImageView.contentMode = UIViewContentModeScaleAspectFill;
        _showImageView.layer.masksToBounds = YES;
        UIButton * backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, 60, 60)];
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [backButton setImage:[UIImage imageNamed:@"icon_back_gray"] forState:UIControlStateNormal];
        _showImageView.userInteractionEnabled = YES;
        [_showImageView addSubview:backButton];
    }
    return _showImageView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.lineView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.lineView.frame)) style:UITableViewStyleGrouped];
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

- (UIButton *)stitchingButton {
    if (!_stitchingButton) {
        _stitchingButton = [[UIButton alloc]init];
    }
    return _stitchingButton;
}

@end
