//
//  THNSearchStoreTableViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/9/28.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSearchStoreTableViewCell.h"
#import "UICollectionViewFlowLayout+THN_flowLayout.h"
#import "THNFeaturedBrandModel.h"
#import "UIImageView+WebImage.h"
#import "UIView+Helper.h"
#import "THNBannnerCollectionViewCell.h"
#import <MJExtension/MJExtension.h>
#import "THNProductModel.h"
#import "THNFollowStoreButton+SelfManager.h"

static NSString *const kSearchStorePooductCellIdentifier = @"kSearchStorePooductCellIdentifier";

@interface THNSearchStoreTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet THNFollowStoreButton *followButton;
@property (weak, nonatomic) IBOutlet UIImageView *storeImageView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productCountLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation THNSearchStoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.storeImageView drawCornerWithType:0 radius:4];
    [self.followButton drawCornerWithType:0 radius:4];
    [self.followButton setupViewUI];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]initWithLineSpacing:10 initWithWidth:90 initwithHeight:90];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    [self.collectionView setCollectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"THNBannnerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kSearchStorePooductCellIdentifier];
}

- (void)setBrandModel:(THNFeaturedBrandModel *)brandModel {
    _brandModel = brandModel;
    
    [self.storeImageView loadImageWithUrl:[brandModel.logo loadImageUrlWithType:(THNLoadImageUrlTypeAvatar)]];
    self.storeNameLabel.text = brandModel.name;
    self.productCountLabel.text = [NSString stringWithFormat:@"%ld件商品",brandModel.product_count];
    [self.followButton selfManagerFollowBrandStatus:brandModel.is_follow_store brandModel:brandModel];
}

#pragma mark - UICollectionViewDataSource method 实现
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.brandModel.products.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNBannnerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSearchStorePooductCellIdentifier forIndexPath:indexPath];
    THNProductModel *productModel = [THNProductModel mj_objectWithKeyValues:self.brandModel.products[indexPath.row]];
    [cell setProductModel:productModel];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    THNProductModel *productModel = [THNProductModel mj_objectWithKeyValues:self.brandModel.products[indexPath.row]];
    if (self.searchStoreBlcok) {
        self.searchStoreBlcok(productModel.rid);
    }
}

@end
