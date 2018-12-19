//
//  THNFeaturedCollectionView.m
//  lexi
//
//  Created by HongpingRao on 2018/7/27.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNFeaturedCollectionView.h"
#import "THNBannnerCollectionViewCell.h"
#import "UIImageView+WebImage.h"
#import "UIView+Helper.h"
#import "THNBannerModel.h"
#import <MJExtension/MJExtension.h>

static NSString *const kFeatureTopBannerCellIdentifier = @"kFeatureTopBannerCellIdentifier";

@interface THNFeaturedCollectionView() <UICollectionViewDataSource, UICollectionViewDelegate>

@property (assign,nonatomic) NSInteger m_currentIndex;
@property (assign,nonatomic) CGFloat m_dragStartX;
@property (assign,nonatomic) CGFloat m_dragEndX;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray *dataArray;

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

- (void)setBanners:(NSArray *)banners {
    _banners = banners;
    
    if (banners.count == 0) {
        return;
    } else if (banners.count == 1) {
        [self reloadData];
        return;
    }
    
    [self addTimer];
    [self reloadData];
    [self scrollStartPoint];
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
    
    // 回到开始的位置往左滑回到最后的位置
    if (self.m_currentIndex == 0) {
        self.m_currentIndex = maxIndex - 1;
        switch (self.bannerType) {
            case BannerTypeLeft:
                [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.m_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
                break;
                
            default:
                [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.m_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
                break;
        }
        return;
    }

    // 最后回到最初的位置
    if (self.m_currentIndex == maxIndex) {
        [self scrollStartPoint];
        return;
    }
    
    [self thn_scrollToIndexpathItem];
    
}

- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)addTimer {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(scrollNextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

- (void)scrollNextPage {
    self.m_currentIndex++;
    NSInteger maxIndex = [self numberOfItemsInSection:0] - 1;
    if (self.m_currentIndex == maxIndex) {
        [self scrollStartPoint];
        return;
    }
    
    [self thn_scrollToIndexpathItem];
}

- (void)thn_scrollToIndexpathItem {
    switch (self.bannerType) {
        case BannerTypeLeft:
            [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.m_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
            break;
            
        default:
            [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.m_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            break;
    }
}

- (void)scrollStartPoint {
    self.m_currentIndex = 1;
    switch (self.bannerType) {
        case BannerTypeLeft:
            [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.m_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
            break;
            
        default:
            [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.m_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            break;
    }
}

#pragma mark - UIScrollViewDelegate
//手指拖动开始
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.m_dragStartX = scrollView.contentOffset.x;
    [self removeTimer];
}

//手指拖动停止
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.m_dragEndX = scrollView.contentOffset.x;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fixCellToCenter];
        [self addTimer];
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
                
                [self.featuredDelegate bannerPushCategorie:bannerModel.title initWithCategoriesID:bannerModel.link];
            }
            break;
        case BannerContentTypeBrandHall:
            if (self.featuredDelegate && [self.featuredDelegate respondsToSelector:@selector(bannerPushBrandHall:)]) {
                [self.featuredDelegate bannerPushBrandHall:bannerModel.link];
            }
            break;
        case BannerContentTypeSpecialTopic:
            break;
        case BannerContentTypeApplets:
            break;
        case BannerContentTypeSet:
            if (self.featuredDelegate && [self.delegate respondsToSelector:@selector(bannerPushSet:)]) {
                [self.featuredDelegate bannerPushSet:[bannerModel.link integerValue]];
            }
            break;
        case BannerContentTypeShopWindow:
            if (self.featuredDelegate && [self.delegate respondsToSelector:@selector(bannerPushShowWindow:)]) {
                [self.featuredDelegate bannerPushShowWindow:bannerModel.link];
            }
            break;
    }
}

#pragma mark - lazy
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [_banners mutableCopy];
        // data数组最后加上第一个数据,第一个数据前加上最后一个数据，从而实现视觉上轮播效果
        if (_banners.count > 1) {
            [_dataArray addObject:_banners.firstObject];
            [_dataArray insertObject:_banners.lastObject atIndex:0];
        }
    }
    return _dataArray;
}

@end
