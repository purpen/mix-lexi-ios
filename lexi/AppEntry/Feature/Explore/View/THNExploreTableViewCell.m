//
//  THNExploreTableViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/7/26.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNExploreTableViewCell.h"
#import "THNBannnerCollectionViewCell.h"
#import "UICollectionViewFlowLayout+THN_flowLayout.h"
#import "UIImageView+WebCache.h"
#import "UIView+Helper.h"
#import "THNSetModel.h"
#import "THNOtherModel.h"
#import "THNFeaturedBrandModel.h"
#import "THNBrandCollectionViewCell.h"
#import "THNProductCollectionViewCell.h"

static NSString *const kBannnerCellIdentifier = @"kBannnerCellIdentifier";
static NSString *const kBrandCellIdentifier = @"kBrandCellIdentifier";
static NSString *const kProductCellIdentifier = @"kProductCellIdentifier";
CGFloat const cellSetHeight = 160;
CGFloat const cellFeaturedBrandHeight = 230;
CGFloat const cellOtherHeight = 190;

@interface THNExploreTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *productCollectionView;
@property (nonatomic, assign) ExploreCellType cellType;

@end

@implementation THNExploreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.productCollectionView registerNib:[UINib nibWithNibName:@"THNBannnerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kBannnerCellIdentifier];
    [self.productCollectionView registerNib:[UINib nibWithNibName:@"THNBrandCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kBrandCellIdentifier];
    [self.productCollectionView registerNib:[UINib nibWithNibName:@"THNProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kProductCellIdentifier];
    self.productCollectionView.delegate = self;
    self.productCollectionView.dataSource = self;
    self.productCollectionView.showsHorizontalScrollIndicator = NO;
    
}

- (void)setCellTypeStyle:(ExploreCellType)cellType {
    [self.productCollectionView reloadData];
    self.cellType = cellType;
    CGFloat itemWidth = 0;
    CGFloat lineSpacing = 0;
    CGFloat itemHeight = 0;
    
    switch (cellType) {
        case ExploreSet:
            itemWidth = 190;
            itemHeight = cellSetHeight;
            lineSpacing = 10;
            break;
         case ExploreFeaturedBrand:
            itemWidth = 250;
            itemHeight = cellFeaturedBrandHeight;
            lineSpacing = 20;
            break;
        case ExploreOther:
            itemWidth = 140;
            itemHeight = cellOtherHeight;
            lineSpacing = 10;
            break;
    }
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]initWithLineSpacing:lineSpacing initWithWidth:itemWidth initwithHeight:itemHeight];
    [self.productCollectionView setCollectionViewLayout:flowLayout];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.cellType == ExploreSet) {
        THNSetModel *setModel;
        THNBannnerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBannnerCellIdentifier forIndexPath:indexPath];
        [cell setSetModel:setModel];
        return cell;
    } else if (self.cellType == ExploreFeaturedBrand) {
        THNFeaturedBrandModel *featuredBrandModel;
        THNBrandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBrandCellIdentifier forIndexPath:indexPath];
        [cell setFeatureBrandModel:featuredBrandModel];
        return cell;
    } else {
        THNOtherModel *otherModel;
        THNProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kProductCellIdentifier forIndexPath:indexPath];
        [cell setOtherModel:otherModel];
        return cell;
    }
}

@end
