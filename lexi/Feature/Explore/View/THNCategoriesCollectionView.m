//
//  THNCategoriesCollectionView.m
//  lexi
//
//  Created by HongpingRao on 2018/7/26.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNCategoriesCollectionView.h"
#import "THNCategoriesCollectionViewCell.h"
#import "THNCategoriesModel.h"
#import <MJExtension/MJExtension.h>

static NSString *const kCategoriesCellIdentifier = @"kCategoriesCellIdentifier";

@interface THNCategoriesCollectionView()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation THNCategoriesCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"THNCategoriesCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kCategoriesCellIdentifier];
        self.backgroundColor = [UIColor whiteColor];
        [self reloadData];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource method 实现
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.categorieDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNCategoriesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCategoriesCellIdentifier forIndexPath:indexPath];
    THNCategoriesModel *categoriesModel =  [THNCategoriesModel mj_objectWithKeyValues:self.categorieDataArray[indexPath.row]];
    [cell setCategoriesModel:categoriesModel];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
     THNCategoriesModel *categoriesModel =  [THNCategoriesModel mj_objectWithKeyValues:self.categorieDataArray[indexPath.row]];
    self.categoriesBlock(categoriesModel.category_id, categoriesModel.name);
}

@end
