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
#import "UIViewController+THNHud.h"

static NSString *const kUrlShowWindowGuessLike = @"/shop_windows/guess_like";
static NSString *const kUrlShowWindowSimilar = @"/shop_windows/similar";
static NSString *const kUrlShowWindowDetail = @"/shop_windows/detail";
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
@property (nonatomic, strong) NSArray *comments;
@property (weak, nonatomic) IBOutlet UIView *fieldBackgroundView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentViewheightConstraint;

@end

@implementation THNShopWindowDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
}

- (void)loadData {
    [self.dataArray addObject:@(ShopWindowDetailCellTypeMain)];
    [self loadShowWindowGuessLikeData];
}

//猜你喜欢
- (void)loadShowWindowGuessLikeData {
    [self showHud];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = self.shopWindowModel.rid;
    THNRequest *request = [THNAPI getWithUrlString:kUrlShowWindowGuessLike requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        self.guessLikeArray = result.data[@"products"];
        if (self.guessLikeArray.count > 0) {
            [self.dataArray addObject:@(ShopWindowDetailCellTypeExplore)];
        }
        [self loadShowWindowSimilarData];
        
    } failure:^(THNRequest *request, NSError *error) {
        [self hiddenHud];
    }];
}

// 相似橱窗
- (void)loadShowWindowSimilarData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = self.shopWindowModel.rid;
    THNRequest *request = [THNAPI getWithUrlString:kUrlShowWindowSimilar requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [self hiddenHud];
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        self.similarShowWindowArray = result.data[@"shop_windows"];
        if (self.similarShowWindowArray.count > 0) {
            [self.dataArray addObject:@(ShopWindowDetailCellTypeFeature)];
        }
        [self.tableView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        [self hiddenHud];
    }];
}

// 评论列表
- (void)loadShopWindowDetailData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = self.shopWindowModel.rid;
    THNRequest *request = [THNAPI getWithUrlString:kUrlShowWindowDetail requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        self.comments = result.data[@"comments"];
        
    } failure:^(THNRequest *request, NSError *error) {
    }];
}

- (void)setupUI {
    // 业务隐藏
    self.commentView.hidden = YES;
    self.commentViewheightConstraint = 0;
    [self.fieldBackgroundView drawCornerWithType:0 radius:self.fieldBackgroundView.viewHeight / 2];
    self.tableViewTopConstraint.constant = NAVIGATION_BAR_HEIGHT;
    self.navigationBarView.title = @"橱窗";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataArray[indexPath.row] integerValue]== ShopWindowDetailCellTypeMain) {
        self.cellType = ShopWindowDetailCellTypeMain;
        THNShopWindowTableViewCell *cell = [THNShopWindowTableViewCell viewFromXib];
        
        if (self.shopWindowModel.products.count == 3) {
             self.imageType = ShopWindowImageTypeThree;
        } else if (self.shopWindowModel.products.count == 5) {
            self.imageType = ShopWindowImageTypeFive;
        } else {
            self.imageType = ShopWindowImageTypeSeven;
        }
        
        cell.imageType = self.imageType;
        cell.flag = @"shopWindowDetail";
        [cell setShopWindowModel:self.shopWindowModel];
        return cell;
        
    } else if ([self.dataArray[indexPath.row] integerValue] == ShopWindowDetailCellTypeComment) {
        self.cellType = ShopWindowDetailCellTypeComment;
        THNCommentTableViewCell *cell = [THNCommentTableViewCell viewFromXib];
        cell.comments = self.comments;
        cell.lookCommentBlock = ^{
            THNCommentViewController *comment = [[THNCommentViewController alloc]init];
            [self.navigationController pushViewController:comment animated:YES];
        };
        return cell;
        
    } else if ([self.dataArray[indexPath.row] integerValue] == ShopWindowDetailCellTypeExplore) {
        self.cellType = ShopWindowDetailCellTypeExplore;
        THNExploreTableViewCell *cell = [THNExploreTableViewCell viewFromXib];
        // cell.isRewriteCellHeight = YES;
        [cell setCellTypeStyle:ExploreRecommend initWithDataArray:self.guessLikeArray initWithTitle:@"猜你喜欢"];
        return cell;
        
    } else {
        self.cellType = ShopWindowDetailCellTypeFeature;
        THNFeatureTableViewCell *cell = [THNFeatureTableViewCell viewFromXib];
        if (self.guessLikeArray.count > 0) {
            cell.isRewriteCellHeight = YES;
        }
        [cell setCellTypeStyle:FeaturedLifeAesthetics initWithDataArray:self.similarShowWindowArray initWithTitle:@"相关橱窗"];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.cellType) {
        case ShopWindowDetailCellTypeMain:

            switch (self.imageType) {
                case ShopWindowImageTypeThree:
                    return  180 + threeImageHeight + [self getSizeByString:self.shopWindowModel.des AndFontSize:[UIFont fontWithName:@"PingFangSC-Regular" size:14]];
                case ShopWindowImageTypeFive:
                    return  180 + threeImageHeight + fiveToGrowImageHeight + [self getSizeByString:self.shopWindowModel.des AndFontSize:[UIFont fontWithName:@"PingFangSC-Regular" size:14]];
                default:
                    return  180 + threeImageHeight + sevenToGrowImageHeight + [self getSizeByString:self.shopWindowModel.des AndFontSize:[UIFont fontWithName:@"PingFangSC-Regular" size:14]];
            }
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

//获取字符串高度的方法
- (CGFloat)getSizeByString:(NSString*)string AndFontSize:(UIFont *)font
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 36, 999) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
    return size.height;
}

#pragma mark - lazy
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
