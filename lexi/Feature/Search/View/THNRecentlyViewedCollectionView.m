//
//  THNRecentlyViewedCollectionView.m
//  lexi
//
//  Created by HongpingRao on 2018/9/27.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNRecentlyViewedCollectionView.h"
#import "THNProductModel.h"
#import "THNProductCollectionViewCell.h"

static NSString *const kSearchProductCellIdentifier = @"kSearchProductCellIdentifier";

@interface THNRecentlyViewedCollectionView()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation THNRecentlyViewedCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"THNProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kSearchProductCellIdentifier];
        self.backgroundColor = [UIColor whiteColor];
        [self reloadData];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource method 实现
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.recentlyViewedProducts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSearchProductCellIdentifier forIndexPath:indexPath];
    THNProductModel *productModel = [THNProductModel mj_objectWithKeyValues:self.recentlyViewedProducts[indexPath.row]];
    [cell setProductModel:productModel initWithType:THNHomeTypeExplore];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    THNProductModel *productModel = [THNProductModel mj_objectWithKeyValues:self.recentlyViewedProducts[indexPath.row]];
    if (self.recentlyViewedBlock) {
        self.recentlyViewedBlock(productModel.rid);
    }
}

@end
