//
//  THNOfficialCollectionViewCell.m
//  lexi
//
//  Created by FLYang on 2018/11/1.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNOfficialCollectionViewCell.h"
#import "UIColor+Extension.h"
#import "THNOfficialCouponCollectionViewCell.h"

static NSString *const kOfficialCouponCollectionViewCellId = @"THNOfficialCouponCollectionViewCellId";

@interface THNOfficialCollectionViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *couponCollectionView;

@end

@implementation THNOfficialCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCellViewUI];
    }
    return self;
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#FFBD9F"];
    [self addSubview:self.couponCollectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNOfficialCouponCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kOfficialCouponCollectionViewCellId
                                                                                          forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - getters and setters
- (UICollectionView *)couponCollectionView {
    if (!_couponCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.itemSize = CGSizeMake(100, 128);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _couponCollectionView = [[UICollectionView alloc] initWithFrame: \
                                 CGRectMake(-15, 0, CGRectGetWidth(self.bounds) + 30, CGRectGetHeight(self.bounds))
                                                   collectionViewLayout:flowLayout];
        _couponCollectionView.delegate = self;
        _couponCollectionView.dataSource = self;
        _couponCollectionView.backgroundColor = [UIColor colorWithHexString:@"#FFBD9F"];
        _couponCollectionView.showsVerticalScrollIndicator = NO;
        _couponCollectionView.contentInset = UIEdgeInsetsMake(0, 15, 0, 15);
        _couponCollectionView.showsHorizontalScrollIndicator = NO;
        
        [_couponCollectionView registerClass:[THNOfficialCouponCollectionViewCell class]
                  forCellWithReuseIdentifier:kOfficialCouponCollectionViewCellId];
    }
    return _couponCollectionView;
}

@end
