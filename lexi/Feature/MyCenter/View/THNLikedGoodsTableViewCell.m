//
//  THNLikedGoodsTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/8/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLikedGoodsTableViewCell.h"
#import "THNLikedGoodsCollectionViewCell.h"
#import "THNMarco.h"

static NSString *const kCollectionViewCellId = @"THNLikedGoodsCollectionViewCellId";
static NSString *const kTableViewCellId = @"THNLikedGoodsTableViewCellId";

@interface THNLikedGoodsTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>

/// 商品列表
@property (nonatomic, strong) UICollectionView *goodsCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
/// 商品数据
@property (nonatomic, strong) NSMutableArray *goodsArray;

@end

@implementation THNLikedGoodsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupCellViewUI];
    }
    return self;
}

+ (instancetype)initGoodsCellWithTableView:(UITableView *)tableView cellStyle:(UITableViewCellStyle)style {
    THNLikedGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellId];
    if (!cell) {
        cell = [[THNLikedGoodsTableViewCell alloc] initWithStyle:style reuseIdentifier:kTableViewCellId];
        cell.tableView = tableView;
    }
    return cell;
}

#pragma mark - public methods
- (void)thn_setGoodsData:(NSDictionary *)data {
    
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    [self.contentView addSubview:self.goodsCollectionView];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.goodsCollectionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    self.flowLayout.itemSize = CGSizeMake(CGRectGetHeight(self.frame), CGRectGetHeight(self.frame));
}

#pragma mark - collectionView delegate & dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return self.goodsArray.count;
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNLikedGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellId
                                                                                      forIndexPath:indexPath];
//    if (self.goodsArray.count) {
        [cell thn_setGoodsModel:[[THNProductModel alloc] init] showInfoView:NO];
//    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.cell.selectedCellBlock([NSString stringWithFormat:@"%zi", indexPath.row]);
}

#pragma mark - getters and setters
- (UICollectionView *)goodsCollectionView {
    if (!_goodsCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.flowLayout = flowLayout;
        
        _goodsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _goodsCollectionView.showsHorizontalScrollIndicator = NO;
        _goodsCollectionView.backgroundColor = [UIColor whiteColor];
        _goodsCollectionView.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
        _goodsCollectionView.delegate = self;
        _goodsCollectionView.dataSource = self;
        [_goodsCollectionView registerClass:[THNLikedGoodsCollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCellId];
    }
    return _goodsCollectionView;
}

- (NSMutableArray *)goodsArray {
    if (!_goodsArray) {
        _goodsArray = [NSMutableArray array];
    }
    return _goodsArray;
}

@end
