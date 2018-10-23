//
//  THNFeaturedCollectionView.m
//  lexi
//
//  Created by HongpingRao on 2018/7/27.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNFeaturedCollectionView.h"
#import "THNBannnerCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIView+Helper.h"
#import "THNBannerModel.h"
#import <MJExtension/MJExtension.h>

static NSString *const kFeatureTopBannerCellIdentifier = @"kFeatureTopBannerCellIdentifier";

@interface THNFeaturedCollectionView() <UICollectionViewDataSource, UICollectionViewDelegate>

@property (assign,nonatomic) NSInteger m_currentIndex;
@property (assign,nonatomic) CGFloat m_dragStartX;
@property (assign,nonatomic) CGFloat m_dragEndX;

@end

@implementation THNFeaturedCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewFlowLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        layout.itemSize = CGSizeMake(self.viewWidth - 75, self.viewHeight);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 15;
        self.showsHorizontalScrollIndicator = NO;
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, 20);
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"THNBannnerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kFeatureTopBannerCellIdentifier];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
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
    NSInteger maxIndex = [self numberOfItemsInSection:0] - 1;
    
    
    self.m_currentIndex = self.m_currentIndex <= 0 ? 0 : self.m_currentIndex;
    self.m_currentIndex = self.m_currentIndex >= maxIndex ? maxIndex : self.m_currentIndex;
    
    switch (self.bannerType) {
        case BannerTypeLeft:
            [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.m_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
            break;
            
        default:
            [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.m_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            break;
    }
    
}

#pragma mark - UIScrollViewDelegate
//手指拖动开始
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.m_dragStartX = scrollView.contentOffset.x;
}

//手指拖动停止
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.m_dragEndX = scrollView.contentOffset.x;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fixCellToCenter];
    });
}

#pragma mark - UICollectionViewDataSource的实现
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNBannnerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFeatureTopBannerCellIdentifier forIndexPath:indexPath];
    THNBannerModel *bannerModel = [THNBannerModel mj_objectWithKeyValues:self.dataArray[indexPath.row]];
    [cell setBannerModel:bannerModel];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    THNBannerModel *bannerModel = [THNBannerModel mj_objectWithKeyValues:self.dataArray[indexPath.row]];
    
    switch (bannerModel.type) {
        case BannerContentTypeLink:
            if (self.featuredDelegate && [self.featuredDelegate respondsToSelector:@selector(bannerPushWeb:)]) {
                [self.featuredDelegate bannerPushWeb:bannerModel.link];
            }
            break;
        case BannerContentTypeProduct:
            if (self.featuredDelegate && [self.featuredDelegate respondsToSelector:@selector(bannerPushGoodInfo:)]) {
                [self.featuredDelegate bannerPushGoodInfo:bannerModel.link];
            }
            break;
        case BannerContentTypeCatogories:
            if (self.featuredDelegate && [self.featuredDelegate respondsToSelector:@selector(bannerPushCategorie:initWithCategoriesID:)]) {
                
                [self.featuredDelegate bannerPushCategorie:bannerModel.title initWithCategoriesID:[bannerModel.link integerValue]];
            }
            break;
        case BannerContentTypeBrandHall:
            if (self.featuredDelegate && [self.featuredDelegate respondsToSelector:@selector(bannerPushBrandHall:)]) {
                [self.featuredDelegate bannerPushBrandHall:bannerModel.link];
            }
            break;
        case BannerContentTypeSpecialTopic:
            break;
        default:
            if (self.featuredDelegate && [self.featuredDelegate respondsToSelector:@selector(bannerPushArticle:)]) {
                [self.featuredDelegate bannerPushArticle:[bannerModel.link integerValue]];
            }
            break;
    }
}


@end
