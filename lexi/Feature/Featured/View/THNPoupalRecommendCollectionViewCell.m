//
//  THNPoupalRecommendCollectionViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/10/26.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNPoupalRecommendCollectionViewCell.h"
#import "UIView+Helper.h"
#import "THNProductCollectionViewCell.h"
#import "THNProductModel.h"

static NSString *const kPopularProductCellIdentifier = @"kPopularProductCellIdentifier";

@interface THNPoupalRecommendCollectionViewCell() <UICollectionViewDelegate, UICollectionViewDataSource>



@end

@implementation THNPoupalRecommendCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"THNProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kPopularProductCellIdentifier];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.popularDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPopularProductCellIdentifier forIndexPath:indexPath];
    THNProductModel *productModel = [THNProductModel mj_objectWithKeyValues:self.popularDataArray[indexPath.row]];
    [cell setProductModel:productModel initWithType:THNHomeTypeFeatured];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWidth = 0;
    CGFloat itemHeight = 0;
    itemWidth = indexPath.row  <= 1 ? (self.viewWidth - 10 - 20 * 2) / 2  : (self.viewWidth - 20 - 20 * 2) / 3;
    itemHeight = indexPath.row <= 1 ? 170 : 155;
    return CGSizeMake(itemWidth, itemHeight);
}



@end
