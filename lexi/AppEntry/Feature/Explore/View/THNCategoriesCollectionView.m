//
//  THNCategoriesCollectionView.m
//  lexi
//
//  Created by HongpingRao on 2018/7/26.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNCategoriesCollectionView.h"
#import "THNCategoriesCollectionViewCell.h"

static NSString *const kCategoriesCellIdentifier = @"kCategoriesCellIdentifier";

@interface THNCategoriesCollectionView()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation THNCategoriesCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout withDataArray:(NSArray *)dataArray {
    self.dataArray = dataArray;
    return [self initWithFrame:frame collectionViewLayout:layout];
}

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
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNCategoriesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCategoriesCellIdentifier forIndexPath:indexPath];
    return cell;
}

@end
