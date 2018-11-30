//
//  THNGuideCollectionViewController.m
//  lexi
//
//  Created by rhp on 2018/11/29.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGuideCollectionViewController.h"
#import "THNMarco.h"
#import "THNGuideCollectionViewCell.h"

static NSInteger const kShowCount = 4;

@interface THNGuideCollectionViewController ()

@end

@implementation THNGuideCollectionViewController

static NSString * const kGuideCellIdentifier = @"guideCellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (instancetype)init {
    UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = SCREEN_BOUNDS.size;
    self.collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    [self.collectionView registerClass:[THNGuideCollectionViewCell class] forCellWithReuseIdentifier:kGuideCellIdentifier];
    self.collectionView.bounces = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    /**
     1.设置背景色
     2.由于糊上了一层collectionView所以在Appdelegate中设置window的背景色被collectionView覆盖.此时collectionView的颜色要重新设置
     */
    self.collectionView.backgroundColor = [UIColor whiteColor];
    return self;
}

- (void)setupUI {

}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return kShowCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNGuideCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGuideCellIdentifier forIndexPath:indexPath];
    BOOL isShowCloseBtn = indexPath.row != kShowCount - 1 ?: NO;
    NSString *imagePrefix = kDeviceiPhoneX ? @"guide_x_page_" : @"guide_page_";
    [cell setGuideCellWithImage:[NSString stringWithFormat:@"%@%zd",imagePrefix, indexPath.row] withShowCloseButton:isShowCloseBtn];
    return cell;
}

@end
