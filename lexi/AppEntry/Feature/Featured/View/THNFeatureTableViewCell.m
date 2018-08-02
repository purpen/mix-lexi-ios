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

static NSString *const kLifeAestheticsCellIdentifier = @"kLifeAestheticsCellIdentifier";
static NSString *const kTodayCellIdentifier = @"kTodayCellIdentifier";
static NSString *const kGrassListCellIdentifier = @"kGrassListCellIdentifier";
static NSString *const kUrlColumnHandpickRecommend = @"/column/handpick_recommend";

CGFloat const kCellTodayHeight = 180;
CGFloat const kCellPopularHeight = 330;
CGFloat const kCellLifeAestheticsHeight = 253.5;
CGFloat const kCellOptimalHeight = 200;
CGFloat const kCellGrassListHeight = 200;

@interface THNFeatureTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewConstraint;

@property (weak, nonatomic) IBOutlet UICollectionView *productCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, assign) FeaturedCellType cellType;
@property (nonatomic, strong) NSString * pupularTitle;
@property (nonatomic, strong) NSArray *popularDataArray;

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

- (void)loadPupularData {
    THNRequest *request = [THNAPI getWithUrlString:kUrlColumnHandpickRecommend requestDictionary:nil isSign:YES delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.pupularTitle = result.data[@"title"];
        self.popularDataArray = result.data[@"products"];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
    
}

- (void)setCellTypeStyle:(FeaturedCellType)cellType {
    self.cellType = cellType;
    switch (cellType) {
        case FeaturedRecommendedToday:
            self.titleLabel.text = @"今日推荐";
            break;
        case FeaturedRecommendationPopular:
            [self loadPupularData];
            self.titleLabel.text = self.pupularTitle;
            break;
        case FeaturedLifeAesthetics:
            self.titleLabel.text = @"今推荐";
            break;
        case FearuredOptimal:
            self.titleLabel.text = @"推荐";
            break;
        case FearuredGrassList:
            self.titleLabel.text = @"今推";
            break;
    }
    
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
            break;
        case FeaturedRecommendationPopular:
            itemWidth = indexPath.row <= 1 ? (self.viewWidth - 10 - 20 * 2) / 2  : (self.viewWidth - 20 - 20 * 2) / 3;
            itemHeight = indexPath.row <= 1 ? 160 : 145;
            break;
        case FeaturedLifeAesthetics:
            itemWidth = 248;
            itemHeight = kCellLifeAestheticsHeight;
            break;
        case FearuredGrassList:
            itemWidth = 163;
            itemHeight = kCellGrassListHeight;
            break;
        case FearuredOptimal:
            itemWidth = 163;
            itemHeight = kCellOptimalHeight;
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
        
        if (self.popularDataArray.count > 0) {
            THNProductModel *productModel = [THNProductModel mj_objectWithKeyValues:self.popularDataArray[indexPath.row]];
            [cell setProductModel:productModel];
        }
        
        
        return cell;
    
    }
}

// 人气推荐数据
- (NSArray *)popularDataArray {
    if (!_popularDataArray) {
        _popularDataArray = [NSArray array];
    }
    return _popularDataArray;
}


@end
