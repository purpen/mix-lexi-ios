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

static CGFloat const livingHallHeaderViewHeight = 500;
static NSString *const kLivingHallRecommendCellIdentifier = @"kLivingHallRecommendCellIdentifier";

@interface THNLivingHallViewController ()

@property (nonatomic, strong) THNLivingHallHeaderView *livingHallHeaderView;
@property (nonatomic, strong) THNFeatureTableViewCell *featureCell;

@end

@implementation THNLivingHallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
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
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNLivingHallRecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLivingHallRecommendCellIdentifier forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 260;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return livingHallHeaderViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.livingHallHeaderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    self.featureCell.backgroundColor = [UIColor whiteColor];
    return self.featureCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kCellOptimalHeight * 2 + 20 + 90;
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
        [_featureCell setCellTypeStyle:FearuredOptimal];
    }
    return _featureCell;
}


@end
