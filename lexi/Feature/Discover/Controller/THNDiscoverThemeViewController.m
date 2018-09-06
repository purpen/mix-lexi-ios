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

static NSString *const KUrlLifeRemember = @"/life_records/life_remember";

@interface THNDiscoverThemeViewController ()

@property (nonatomic, strong) THNTextCollectionView *collectionView;
@property (nonatomic, strong) NSArray *lifeRecords;

@end

@implementation THNDiscoverThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadLifeRememberData];
    [self setupUI];
}

- (void)loadLifeRememberData {
    THNRequest *request = [THNAPI getWithUrlString:KUrlLifeRemember requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.lifeRecords = result.data[@"life_records"];
        self.collectionView.dataArray = self.lifeRecords;
        [self.collectionView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

- (void)setupUI {
    [self.view addSubview:self.collectionView];
}

- (THNTextCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[THNTextCollectionView alloc]initWithFrame:CGRectMake(20, NAVIGATION_BAR_HEIGHT + 20, SCREEN_WIDTH - 40, SCREEN_HEIGHT) collectionViewLayout:layout];
    }
    return _collectionView;
}

@end
