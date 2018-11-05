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
#import "THNMarco.h"

static NSString *const kOfficialCouponCollectionViewCellId = @"THNOfficialCouponCollectionViewCellId";

@interface THNOfficialCollectionViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *couponCollectionView;
@property (nonatomic, strong) NSArray *couponArr;

@end

@implementation THNOfficialCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCellViewUI];
    }
    return self;
}

- (void)thn_setOfficialCouponData:(NSArray *)couponData {
    self.couponArr = [NSArray arrayWithArray:couponData];
    [self.couponCollectionView reloadData];
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#FFBD9F"];
    [self addSubview:self.couponCollectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.couponArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNOfficialCouponCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kOfficialCouponCollectionViewCellId
                                                                                          forIndexPath:indexPath];
    if (self.couponArr.count) {
        [cell thn_setOfficialModel:self.couponArr[indexPath.row]];
    }
    
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
        
        _couponCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-15, 0, SCREEN_WIDTH, CGRectGetHeight(self.frame))
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
