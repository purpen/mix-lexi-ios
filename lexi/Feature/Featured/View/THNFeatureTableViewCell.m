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
#import "THNShopWindowModel.h"
#import "THNDailyRecommendModel.h"
#import "THNDailyRecommendCollectionViewCell.h"
#import "THNPoupalRecommendCollectionViewCell.h"


static NSString *const kLifeAestheticsCellIdentifier = @"kLifeAestheticsCellIdentifier";
static NSString *const kProductCellIdentifier = @"kProductCellIdentifier";
static NSString *const kGrassListCellIdentifier = @"kGrassListCellIdentifier";
static NSString *const kDailyRecommendCellIdentifier = @"kDailyRecommendCellIdentifier";
static NSString *const kPopularRecommendCellIdentifier = @"kPopularRecommendCellIdentifier";


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
@property (assign,nonatomic) NSInteger m_currentIndex;
@property (assign,nonatomic) CGFloat m_dragStartX;
@property (assign,nonatomic) CGFloat m_dragEndX;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation THNFeatureTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.productCollectionView registerNib:[UINib nibWithNibName:@"THNLifeAestheticsCollectionViewCell" bundle:nil]  forCellWithReuseIdentifier:kLifeAestheticsCellIdentifier];
    [self.productCollectionView registerNib:[UINib nibWithNibName:@"THNProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kProductCellIdentifier];
    [self.productCollectionView registerNib:[UINib nibWithNibName:@"THNGrassListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kGrassListCellIdentifier];
    [self.productCollectionView registerNib:[UINib nibWithNibName:@"THNDailyRecommendCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kDailyRecommendCellIdentifier];
    [self.productCollectionView registerNib:[UINib nibWithNibName:@"THNPoupalRecommendCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kPopularRecommendCellIdentifier];
    self.productCollectionView.delegate = self;
    self.productCollectionView.dataSource = self;
    self.productCollectionView.showsHorizontalScrollIndicator = NO;
}

- (void)setFrame:(CGRect)frame {
    if (self.isRewriteCellHeight) {
        frame.origin.y += 15;
        frame.size.height -= 15;
    }
    [super setFrame:frame];
}

- (IBAction)lookAll:(id)sender {
    if (self.delagate && [self.delagate respondsToSelector:@selector(lookAllWithType:)]) {
        [self.delagate lookAllWithType:self.cellType];
    }
}

#pragma mark - UIScrollViewDelegate
//手指拖动开始
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.cellType == FeaturedRecommendationPopular) {
        self.m_dragStartX = scrollView.contentOffset.x;
    }
}

//手指拖动停止
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.cellType == FeaturedRecommendationPopular) {
        self.m_dragEndX = scrollView.contentOffset.x;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fixCellToCenter];
        });
    }
}

