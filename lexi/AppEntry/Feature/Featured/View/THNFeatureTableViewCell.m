//
//  THNFeatureTableViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/7/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNFeatureTableViewCell.h"
#import "THNProductCollectionViewCell.h"
#import "THNLifeAestheticsCollectionViewCell.h"
#import "UICollectionViewFlowLayout+THN_flowLayout.h"
#import "UIView+Helper.h"
#import "THNGrassListCollectionViewCell.h"

static NSString *const kLifeAestheticsCellIdentifier = @"kLifeAestheticsCellIdentifier";
static NSString *const kTodayCellIdentifier = @"kTodayCellIdentifier";
static NSString *const kGrassListCellIdentifier = @"kGrassListCellIdentifier";
CGFloat const kCellTodayHeight = 180;
CGFloat const kCellPopularHeight = 330;
CGFloat const kCellLifeAestheticsHeight = 250;
CGFloat const kCellOptimalHeight = 420;
CGFloat const kCellGrassListHeight = 420;

@interface THNFeatureTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewConstraint;

@property (weak, nonatomic) IBOutlet UICollectionView *productCollectionView;
@property (nonatomic, assign) FeaturedCellType cellType;

@end

@implementation THNFeatureTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   [self.productCollectionView registerNib:[UINib nibWithNibName:@"THNLifeAestheticsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kLifeAestheticsCellIdentifier];
    [self.productCollectionView registerNib:[UINib nibWithNibName:@"THNProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kTodayCellIdentifier];
    [self.productCollectionView registerNib:[UINib nibWithNibName:@"THNGrassListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kGrassListCellIdentifier];
    self.productCollectionView.delegate = self;
    self.productCollectionView.dataSource = self;
    self.productCollectionView.showsHorizontalScrollIndicator = NO;
}

- (void)setCellTypeStyle:(FeaturedCellType)cellType {
    self.cellType = cellType;
    [self.productCollectionView reloadData];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.minimumInteritemSpacing = cellType == FeaturedLifeAesthetics ? 20 : 10;
    flowLayout.minimumLineSpacing = 10;
    
    if (self.cellType == FeaturedLifeAesthetics || self.cellType == FeaturedRecommendedToday) {
        self.collectionViewConstraint.constant = 0;
        flowLayout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
    } else {
        self.collectionViewConstraint.constant = 20;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    
    [self.productCollectionView setCollectionViewLayout:flowLayout];
}


#pragma mark UICollectionViewDelegateFlowLayout method 实现
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWidth = 0;
    CGFloat itemHeight = 0;
    
    switch (self.cellType) {
        case FeaturedRecommendedToday:
            itemWidth = 160;
            itemHeight = kCellTodayHeight;
            self.collectionViewConstraint.constant = 0;
            break;
        case FeaturedRecommendationPopular:
            self.collectionViewConstraint.constant = 20;
            NSLog(@"%f",collectionView.viewWidth);
            itemWidth = indexPath.row <= 1 ? (self.viewWidth - 10 - 40) / 2  : (self.viewWidth - 20 - 40) / 3;
            itemHeight = indexPath.row <= 1 ? 160 : 145;
            break;
        case FeaturedLifeAesthetics:
            itemWidth = 248;
            itemHeight = 253.5;
            self.collectionViewConstraint.constant = 0;
            break;
        case FearuredGrassList:
            self.collectionViewConstraint.constant = 20;
            itemWidth = 163;
            itemHeight = 200;
            break;
        case FearuredOptimal:
            self.collectionViewConstraint.constant = 20;
            itemWidth = 163;
            itemHeight = 200;
            break;
    }
    
    return CGSizeMake(itemWidth, itemHeight);
}

#pragma mark - UICollectionViewDataSource method 实现
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (self.cellType) {
        case FeaturedRecommendedToday:
            return 10;
            break;
        case FeaturedLifeAesthetics:
            return 10;
            break;
        case FearuredGrassList:
            return 4;
            break;
        case FearuredOptimal:
            return 4;
            break;
        case FeaturedRecommendationPopular:
            return 5;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.cellType == FeaturedLifeAesthetics) {
        THNLifeAestheticsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLifeAestheticsCellIdentifier forIndexPath:indexPath];
        return cell;
        
    }else if (self.cellType == FearuredGrassList || self.cellType == FeaturedRecommendedToday) {
        THNGrassListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGrassListCellIdentifier forIndexPath:indexPath];
        return cell;
    } else {
        THNProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTodayCellIdentifier forIndexPath:indexPath];
        [cell setOtherModel:nil];
        return cell;
    
    }
}


@end
