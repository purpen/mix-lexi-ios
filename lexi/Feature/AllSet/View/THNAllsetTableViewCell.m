//
//  THNAllsetTableViewCell.m
//  lexi
//
//  Created by rhp on 2018/9/2.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNAllsetTableViewCell.h"
#import "THNCollectionModel.h"
#import "THNBannnerCollectionViewCell.h"
#import <MJExtension/MJExtension.h>
#import "THNProductModel.h"
#import "THNMarco.h"
#import "THNBannnerCollectionViewCell.h"

static NSString *const kSetCollectionCellIdentifier = @"kSetCollectionCellIdentifier";

@interface THNAllsetTableViewCell()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productCountTextLabel;

@end

@implementation THNAllsetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.collectionView registerNib:[UINib nibWithNibName:@"THNBannnerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kSetCollectionCellIdentifier];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    [self.collectionView setCollectionViewLayout:layout];
    self.collectionView.scrollEnabled = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)setCollectionModel:(THNCollectionModel *)collectionModel {
    _collectionModel = collectionModel;
    self.nameLabel.text = [NSString stringWithFormat:@"%@-%@",collectionModel.name,collectionModel.sub_name];
    self.productCountTextLabel.text = [NSString stringWithFormat:@"%zi件商品",collectionModel.count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // 加一个背景图
    return self.collectionModel.products.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNBannnerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSetCollectionCellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        [cell setCollectionModel:self.collectionModel];
    } else {
         THNProductModel *productModel = [THNProductModel mj_objectWithKeyValues:self.collectionModel.products[indexPath.row - 1]];
        [cell setProductModel:productModel];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (self.pushDetailBlock) {
            self.pushDetailBlock(self.collectionModel.collectionID);
        }
    } else {
         THNProductModel *productModel = [THNProductModel mj_objectWithKeyValues:self.collectionModel.products[indexPath.row - 1]];
        if (self.allsetBlcok) {
            self.allsetBlcok(productModel.rid);
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewFlowLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWidth = indexPath.row == 0 ? SCREEN_WIDTH - 30 : (SCREEN_WIDTH - 60) / 4;
    CGFloat itemHeight = indexPath.row == 0 ? 200  : 79;
    return CGSizeMake(itemWidth, itemHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 15, 0, 0);
}

@end
