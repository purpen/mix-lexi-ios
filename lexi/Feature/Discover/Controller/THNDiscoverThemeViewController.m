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

@interface THNDiscoverThemeViewController ()

@property (nonatomic, strong) THNTextCollectionView *collectionView;
@property (nonatomic, strong) NSArray *lifeRecords;
@property (nonatomic, strong) NSString *requestUrl;

@end

@implementation THNDiscoverThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self setupUI];
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
    [self showHud];
    THNRequest *request = [THNAPI getWithUrlString:self.requestUrl requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [self hiddenHud];
        if (!result.success) {
            [SVProgressHUD showInfoWithStatus:result.statusMessage];
            return;
        }
        
        self.lifeRecords = result.data[@"life_records"];
        self.collectionView.dataArray = self.lifeRecords;
        [self.collectionView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        [self hiddenHud];
    }];
}

- (void)setupUI {
    self.navigationBarView.title = self.navigationBarViewTitle;
    [self.view addSubview:self.collectionView];

    WEAKSELF
    self.collectionView.textCollectionBlock = ^(NSInteger rid) {
        THNArticleViewController *articleVC = [[THNArticleViewController alloc]init];
        articleVC.rid = rid;
        [weakSelf.navigationController pushViewController:articleVC animated:YES];
    };
}

- (THNTextCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat y = kDeviceiPhoneX ? 108 : 84;
        _collectionView = [[THNTextCollectionView alloc]initWithFrame:CGRectMake(20, y, SCREEN_WIDTH - 40, SCREEN_HEIGHT - y - 10) collectionViewLayout:layout];
    }
    return _collectionView;
}

@end
