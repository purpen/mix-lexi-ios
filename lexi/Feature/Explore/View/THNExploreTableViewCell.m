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
#import "THNProductModel.h"
#import "THNFeaturedBrandModel.h"
#import "THNBrandCollectionViewCell.h"
#import "THNProductCollectionViewCell.h"
#import <MJExtension/MJExtension.h>

static NSString *const kBannnerCellIdentifier = @"kBannnerCellIdentifier";
static NSString *const kBrandCellIdentifier = @"kBrandCellIdentifier";
static NSString *const kProductCellIdentifier = @"kProductCellIdentifier";
CGFloat const cellSetHeight = 160;
CGFloat const cellFeaturedBrandHeight = 230;
CGFloat const cellOtherHeight = 190;

@interface THNExploreTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *productCollectionView;
@property (nonatomic, assign) ExploreCellType cellType;
@property (nonatomic, strong) NSArray *recommendDataArray;
@property (nonatomic, strong) NSArray *goodThingDataArray;
@property (nonatomic, strong) NSArray *brandHallDataArray;
@property (nonatomic, strong) NSArray *productNewDataArray;
@property (nonatomic, strong) NSArray *goodDesignDataArray;
@property (nonatomic, strong) NSArray *setDataArray;

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

- (IBAction)lookAll:(id)sender {
    if (self.delagate && [self.delagate respondsToSelector:@selector(lookAllWithType:)]) {
        [self.delagate lookAllWithType:self.cellType];
    }
}

- (void)setCellTypeStyle:(ExploreCellType)cellType initWithDataArray:(NSArray *)dataArray initWithTitle:(NSString *)title{
    self.cellType = cellType;
    self.titleLabel.text = title;
    CGFloat itemWidth = 0;
    CGFloat lineSpacing = 0;
    CGFloat itemHeight = 0;
    
    switch (cellType) {
        case ExploreSet:
            itemWidth = 190;
            itemHeight = cellSetHeight;
            lineSpacing = 10;
            self.setDataArray = dataArray;
            break;
         case ExploreFeaturedBrand:
            itemWidth = 250;
            itemHeight = cellFeaturedBrandHeight;
            lineSpacing = 20;
            self.brandHallDataArray = dataArray;
            break;
        case ExploreRecommend:
            itemWidth = 140;
            itemHeight = cellOtherHeight;
            lineSpacing = 10;
            self.recommendDataArray = dataArray;
            break;
        case ExploreNewProduct:
            itemWidth = 140;
            itemHeight = cellOtherHeight;
            lineSpacing = 10;
            self.productNewDataArray = dataArray;
            break;
        case ExploreGoodDesign:
            itemWidth = 140;
            itemHeight = cellOtherHeight;
            lineSpacing = 10;
            self.goodDesignDataArray = dataArray;
            break;
        case ExploreGoodThings:
            itemWidth = 140;
            itemHeight = cellOtherHeight;
            lineSpacing = 10;
            self.goodThingDataArray = dataArray;
            break;
    }
    
    [self.productCollectionView reloadData];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]initWithLineSpacing:lineSpacing initWithWidth:itemWidth initwithHeight:itemHeight];
    [self.productCollectionView setCollectionViewLayout:flowLayout];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (self.cellType) {
        case ExploreRecommend:
            return self.recommendDataArray.count;
            break;
        case ExploreFeaturedBrand:
            return self.brandHallDataArray.count;
            break;
        case ExploreNewProduct:
            return self.productNewDataArray.count;
            break;
        case ExploreSet:
            return self.setDataArray.count;
            break;
        case ExploreGoodDesign:
            return self.goodDesignDataArray.count;
            break;
        case ExploreGoodThings:
            return self.goodThingDataArray.count;
            break;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.cellType == ExploreSet) {
        THNBannnerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBannnerCellIdentifier forIndexPath:indexPath];
        THNSetModel *setModel = [THNSetModel mj_objectWithKeyValues:self.setDataArray[indexPath.row]];
        [cell setSetModel:setModel];
        return cell;
    } else if (self.cellType == ExploreFeaturedBrand) {
        THNBrandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBrandCellIdentifier forIndexPath:indexPath];
        THNFeaturedBrandModel *featuredBrandModel = [THNFeaturedBrandModel mj_objectWithKeyValues:self.brandHallDataArray[indexPath.row]];
        [cell setFeatureBrandModel:featuredBrandModel];
        return cell;
    } else {
       THNProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kProductCellIdentifier forIndexPath:indexPath];
        THNProductModel * productModel;
        
        if (self.recommendDataArray > 0) {
             productModel = [THNProductModel mj_objectWithKeyValues:self.recommendDataArray[indexPath.row]];
        }
        
        if (self.productNewDataArray > 0) {
            productModel = [THNProductModel mj_objectWithKeyValues:self.productNewDataArray[indexPath.row]];
        }
        
        if (self.goodDesignDataArray > 0) {
            productModel = [THNProductModel mj_objectWithKeyValues:self.goodDesignDataArray[indexPath.row]];
        }
        
        if (self.goodThingDataArray > 0) {
            productModel = [THNProductModel mj_objectWithKeyValues:self.goodThingDataArray[indexPath.row]];
        }
        
        [cell setProductModel:productModel initWithType:THNHomeTypeExplore];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    THNProductModel *productModel;
    
    switch (self.cellType) {
 
        case ExploreRecommend:
            productModel = [THNProductModel mj_objectWithKeyValues:self.recommendDataArray[indexPath.row]];
            break;
            
        case ExploreFeaturedBrand:
        {
            THNFeaturedBrandModel *featuredBrandModel = [THNFeaturedBrandModel mj_objectWithKeyValues:self.brandHallDataArray[indexPath.row]];
            if (self.delagate && [self.delagate respondsToSelector:@selector(pushBrandHall:)]) {
                [self.delagate pushBrandHall:featuredBrandModel];
            }
            
        }
            break;
            
        case ExploreNewProduct:
            productModel = [THNProductModel mj_objectWithKeyValues:self.productNewDataArray[indexPath.row]];
            break;
            
        case ExploreSet:
        {
            THNSetModel *setModel = [THNSetModel mj_objectWithKeyValues:self.setDataArray[indexPath.row]];
            if (self.delagate && [self.delagate respondsToSelector:@selector(pushSetDetail:)]) {
                [self.delagate pushSetDetail:setModel];
            }
        }
           break;
            
        case ExploreGoodDesign:
            productModel = [THNProductModel mj_objectWithKeyValues:self.goodDesignDataArray[indexPath.row]];
            break;
            
        case ExploreGoodThings:
            productModel = [THNProductModel mj_objectWithKeyValues:self.goodThingDataArray[indexPath.row]];
            break;
    }
}

@end
