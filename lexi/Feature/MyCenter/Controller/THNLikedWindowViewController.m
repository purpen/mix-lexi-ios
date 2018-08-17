//
//  THNLikedWindowViewController.m
//  lexi
//
//  Created by FLYang on 2018/8/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLikedWindowViewController.h"
#import "THNLikedWindowCollectionViewCell.h"

static NSString *const kCollectionViewCellId = @"THNLikedWindowCollectionViewCellId";

@interface THNLikedWindowViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

/// 橱窗列表
@property (nonatomic, strong) UICollectionView *windowCollectionView;
/// 橱窗数据
@property (nonatomic, strong) NSMutableArray *windowArray;

@end

@implementation THNLikedWindowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - collectionView delegate & dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //    return self.windowArray.count;
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNLikedWindowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellId
                                                                                       forIndexPath:indexPath];
    if (self.windowArray.count) {
//        [cell thn_setwindowModel:self.windowArray[indexPath.row]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"打开橱窗 == %zi", indexPath.row]];
}

#pragma mark - setup UI
- (void)setupUI {
    [self.view addSubview:self.windowCollectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.title = kTitleLikedWindow;
}

#pragma mark - getters and setters
- (UICollectionView *)windowCollectionView {
    if (!_windowCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, 248);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _windowCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
        _windowCollectionView.backgroundColor = [UIColor whiteColor];
        _windowCollectionView.contentInset = UIEdgeInsetsMake(STATUS_BAR_HEIGHT, 0, 20, 0);
        _windowCollectionView.delegate = self;
        _windowCollectionView.dataSource = self;
        _windowCollectionView.showsVerticalScrollIndicator = NO;
        [_windowCollectionView registerClass:[THNLikedWindowCollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCellId];
    }
    return _windowCollectionView;
}

- (NSMutableArray *)windowArray {
    if (!_windowArray) {
        _windowArray = [NSMutableArray array];
    }
    return _windowArray;
}

@end
