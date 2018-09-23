//
//  THNShopWindowDetailViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/8/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNShopWindowDetailViewController.h"
#import "THNFeatureTableViewCell.h"
#import "THNExploreTableViewCell.h"
#import "THNShopWindowTableViewCell.h"
#import "THNCommentTableViewCell.h"
#import "UIView+Helper.h"
#import "THNShopWindowModel.h"
#import "THNAPI.h"
#import "UITableView+Helper.h"
#import "THNCommentViewController.h"

static NSString *const kUrlShowWindowGuessLike = @"/shop_windows/guess_like";
static NSString *const kUrlShowWindowSimilar = @"/shop_windows/similar";
static NSString *const kFeatureCellIdentifier = @"kFeatureCellIdentifier";
// shopWindowCell页面的分享喜欢等被隐藏的高度
static CGFloat const shopWindowCellHiddenHeight = 50;

@interface THNShopWindowDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UITableView *commentTableView;
@property (nonatomic, assign) ShopWindowDetailCellType cellType;
@property (nonatomic, assign) NSInteger allCellCount;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopConstraint;
@property (nonatomic, assign) ShopWindowImageType imageType;
@property (nonatomic, strong) NSArray *guessLikeArray;
@property (nonatomic, strong) NSArray *similarShowWindowArray;
@property (weak, nonatomic) IBOutlet UIView *fieldBackgroundView;

@end

@implementation THNShopWindowDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
//    [self loadShowWindowGuessLikeData];

}

//猜你喜欢
- (void)loadShowWindowGuessLikeData {
    THNRequest *request = [THNAPI getWithUrlString:kUrlShowWindowGuessLike requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.guessLikeArray = result.data[@"products"];
        [self.tableView reloadRowData:2];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

- (void)loadShowWindowSimilarData {
    THNRequest *request = [THNAPI getWithUrlString:kUrlShowWindowSimilar requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [self.tableView reloadRowData:3];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}



- (void)setupUI {
    self.allCellCount = 4;
    [self.fieldBackgroundView drawCornerWithType:0 radius:self.fieldBackgroundView.viewHeight / 2];
    self.tableViewTopConstraint.constant = NAVIGATION_BAR_HEIGHT;
    self.navigationBarView.title = @"橱窗";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allCellCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    if (indexPath.row == 0) {
        self.cellType = ShopWindowDetailCellTypeMain;
        THNShopWindowTableViewCell *cell = [THNShopWindowTableViewCell viewFromXib];
        cell.imageType = ShopWindowImageTypeFive;
        cell.flag = @"shopWindowDetail";
        [cell setShopWindowModel:self.shopWindowModel];
        return cell;
    } else if (indexPath.row == 1) {
        self.cellType = ShopWindowDetailCellTypeComment;
        THNCommentTableViewCell *cell = [THNCommentTableViewCell viewFromXib];
        cell.lookCommentBlock = ^{
            THNCommentViewController *comment = [[THNCommentViewController alloc]init];
            [self.navigationController pushViewController:comment animated:YES];
        };
        return cell;
    } else if (indexPath.row == 2) {
        self.cellType = ShopWindowDetailCellTypeExplore;
        THNExploreTableViewCell *cell = [THNExploreTableViewCell viewFromXib];
        [cell setCellTypeStyle:ExploreRecommend initWithDataArray:self.guessLikeArray initWithTitle:@"猜你喜欢"];
        return cell;
    } else {
        self.cellType = ShopWindowDetailCellTypeFeature;
        THNFeatureTableViewCell *cell = [THNFeatureTableViewCell viewFromXib];
        [cell setCellTypeStyle:FeaturedLifeAesthetics initWithDataArray:nil initWithTitle:@"相关橱窗"];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.cellType) {
        case ShopWindowDetailCellTypeMain:
            return self.shopWindowCellHeight + fiveToGrowImageHeight - shopWindowCellHiddenHeight;
            break;
        case ShopWindowDetailCellTypeComment:
            return 1250;
            break;
        case ShopWindowDetailCellTypeExplore:
            return cellOtherHeight + 87;
            break;
        default:
            return kCellLifeAestheticsHeight + 90;
            break;
    }
}

@end
