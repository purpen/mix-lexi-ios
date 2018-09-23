//
//  THNLikedGoodsTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/8/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLikedGoodsTableViewCell.h"
#import "THNLikedGoodsCollectionViewCell.h"
#import "THNStoreModelProduct.h"
#import "THNMarco.h"

static NSString *const kCollectionViewCellId = @"THNLikedGoodsCollectionViewCellId";
static NSString *const kTableViewCellId = @"THNLikedGoodsTableViewCellId";

@interface THNLikedGoodsTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource> {
    CGFloat _goodsItemWidth;  // 商品 cell 的宽度
}

/// 商品列表
@property (nonatomic, strong) UICollectionView *goodsCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
/// 商品数据模型
@property (nonatomic, strong) NSMutableArray *modelArray;

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

+ (instancetype)initGoodsCellWithTableView:(UITableView *)tableView initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    THNLikedGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[THNLikedGoodsTableViewCell alloc] initWithStyle:style reuseIdentifier:reuseIdentifier];
        cell.tableView = tableView;
    }
    return cell;
}

#pragma mark - public methods
- (void)thn_setLikedGoodsData:(NSArray *)goodsData {
    if (self.modelArray.count) {
        [self.modelArray removeAllObjects];
    }
    
    for (THNGoodsModel *model in goodsData) {
        [self.modelArray addObject:model];
    }

    [self.goodsCollectionView reloadData];
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    [self addSubview:self.goodsCollectionView];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat originX = 0.0;
    switch (self.goodsCellType) {
        case THNGoodsListCellViewTypeGoodsInfoStore:
        case THNGoodsListCellViewTypeSimilarGoods:
            originX = 15.0;
            break;
        
        case THNGoodsListCellViewTypeGoodsList:
        case THNGoodsListCellViewTypeUserCenter:
            originX = 20.0;
            
        default:
            break;
    }
    
    self.flowLayout.itemSize = CGSizeMake(self.itemWidth, self.itemWidth);
    self.goodsCollectionView.contentInset = UIEdgeInsetsMake(0, originX, 0, originX);
    self.goodsCollectionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
}

#pragma mark - collectionView delegate & dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNLikedGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellId
                                                                                      forIndexPath:indexPath];
    if (self.modelArray.count) {
        [cell thn_setGoodsCellViewType:self.goodsCellType
                            goodsModel:self.modelArray[indexPath.row]
                          showInfoView:NO];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    THNGoodsModel *model = self.modelArray[indexPath.row];
    
    if (self.cell.selectedCellBlock) {
        self.cell.selectedCellBlock(model.rid);
    
    } else if (self.goodsCell.selectedCellBlock) {
        self.goodsCell.selectedCellBlock(model.rid);
    }
}

#pragma mark - getters and setters
- (CGFloat)itemWidth {
    return _itemWidth ? _itemWidth : CGRectGetHeight(self.bounds);
}

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
        _goodsCollectionView.delegate = self;
        _goodsCollectionView.dataSource = self;
        [_goodsCollectionView registerClass:[THNLikedGoodsCollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCellId];
    }
    return _goodsCollectionView;
}

- (NSMutableArray *)modelArray {
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

@end
