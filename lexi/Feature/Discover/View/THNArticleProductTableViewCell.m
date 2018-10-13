//
//  THNArticleProductTableViewCell.m
//  lexi
//
//  Created by rhp on 2018/10/13.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNArticleProductTableViewCell.h"
#import "THNProductCollectionViewCell.h"
#import "THNProductModel.h"

static NSString *const kArticleProductCellIdentifier = @"kArticleProductCellIdentifier";

@interface THNArticleProductTableViewCell() <UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation THNArticleProductTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(15, 20, 0, 20);
    layout.itemSize = CGSizeMake(140, 200);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 70, 0);
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"THNProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kArticleProductCellIdentifier];
    [self.collectionView setCollectionViewLayout:layout];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UICollectionViewDataSourse
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.products.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kArticleProductCellIdentifier forIndexPath:indexPath];
    THNProductModel *productModel = [THNProductModel mj_objectWithKeyValues:self.products[indexPath.row]];
    [cell setProductModel:productModel initWithType:THNHomeTypeFeatured];
    return cell;
}


@end
