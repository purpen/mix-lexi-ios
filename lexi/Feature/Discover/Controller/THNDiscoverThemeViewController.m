//
//  THNDiscoverThemeViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/9/5.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNDiscoverThemeViewController.h"
#import "THNTextCollectionView.h"
#import "THNAPI.h"
#import "THNArticleViewController.h"
#import "UIViewController+THNHud.h"

static NSString *const KUrlLifeRemember = @"/life_records/life_remember";
static NSString *const kUrlCreatorStory = @"/life_records/creator_story";
static NSString *const kUrlHandTeach = @"/life_records/hand_teach";
static NSString *const kUrlGrassNote = @"/life_records/grass_note";

@interface THNDiscoverThemeViewController () <THNMJRefreshDelegate>

@property (nonatomic, strong) THNTextCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *lifeRecords;
@property (nonatomic, strong) NSString *requestUrl;
@property(nonatomic, assign) NSInteger currentPage;

@end

@implementation THNDiscoverThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
}

- (void)loadData {
    
    switch (self.themeType) {
        case DiscoverThemeTypeCreatorStory:
            self.requestUrl = kUrlCreatorStory;
            break;
        case DiscoverThemeTypeGrassNote:
            self.requestUrl = kUrlGrassNote;
            break;
        case DiscoverThemeTypeLifeRemember:
            self.requestUrl = KUrlLifeRemember;
            break;
        case DiscoverThemeTypeHandTeach:
            self.requestUrl = kUrlHandTeach;
            break;
    }
    
    if (self.currentPage == 1) {
        [self showHud];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(self.currentPage);
    THNRequest *request = [THNAPI getWithUrlString:self.requestUrl requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [self hiddenHud];
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        [self.collectionView endFooterRefreshAndCurrentPageChange:YES];
        [self.lifeRecords addObjectsFromArray:result.data[@"life_records"]];
        self.collectionView.dataArray = self.lifeRecords;
        [self.collectionView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        [self hiddenHud];
    }];
}

- (void)setupUI {
    self.navigationBarView.title = self.navigationBarViewTitle;
    [self.view addSubview:self.collectionView];
    [self.collectionView setRefreshFooterWithClass:nil automaticallyRefresh:YES delegate:self];
    [self.collectionView resetCurrentPageNumber];
    self.currentPage = 1;

    WEAKSELF
    self.collectionView.textCollectionBlock = ^(NSInteger rid) {
        THNArticleViewController *articleVC = [[THNArticleViewController alloc]init];
        articleVC.rid = rid;
        [weakSelf.navigationController pushViewController:articleVC animated:YES];
    };
}

#pragma mark - THNMJRefreshDelegate
-(void)beginLoadingMoreDataWithCurrentPage:(NSNumber *)currentPage {
    self.currentPage = currentPage.integerValue;
    [self loadData];
}

- (THNTextCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat y = kDeviceiPhoneX ? 108 : 84;
        _collectionView = [[THNTextCollectionView alloc]initWithFrame:CGRectMake(20, y, SCREEN_WIDTH - 40, SCREEN_HEIGHT - y - 10) collectionViewLayout:layout];
    }
    return _collectionView;
}

- (NSMutableArray *)lifeRecords {
    if (!_lifeRecords) {
        _lifeRecords = [NSMutableArray array];
    }
    return _lifeRecords;
}

@end
