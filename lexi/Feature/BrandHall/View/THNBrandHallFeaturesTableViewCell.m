//
//  THNBrandHallFeaturesTableViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/9/3.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBrandHallFeaturesTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "THNFeaturedBrandModel.h"
#import "UICollectionViewFlowLayout+THN_flowLayout.h"
#import "THNProductCollectionViewCell.h"
#import <MJExtension/MJExtension.h>
#import "THNProductModel.h"
#import "UIView+Helper.h"

static NSString * const kBrandHallCollectionCellIdentifier = @"kBrandHallCollectionCellIdentifier";

@interface THNBrandHallFeaturesTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *brandImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation THNBrandHallFeaturesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   [self.brandImageView drawCornerWithType:0 radius:4];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"THNProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kBrandHallCollectionCellIdentifier];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]initWithLineSpacing:10 initWithWidth:140 initwithHeight:180];
    layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    [self.collectionView setCollectionViewLayout:layout];
}

- (void)setBrandModel:(THNFeaturedBrandModel *)brandModel {
    _brandModel = brandModel;
    [self.brandImageView sd_setImageWithURL:[NSURL URLWithString:brandModel.logo]placeholderImage:[UIImage imageNamed:@"default_image_place"]];
    self.nameLabel.text = brandModel.name;
    self.addressLabel.text = [NSString stringWithFormat:@"%@,%@",brandModel.country,brandModel.city];
    self.desLabel.text = brandModel.tag_line;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.brandModel.products.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBrandHallCollectionCellIdentifier forIndexPath:indexPath];
    THNProductModel *productModel = [THNProductModel mj_objectWithKeyValues:self.brandModel.products[indexPath.row]];
    [cell setProductModel:productModel initWithType:THNHomeTypeBrandHall];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    THNProductModel *productModel = [THNProductModel mj_objectWithKeyValues:self.brandModel.products[indexPath.row]];
    if (self.brandHallFeaturesBlock) {
        self.brandHallFeaturesBlock(productModel.rid);
    }
}


@end
