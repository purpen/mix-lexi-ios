//
//  THNBannerView.m
//  lexi
//
//  Created by HongpingRao on 2018/7/25.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBannerView.h"
#import "THNMarco.h"
#import "UIImageView+WebCache.h"


static NSString * const kBannerCellIdentifier = @"kBannerCellIdentifier";

@interface THNBannerView()<UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation THNBannerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.itemSize = frame.size;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.pagingEnabled = YES;
        collectionView.scrollEnabled = YES;
        collectionView.dataSource = self;
        collectionView.backgroundColor = [UIColor whiteColor];
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kBannerCellIdentifier];
        self.layer.cornerRadius = 2.5;
        self.layer.masksToBounds = YES;
        [self addSubview:collectionView];
        [collectionView reloadData];
    }
    
    return self;
  
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBannerCellIdentifier forIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:cell.bounds];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.row]]];
    [cell.contentView addSubview:imageView];
    return cell;
}

#pragma mark - lazy

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [_data mutableCopy];
        if (_data.count > 1) {
            [_dataArray addObject:_data.firstObject];
            [_dataArray insertObject:_data.lastObject atIndex:0];
        }
    }
    return _dataArray;
}

@end
