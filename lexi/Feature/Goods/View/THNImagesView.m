//
//  THNImagesView.m
//  lexi
//
//  Created by FLYang on 2018/8/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNImagesView.h"
#import "THNImageCollectionViewCell.h"
#import "THNMarco.h"
#import "THNGoodsModelAsset.h"
#import "UIColor+Extension.h"
#import <YYKit/YYKit.h>

static NSString *const kTHNImageCollectionViewCellId = @"kTHNImageCollectionViewCellId";

@interface THNImagesView () <UICollectionViewDelegate, UICollectionViewDataSource> {
    BOOL _isFull;
}

/// 图片浏览器
@property (nonatomic, strong) UICollectionView *imageCollecitonView;
/// 图片链接
@property (nonatomic, strong) NSMutableArray *imageUrlArr;
/// 图片
@property (nonatomic, strong) NSMutableArray *imageArr;
/// 图片数量文字
@property (nonatomic, strong) YYLabel *countLabel;

@end

@implementation THNImagesView

- (instancetype)initWithFrame:(CGRect)frame fullScreen:(BOOL)fullScreen {
    self = [super initWithFrame:frame];
    if (self) {
        _isFull = fullScreen;
        [self setupViewUI];
    }
    return self;
}

#pragma mark - public methods
- (void)thn_setImageAssets:(NSArray *)assets {
    if (self.imageUrlArr.count) {
        [self.imageUrlArr removeAllObjects];
    }
    
    for (THNGoodsModelAsset *asset in assets) {
        [self.imageUrlArr addObject:asset.viewUrl];
    }
    
    [self thn_setImageCount:self.imageUrlArr.count index:1];
    [self.imageCollecitonView reloadData];
}

#pragma mark - private methods
- (void)thn_setImageCount:(NSInteger)count index:(NSInteger)index {
    NSString *countString = [NSString stringWithFormat:@" / %zi", count];
    NSMutableAttributedString *countAttString = [[NSMutableAttributedString alloc] initWithString:countString];
    countAttString.font = [UIFont systemFontOfSize:14];
    countAttString.color = [UIColor colorWithHexString:_isFull ? @"#DADADA" : @"#FCFCFC"];
    
    NSString *indexString = [NSString stringWithFormat:@"%zi", index];
    NSMutableAttributedString *indexAttString = [[NSMutableAttributedString alloc] initWithString:indexString];
    indexAttString.font = _isFull ? [UIFont systemFontOfSize:17 weight:(UIFontWeightMedium)] : [UIFont systemFontOfSize:14];
    indexAttString.color = [UIColor colorWithHexString:_isFull ? @"#DADADA" : @"#FCFCFC"];
    [indexAttString appendAttributedString:countAttString];
    indexAttString.alignment = _isFull ? NSTextAlignmentCenter : NSTextAlignmentRight;
    
    self.countLabel.attributedText = indexAttString;
    self.countLabel.shadowColor = [UIColor colorWithHexString:@"#000000" alpha:0.4];
    self.countLabel.shadowOffset = CGSizeMake(0, 0);
    self.countLabel.shadowBlurRadius = 3;
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
    
    [self addSubview:self.imageCollecitonView];
    [self addSubview:self.countLabel];
}

#pragma mark -
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.imageCollecitonView) {
        NSInteger index = scrollView.contentOffset.x / CGRectGetWidth(self.bounds);
        [self thn_setImageCount:self.imageUrlArr.count index:index + 1];
    }
}

#pragma mark - collectionView datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageUrlArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTHNImageCollectionViewCellId
                                                                                 forIndexPath:indexPath];
    if (self.imageUrlArr.count) {
        [cell thn_setImageUrl:self.imageUrlArr[indexPath.row]];
    }
    return cell;
}

#pragma mark delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(thn_didSelectImageAtIndex:)]) {
        [self.delegate thn_didSelectImageAtIndex:indexPath.row];
    }
}

#pragma mark - getters and setters
- (UICollectionView *)imageCollecitonView {
    if (!_imageCollecitonView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetWidth(self.bounds));
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _imageCollecitonView = [[UICollectionView alloc] initWithFrame: \
                                CGRectMake(0, (CGRectGetHeight(self.bounds) - CGRectGetWidth(self.bounds)) / 2, \
                                           CGRectGetWidth(self.bounds), CGRectGetWidth(self.bounds))
                                                  collectionViewLayout:flowLayout];
        _imageCollecitonView.delegate = self;
        _imageCollecitonView.dataSource = self;
        _imageCollecitonView.pagingEnabled = YES;
        _imageCollecitonView.showsHorizontalScrollIndicator = NO;
        _imageCollecitonView.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
        [_imageCollecitonView registerClass:[THNImageCollectionViewCell class] forCellWithReuseIdentifier:kTHNImageCollectionViewCellId];
    }
    return _imageCollecitonView;
}

- (YYLabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[YYLabel alloc] init];
        
        CGFloat originY = _isFull ? CGRectGetMinY(self.imageCollecitonView.bounds) - 40 : CGRectGetMaxY(self.imageCollecitonView.bounds) - 30;
        _countLabel.frame = CGRectMake(20, originY, CGRectGetWidth(self.bounds) - 40, 20);
    }
    return _countLabel;
}

- (NSMutableArray *)imageUrlArr {
    if (!_imageUrlArr) {
        _imageUrlArr = [NSMutableArray array];
    }
    return _imageUrlArr;
}

- (NSMutableArray *)imageArr {
    if (!_imageArr) {
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}

@end
