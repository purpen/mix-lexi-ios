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

- (void)setupUI {
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kGuideCellIdentifier];
    UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = SCREEN_BOUNDS.size;
    self.collectionView.bounces = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    [self.collectionView setCollectionViewLayout:layout animated:YES];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return kShowCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNGuideCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGuideCellIdentifier forIndexPath:indexPath];
    BOOL isShowCloseBtn = indexPath.row == kShowCount - 1 ?: NO;
    [cell setGuideCellWithImage:[NSString stringWithFormat:@"guide_page%zd", indexPath.row] withShowCloseButton:isShowCloseBtn];
    return cell;
}



@end
