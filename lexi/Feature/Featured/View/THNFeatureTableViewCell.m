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
#import "THNAPI.h"
#import "THNProductModel.h"
#import <MJExtension/MJExtension.h>
#import "THNMarco.h"
#import "THNGrassListModel.h"
#import "THNLifeRecordModel.h"
#import "THNDailyRecommendModel.h"
#import "THNDailyRecommendCollectionViewCell.h"

static NSString *const kLifeAestheticsCellIdentifier = @"kLifeAestheticsCellIdentifier";
static NSString *const kProductCellIdentifier = @"kProductCellIdentifier";
static NSString *const kGrassListCellIdentifier = @"kGrassListCellIdentifier";
static NSString *const kDailyRecommendCellIdentifier = @"kDailyRecommendCellIdentifier";

CGFloat const kCellTodayHeight = 195;
CGFloat const kCellPopularHeight = 330;
CGFloat const kCellLifeAestheticsHeight = 293.5;
CGFloat const kCellOptimalHeight = 200;
CGFloat const kCellGrassListHeight = 158;

@interface THNFeatureTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewConstraint;
@property (weak, nonatomic) IBOutlet UICollectionView *productCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, assign) FeaturedCellType cellType;
@property (nonatomic, strong) NSArray *popularDataArray;
@property (nonatomic, strong) NSArray *optimalDataArray;
@property (nonatomic, strong) NSArray *grassListDataArray;
@property (nonatomic, strong) NSArray *weekPopularDataArray;
@property (nonatomic, strong) NSArray *lifeAestheticDataArray;
@property (nonatomic, strong) NSArray *dailyDataArray;
@property (weak, nonatomic) IBOutlet UIButton *lookAllButton;
@property (weak, nonatomic) IBOutlet UIImageView *instructionImageView;

@end

