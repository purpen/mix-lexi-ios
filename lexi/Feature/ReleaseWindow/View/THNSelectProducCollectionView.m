//
//  THNSelectProducCollectionView.m
//  lexi
//
//  Created by HongpingRao on 2018/11/15.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSelectProducCollectionView.h"
#import "THNBannnerCollectionViewCell.h"
#import <MJExtension/MJExtension.h>
#import "THNProductModel.h"

static NSString *const kLikeProductCellIdentifier = @"kLikeProductCellIdentifier";

@interface THNSelectProducCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation THNSelectProducCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"THNBannnerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kLikeProductCellIdentifier];
        self.backgroundColor = [UIColor whiteColor];
        [self reloadData];
    }
    return self;
}

- (void)setProducts:(NSMutableArray *)products {
    _products = products;
    [self reloadData];
}

#pragma mark - UICollectionViewDataSource method 实现
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.products.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNBannnerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLikeProductCellIdentifier forIndexPath:indexPath];
    THNProductModel *productModel = [THNProductModel mj_objectWithKeyValues:self.products[indexPath.row]];
    [cell setProductModel:productModel.cover withNeedRadian:NO];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    THNProductModel *productModel = [THNProductModel mj_objectWithKeyValues:self.products[indexPath.row]];
    if (self.selectProductBlcok) {
        self.selectProductBlcok(productModel.rid, productModel.store_rid);
    }
}

@end
