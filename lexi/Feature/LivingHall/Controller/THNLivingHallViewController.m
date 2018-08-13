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
@property (nonatomic, assign) CGFloat recommenLabelHegiht;

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
    self.tableView.estimatedRowHeight = 400;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNLivingHallRecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLivingHallRecommendCellIdentifier forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
            cell.recommenDationLabel.text = @"店主定期推出新系列，每个系列有各自的主题";
            break;
        case 1:
            cell.recommenDationLabel.text = @"店主定期推出新系列，每个系列有各自的主题，杀害空间啊大哭爱睡觉都看见考虑";
            break;
        default:
            cell.recommenDationLabel.text = @"我只有二行文字我只有一行文字我只有一行文字我只有一行文字我只有一我只有二行文字我只有一行文字我只有一行文字我只有一行文字我只有一我只有二行文字我只有一行文字我只有一行文字我只有一行文字我只有一我只有二行文字我只有一行文字我只有一行文字我只有一行文字我只有一店主定期推出新系列，每个系列有各自的主题，杀害空间啊大哭爱睡觉都看见考虑";
            break;
    }
    return cell;
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
        [_featureCell setCellTypeStyle:FearuredOptimal initWithDataArray:nil initWithTitle:@"种草清单"];
    }
    return _featureCell;
}


@end