//配置cell居中
- (void)fixCellToCenter {
    //最小滚动距离
    float dragMiniDistance = self.viewWidth / 5.0f;
    if (self.m_dragStartX -  self.m_dragEndX >= dragMiniDistance) {
        self.m_currentIndex -= 1;//向右
    }else if(self.m_dragEndX -  self.m_dragStartX >= dragMiniDistance){
        self.m_currentIndex += 1;//向左
    }
    NSInteger maxIndex = [self.productCollectionView numberOfItemsInSection:0] - 1;
    self.m_currentIndex = self.m_currentIndex <= 0 ? 0 : self.m_currentIndex;
    self.m_currentIndex = self.m_currentIndex >= maxIndex ? maxIndex : self.m_currentIndex;
    [self.productCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.m_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    self.pageControl.currentPage = self.m_currentIndex;
}

- (void)setCellTypeStyle:(FeaturedCellType)cellType initWithDataArray:(NSArray *)dataArray initWithTitle:(NSString *)title {
    self.cellType = cellType;
    self.pageControl.hidden = YES;
    self.lineView.hidden = NO;
    
    switch (cellType) {
        case FeaturedRecommendedToday:
            self.dailyDataArray = dataArray;
            self.lookAllButton.hidden = YES;
            self.instructionImageView.hidden = YES;
            self.lineView.hidden = YES;
            break;
        case FeaturedRecommendationPopular:
            self.lookAllButton.hidden = YES;
            self.instructionImageView.hidden = YES;
            self.popularDataArray = dataArray;
            self.pageControl.hidden = NO;
            self.pageControl.numberOfPages = self.popularDataArray.count;
            break;
        case FeaturedLifeAesthetics:
            self.lifeAestheticDataArray = dataArray;
            self.lookAllButton.hidden = YES;
            self.instructionImageView.hidden = YES;
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
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    flowLayout.minimumInteritemSpacing = cellType == FeaturedLifeAesthetics ? 20 : 9;
    flowLayout.minimumLineSpacing = 10;
    
    if (self.cellType == FeaturedLifeAesthetics || self.cellType == FeaturedRecommendedToday ) {
        flowLayout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
    } else if (self.cellType == FeaturedRecommendationPopular) {
         flowLayout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
         flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
         flowLayout.minimumLineSpacing = 0;
    } else {
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
            itemWidth = SCREEN_WIDTH;
            itemHeight = self.viewHeight;
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
            itemHeight = (SCREEN_WIDTH - 49) / 2 + 46;
            break;
        case FeaturedNo:
            itemWidth = (indexPath.row + 1) % 5 ? (SCREEN_WIDTH - 49) / 2 : SCREEN_WIDTH - 40;
            itemHeight = itemWidth + 46;
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
        THNShopWindowModel *lifeRecordModel = [THNShopWindowModel mj_objectWithKeyValues:self.lifeAestheticDataArray[indexPath.row]];
        [cell setLifeRecordModel:lifeRecordModel];
        return cell;
    } else if (self.cellType == FearuredGrassList) {
        THNGrassListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGrassListCellIdentifier forIndexPath:indexPath];
            THNGrassListModel *grassListModel =  [THNGrassListModel mj_objectWithKeyValues:self.grassListDataArray[indexPath.row]];
            [cell setGrassListModel:grassListModel];
        return cell;
    } else if (self.cellType == FeaturedRecommendedToday) {
          THNDailyRecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDailyRecommendCellIdentifier forIndexPath:indexPath];
        THNDailyRecommendModel *dailyRecommendModel = [THNDailyRecommendModel mj_objectWithKeyValues:self.dailyDataArray[indexPath.row]];
        [cell setDailyRecommendModel:dailyRecommendModel];
         return cell;
    } else if (self.cellType == FeaturedRecommendationPopular) {
        THNPoupalRecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPopularRecommendCellIdentifier forIndexPath:indexPath];
        
        cell.recommendCellBlock = ^(NSString *rid) {
            if (self.delagate && [self.delagate respondsToSelector:@selector(pushGoodInfo:)]) {
                [self.delagate pushGoodInfo:rid];
            }
        };
        
        cell.popularDataArray = self.popularDataArray[indexPath.row];
        [cell.collectionView reloadData];
        return cell;
    } else {
        THNProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kProductCellIdentifier forIndexPath:indexPath];
        THNProductModel *productModel;

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
            THNDailyRecommendModel *dailyRecommendModel = [THNDailyRecommendModel mj_objectWithKeyValues:self.dailyDataArray[indexPath.row]];
            if (dailyRecommendModel.target_type == RecommendTypeArticle || dailyRecommendModel.target_type == RecommendTypeGrassList) {
                if (self.delagate && [self.delagate respondsToSelector:@selector(pushArticle:)]) {
                    [self.delagate pushArticle:dailyRecommendModel.recommend_id];
                }
            } else if (dailyRecommendModel.target_type == RecommendTypeSet) {
                if (self.delagate && [self.delagate respondsToSelector:@selector(pushSetDetail:)]) {
                    [self.delagate pushSetDetail:dailyRecommendModel.recommend_id];
                }
            } else if (dailyRecommendModel.target_type == RecommendTypeProduct) {
                if (self.delagate && [self.delagate respondsToSelector:@selector(pushGoodInfo:)]) {
                    [self.delagate pushGoodInfo:[NSString stringWithFormat:@"%ld",dailyRecommendModel.recommend_id]];
                }
            }
            break;
        }
        
        case FeaturedRecommendationPopular: {
            break;
        }
            
        case FeaturedLifeAesthetics: {
            THNShopWindowModel *shopWindowModel = [THNShopWindowModel mj_objectWithKeyValues:self.lifeAestheticDataArray[indexPath.row]];
            
            if (self.delagate && [self.delagate respondsToSelector:@selector(pushShopWindow:)]) {
                [self.delagate pushShopWindow:shopWindowModel];
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
            THNGrassListModel *grassListModel = [THNGrassListModel mj_objectWithKeyValues:self.grassListDataArray[indexPath.row]];
            if (self.delagate && [self.delagate respondsToSelector:@selector(pushArticle:)]) {
                [self.delagate pushArticle:grassListModel.rid];
            }
            
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
