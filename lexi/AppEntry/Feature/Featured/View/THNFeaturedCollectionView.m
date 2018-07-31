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

static NSString * const kFeatureTopBannerCellIdentifier = @"kFeatureTopBannerCellIdentifier";

@interface THNFeaturedCollectionView()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *dataArray;
@property (assign,nonatomic) NSInteger m_currentIndex;
@property (assign,nonatomic) CGFloat m_dragStartX;
@property (assign,nonatomic) CGFloat m_dragEndX;

@end

@implementation THNFeaturedCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewFlowLayout *)layout withDataArray:(NSArray *)dataArray {
    self.dataArray = dataArray;
    return [self initWithFrame:frame collectionViewLayout:layout];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewFlowLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        layout.itemSize = CGSizeMake(self.viewWidth - 75, 200);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 15;
        self.showsHorizontalScrollIndicator = NO;
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, 20);
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"THNBannnerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kFeatureTopBannerCellIdentifier];
        self.backgroundColor = [UIColor whiteColor];
        [self reloadData];
    }
    return self;
}

//配置cell居中
- (void)fixCellToCenter {
    //最小滚动距离
    float dragMiniDistance = self.bounds.size.width/20.0f;
    if (self.m_dragStartX -  self.m_dragEndX >= dragMiniDistance) {
        self.m_currentIndex -= 1;//向右
    }else if(self.m_dragEndX -  self.m_dragStartX >= dragMiniDistance){
        self.m_currentIndex += 1;//向左
    }
    NSInteger maxIndex = [self numberOfItemsInSection:0] - 1;
    
    
    self.m_currentIndex = self.m_currentIndex <= 0 ? 0 : self.m_currentIndex;
    self.m_currentIndex = self.m_currentIndex >= maxIndex ? maxIndex : self.m_currentIndex;
    
    
    [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.m_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
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


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (self.m_currentIndex == [self.dataArray count]/3*3) {
        NSIndexPath *path  = [NSIndexPath indexPathForItem:[self.dataArray count]/2 inSection:0];
        [self scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        self.m_currentIndex = [self.dataArray count]/2;
    }
    else if(self.m_currentIndex == [self.dataArray count]/3){
        NSIndexPath *path = [NSIndexPath indexPathForItem:[self.dataArray count]/2 inSection:0];
        [self scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        self.m_currentIndex = [self.dataArray count]/2;
    }
}



#pragma mark - UICollectionViewDataSource的实现
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNBannnerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFeatureTopBannerCellIdentifier forIndexPath:indexPath];
    [cell.cellImageView sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.row]]];
    return cell;
}

@end
