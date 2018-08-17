//
//  THNMyCenterViewController.m
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNMyCenterViewController.h"
#import "THNShareViewController.h"
#import "THNSignInViewController.h"
#import "THNBaseNavigationController.h"
#import "THNMyCenterHeaderView.h"
#import "THNLikedGoodsTableViewCell.h"
#import "THNLikedWindowTableViewCell.h"
#import "THNLikedWindowViewController.h"
#import "THNLikedGoodsViewController.h"
#import "THNUserManager.h"
#import "THNApplyStoreViewController.h"

@interface THNMyCenterViewController () <THNNavigationBarViewDelegate, THNMyCenterHeaderViewDelegate>

@property (nonatomic, strong) THNMyCenterHeaderView *headerView;

@end

@implementation THNMyCenterViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [THNUserManager getUserCenterCompletion:^(THNUserModel *model, NSError *error) {
        [self.headerView thn_setUserInfoModel:model];
    }];
    
    self.separatorStyle = THNTableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = self.headerView;
    
    [self thn_setLikedGoodsTableViewCell];
    [self thn_setLikedWindowTableViewCell];
}

- (void)thn_setLikedGoodsTableViewCell {
    THNTableViewSections *sections = [THNTableViewSections initSectionsWithHeaderTitle:@"喜欢的商品" moreCompletion:^{
        THNLikedGoodsViewController *likedGoodsVC = [[THNLikedGoodsViewController alloc] init];
        [self.navigationController pushViewController:likedGoodsVC animated:YES];
    }];
    
    THNTableViewCells *cells = [THNTableViewCells initWithCellType:(THNTableViewCellTypeLikedGoods) didSelectedItem:^(NSString *ids) {
        NSLog(@"商品ID ===== %@", ids);
    }];
    
    cells.height = 100.0;
    sections.dataCells = [@[cells] mutableCopy];
    [self.dataSections addObject:sections];
}

- (void)thn_setLikedWindowTableViewCell {
    THNTableViewSections *sections = [THNTableViewSections initSectionsWithHeaderTitle:@"喜欢的橱窗" moreCompletion:^{
        THNLikedWindowViewController *likedWindowVC = [[THNLikedWindowViewController alloc] init];
        [self.navigationController pushViewController:likedWindowVC animated:YES];
    }];
    
    THNTableViewCells *cells = [THNTableViewCells initWithCellType:(THNTableViewCellTypeLikedWindow) didSelectedItem:^(NSString *ids) {
        NSLog(@"橱窗ID ===== %@", ids);
    }];
    
    cells.height = 162.0;
    sections.dataCells = [@[cells] mutableCopy];
    [self.dataSections addObject:sections];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNTableViewSections *sections = self.dataSections[indexPath.section];
    THNTableViewCells *cells = sections.dataCells[indexPath.row];

    if (cells.cellType == THNTableViewCellTypeLikedGoods) {
        THNLikedGoodsTableViewCell *likedGoodsCell = [THNLikedGoodsTableViewCell initGoodsCellWithTableView:tableView
                                                                                                  cellStyle:(UITableViewCellStyleDefault)];
        cells.likedGoodsCell = likedGoodsCell;
        likedGoodsCell.cell = cells;
        
        return likedGoodsCell;
    
    } else if (cells.cellType == THNTableViewCellTypeLikedWindow) {
        THNLikedWindowTableViewCell *likedWindowCell = [THNLikedWindowTableViewCell initWindowCellWithTableView:tableView
                                                                                                      cellStyle:(UITableViewCellStyleDefault)];
        cells.likedWindowCell = likedWindowCell;
        likedWindowCell.cell = cells;

        return likedWindowCell;
    }
    
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"------- %f", scrollView.contentOffset.y);
    if (scrollView.contentOffset.y >= 60) {
        self.navigationBarView.title = @"乐喜客户端";
    } else if (scrollView.contentOffset.y < 60) {
        self.navigationBarView.title = @"";
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.delegate = self;
    [self.navigationBarView setNavigationRightButtonOfImageNamedArray:@[@"icon_nav_share_gray",
                                                                        @"icon_setting_gray"]];
}

#pragma mark - custom delegate
- (void)thn_selectedButtonType:(THNHeaderViewSelectedType)type {
    switch (type) {
        case THNHeaderViewSelectedTypeLiked:{
            [SVProgressHUD showInfoWithStatus:@"已喜欢"];
        }
            break;
        case THNHeaderViewSelectedTypeCollect:{
            [SVProgressHUD showInfoWithStatus:@"收藏"];
        }
            break;
        case THNHeaderViewSelectedTypeStore:{
            [SVProgressHUD showInfoWithStatus:@"设计馆"];
        }
            break;
        case THNHeaderViewSelectedTypeDynamic:{
            [SVProgressHUD showInfoWithStatus:@"动态"];
        }
            break;
        case THNHeaderViewSelectedTypeActivity:{
            [SVProgressHUD showInfoWithStatus:@"活动"];
        }
            break;
        case THNHeaderViewSelectedTypeOrder:{
            [SVProgressHUD showInfoWithStatus:@"订单"];
        }
            break;
        case THNHeaderViewSelectedTypeCoupon:{
            [SVProgressHUD showInfoWithStatus:@"优惠券"];
        }
            break;
        case THNHeaderViewSelectedTypeService:{
            [SVProgressHUD showInfoWithStatus:@"客服"];
        }
            break;
    }
}

- (void)didNavigationRightButtonOfIndex:(NSInteger)index {
    if (index == 0) {
        [SVProgressHUD showInfoWithStatus:@"分享"];
        THNApplyStoreViewController *applyVC = [[THNApplyStoreViewController alloc] init];
        [self.navigationController pushViewController:applyVC animated:YES];
        
    } else if (index == 1) {
        [SVProgressHUD showInfoWithStatus:@"设置"];
    }
}

#pragma mark - getters and setters
- (THNMyCenterHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[THNMyCenterHeaderView alloc] init];
        _headerView.delegate = self;
    }
    return _headerView;
}

@end
