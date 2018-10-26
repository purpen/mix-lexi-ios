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
#import "UIView+Helper.h"
#import <Masonry/Masonry.h>
#import "UIColor+Extension.h"
#import "THNBannnerCollectionViewCell.h"
#import "THNBannerModel.h"
#import <MJExtension/MJExtension.h>

static NSString *const kBannerCellIdentifier = @"kBannerCellIdentifier";

@interface THNBannerView()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSArray *bannerDataArray;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation THNBannerView

- (void)setBannerView:(NSArray *)array {
    self.bannerDataArray = array;
    [self.collectionView addSubview:self.pageControl];
    [self layoutPageControl];
    [self.collectionView reloadData];
}

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
        collectionView.delegate = self;
        collectionView.backgroundColor = [UIColor whiteColor];
        [collectionView registerNib:[UINib nibWithNibName:@"THNBannnerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kBannerCellIdentifier];
        self.collectionView = collectionView;
        [self addSubview:collectionView];
        self.layer.cornerRadius = 2.5;
        self.layer.masksToBounds = YES;
        
        // 当没有数据 scrollToItemAtIndexPath会崩溃
        if (self.bannerDataArray.count == 0) {
            return self;
        }
        [collectionView performBatchUpdates:^{
            [collectionView reloadData];
        } completion:^(BOOL finished) {
            
            [self scrollStartPoint];
        }];
        
        
        [self addTimer];
        
        
    }
    
    return self;
  
}

- (void)layoutPageControl {
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        switch (self.carouselBannerType) {
            case CarouselBannerTypeBrandHallFeatured:
                make.centerX.equalTo(self);
                make.bottom.equalTo(self);
                break;
            default:
                make.bottom.right.equalTo(self);
                break;
        }
       make.size.mas_equalTo(CGSizeMake(25 * self.bannerDataArray.count, 44));
    }];
}

- (void)addTimer {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(scrollNextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)scrollNextPage {
    NSInteger pageIndex = [[[self.collectionView indexPathsForVisibleItems] lastObject] row];
    pageIndex++;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:pageIndex inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (void)scrollStartPoint {
    self.pageControl.currentPage = 0;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

#pragma mark - UICollectionViewDataSource的实现
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNBannnerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBannerCellIdentifier forIndexPath:indexPath];
    THNBannerModel *bannerModel = [THNBannerModel mj_objectWithKeyValues:self.dataArray[indexPath.row]];
    [cell setBannerModel:bannerModel];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    THNBannerModel *bannerModel = [THNBannerModel mj_objectWithKeyValues:self.dataArray[indexPath.row]];
   
    switch (bannerModel.type) {
        case BannerContentTypeLink:
            if (self.delegate && [self.delegate respondsToSelector:@selector(bannerPushWeb:)]) {
                [self.delegate bannerPushWeb:bannerModel.link];
            }
            break;
        case BannerContentTypeProduct:
            if (self.delegate && [self.delegate respondsToSelector:@selector(bannerPushGoodInfo:)]) {
                [self.delegate bannerPushGoodInfo:bannerModel.link];
            }
            break;
        case BannerContentTypeCatogories:
            if (self.delegate && [self.delegate respondsToSelector:@selector(bannerPushCategorie:initWithCategoriesID:)]) {
                
                [self.delegate bannerPushCategorie:bannerModel.title initWithCategoriesID:[bannerModel.link integerValue]];
            }
            break;
        case BannerContentTypeBrandHall:
            if (self.delegate && [self.delegate respondsToSelector:@selector(bannerPushBrandHall:)]) {
                [self.delegate bannerPushBrandHall:bannerModel.link];
            }
            break;
        case BannerContentTypeSpecialTopic:
            break;
        default:
            if (self.delegate && [self.delegate respondsToSelector:@selector(bannerPushArticle:)]) {
                [self.delegate bannerPushArticle:[bannerModel.link integerValue]];
            }
            break;
    }
}

#pragma mark - UICollectionViewDelegate method 实现
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 获取当前item的位置
    NSInteger pageIndex = [[[self.collectionView indexPathsForVisibleItems] lastObject] row];
    NSInteger index = 0;
    // 当前所在位置为数组最后数据时,不去设置滑动一半的效果
    if (pageIndex == self.bannerDataArray.count) {
       index  = (scrollView.contentOffset.x) / self.viewWidth;
    } else {
       index = (scrollView.contentOffset.x + self.viewWidth * 0.5) / self.viewWidth;
    }
    
    self.pageControl.currentPage = index - 1;
    
    if (index == self.bannerDataArray.count + 1) {
        [self scrollStartPoint];
        return;
    }
    
    
    if (scrollView.contentOffset.x < self.viewWidth * 0.5) {
        self.pageControl.currentPage = self.bannerDataArray.count - 1;
    }
    
    if (scrollView.contentOffset.x < 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.bannerDataArray.count inSection:0];
        self.pageControl.currentPage = self.bannerDataArray.count;
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        return;
    }
    
}

// 手动切换停止自动轮播
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self removeTimer];
}

// 当用户停止的时候恢复自动轮播
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self addTimer];
}

#pragma mark - lazy
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [_bannerDataArray mutableCopy];
        // data数组最后加上第一个数据,第一个数据前加上最后一个数据，从而实现视觉上轮播效果
        if (_bannerDataArray.count > 1) {
            [_dataArray addObject:_bannerDataArray.firstObject];
            [_dataArray insertObject:_bannerDataArray.lastObject atIndex:0];
        }
    }
    return _dataArray;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.numberOfPages = _bannerDataArray.count;
        _pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"ffffff" alpha:0.4];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    }
    return _pageControl;
}

@end