@implementation THNFeatureTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   [self.productCollectionView registerNib:[UINib nibWithNibName:@"THNLifeAestheticsCollectionViewCell" bundle:nil]  forCellWithReuseIdentifier:kLifeAestheticsCellIdentifier];
    [self.productCollectionView registerNib:[UINib nibWithNibName:@"THNProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kProductCellIdentifier];
    [self.productCollectionView registerNib:[UINib nibWithNibName:@"THNGrassListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kGrassListCellIdentifier];
     [self.productCollectionView registerNib:[UINib nibWithNibName:@"THNDailyRecommendCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kDailyRecommendCellIdentifier];
    self.productCollectionView.delegate = self;
    self.productCollectionView.dataSource = self;
    self.productCollectionView.showsHorizontalScrollIndicator = NO;
}
- (IBAction)lookAll:(id)sender {
    if (self.delagate && [self.delagate respondsToSelector:@selector(lookAllWithType:)]) {
        [self.delagate lookAllWithType:self.cellType];
    }
}

- (void)setCellTypeStyle:(FeaturedCellType)cellType initWithDataArray:(NSArray *)dataArray initWithTitle:(NSString *)title {
    self.cellType = cellType;
    switch (cellType) {
        case FeaturedRecommendedToday:
            self.dailyDataArray = dataArray;
            self.lookAllButton.hidden = YES;
            self.instructionImageView.hidden = YES;
            break;
        case FeaturedRecommendationPopular:
            self.lookAllButton.hidden = YES;
            self.instructionImageView.hidden = YES;
            self.popularDataArray = dataArray;
            break;
        case FeaturedLifeAesthetics:
            self.lifeAestheticDataArray = dataArray;
            self.lookAllButton.hidden = NO;
            self.instructionImageView.hidden = NO;
            break;
        case FearuredOptimal:
            self.optimalDataArray = dataArray;
            self.lookAllButton.hidden = NO;
            self.instructionImageView.hidden = NO;
            break;
        case FearuredGrassList:
            self.grassListDataArray = dataArray;
            self.lookAllButton.hidden = NO;
            self.instructionImageView.hidden = NO;
            break;
        case FeaturedNo:
            self.lookAllButton.hidden = YES;
            self.instructionImageView.hidden = YES;
            self.weekPopularDataArray = dataArray;
            break;
    }
    self.titleLabel.text = title;
    //  放在初始化设置Layout前，否则数据样式错乱，卡顿，以及可能会有崩溃的问题产生
   [self.productCollectionView reloadData];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 0);
    flowLayout.minimumInteritemSpacing = cellType == FeaturedLifeAesthetics ? 20 : 9;
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
            itemWidth = 158;
            itemHeight = kCellTodayHeight;
            break;
        case FeaturedRecommendationPopular:
            itemWidth = indexPath.row  <= 1 ? (self.viewWidth - 10 - 20 * 2) / 2  : (self.viewWidth - 20 - 20 * 2) / 3;
            itemHeight = indexPath.row <= 1 ? 160 : 145;
            break;
        case FeaturedLifeAesthetics:
            itemWidth = 248;
            itemHeight = kCellLifeAestheticsHeight;
            break;
        case FearuredGrassList:
            itemWidth = (SCREEN_WIDTH - 49) / 2;
            itemHeight = kCellGrassListHeight + [self.grassLabelHeights[indexPath.row] floatValue];
            break;
        case FearuredOptimal:
            itemWidth = (SCREEN_WIDTH - 49) / 2;
            itemHeight = kCellOptimalHeight;
            break;
        case FeaturedNo:
            itemWidth = (SCREEN_WIDTH - 49) / 2;
            itemHeight = kCellOptimalHeight;
            break;
    }
    
    return CGSizeMake(itemWidth, itemHeight);
}

#pragma mark - UICollectionViewDataSource method 实现
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (self.cellType) {
        case FeaturedRecommendedToday:
            return self.dailyDataArray.count;
            break;
        case FeaturedLifeAesthetics:
            return self.lifeAestheticDataArray.count;
            break;
        case FearuredGrassList:
            return self.grassListDataArray.count;
            break;
        case FearuredOptimal:
            return self.optimalDataArray.count;
            break;
        case FeaturedRecommendationPopular:
            return self.popularDataArray.count;
            break;
        case FeaturedNo:
            return self.weekPopularDataArray.count;
            break;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.cellType == FeaturedLifeAesthetics) {
        THNLifeAestheticsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLifeAestheticsCellIdentifier forIndexPath:indexPath];
        THNLifeRecordModel *lifeRecordModel = [THNLifeRecordModel mj_objectWithKeyValues:self.lifeAestheticDataArray[indexPath.row]];
        [cell setLifeRecordModel:lifeRecordModel];
        return cell;
    }else if (self.cellType == FearuredGrassList) {
        THNGrassListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGrassListCellIdentifier forIndexPath:indexPath];
            THNGrassListModel *grassListModel =  [THNGrassListModel mj_objectWithKeyValues:self.grassListDataArray[indexPath.row]];
            [cell setGrassListModel:grassListModel];
        return cell;
        
    }else if (self.cellType == FeaturedRecommendedToday) {
          THNDailyRecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDailyRecommendCellIdentifier forIndexPath:indexPath];
        THNDailyRecommendModel *dailyRecommendModel = [THNDailyRecommendModel mj_objectWithKeyValues:self.dailyDataArray[indexPath.row]];
        [cell setDailyRecommendModel:dailyRecommendModel];
         return cell;
    } else {
        THNProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kProductCellIdentifier forIndexPath:indexPath];
        THNProductModel *productModel;
        
        if (self.cellType == FeaturedRecommendationPopular) {
            productModel = [THNProductModel mj_objectWithKeyValues:self.popularDataArray[indexPath.row]];
        }
        
        if (self.cellType == FearuredOptimal) {
            productModel = [THNProductModel mj_objectWithKeyValues:self.optimalDataArray[indexPath.row]];
        }
        
        if (self.cellType == FeaturedNo) {
            productModel = [THNProductModel mj_objectWithKeyValues:self.weekPopularDataArray[indexPath.row]];
        }
           
        [cell setProductModel:productModel initWithType:THNHomeTypeFeatured];
        return cell;
    
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    THNProductModel *productModel;
    
    switch (self.cellType) {
           
        case FeaturedRecommendedToday:{
            
            break;
        }
        
        case FeaturedRecommendationPopular: {
            productModel = [THNProductModel mj_objectWithKeyValues:self.popularDataArray[indexPath.row]];
            
            if (self.delagate && [self.delagate respondsToSelector:@selector(pushGoodInfo:)]) {
                [self.delagate pushGoodInfo:productModel.rid];
            }
            
            break;
        }
            
        case FeaturedLifeAesthetics: {
            THNLifeRecordModel *lifeRecordModel = [THNLifeRecordModel mj_objectWithKeyValues:self.lifeAestheticDataArray[indexPath.row]];
            
            if (self.delagate && [self.delagate respondsToSelector:@selector(pushShopWindow:)]) {
                [self.delagate pushShopWindow:lifeRecordModel.rid];
            }
            
            break;
        }
            
        case FearuredOptimal: {
            productModel = [THNProductModel mj_objectWithKeyValues:self.optimalDataArray[indexPath.row]];
            
            if (self.delagate && [self.delagate respondsToSelector:@selector(pushGoodInfo:)]) {
                [self.delagate pushGoodInfo:productModel.rid];
            }
            
            break;
        }
            
        case FearuredGrassList: {
            break;
        }
            
        case FeaturedNo: {
            productModel = [THNProductModel mj_objectWithKeyValues:self.weekPopularDataArray[indexPath.row]];
            
            if (self.delagate && [self.delagate respondsToSelector:@selector(pushGoodInfo:)]) {
                [self.delagate pushGoodInfo:productModel.rid];
            }
            
            break;
        }
    }
}

@end
