//
//  THNBrandCollectionViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/7/27.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBrandCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "THNFeaturedBrandModel.h"
#import "THNBannnerCollectionViewCell.h"
#import "THNBannerModel.h"
#import <MJExtension/MJExtension.h>
#import "UICollectionViewFlowLayout+THN_flowLayout.h"
#import "UIView+Helper.h"

static NSString * const kBrandProductCellIdentifier = @"kBrandProductCellIdentifier";

@interface THNBrandCollectionViewCell()<UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *backGroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *storeImageView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *storePruductCountLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *pruductCollectionView;

@property (weak, nonatomic) IBOutlet UIButton *flowButton;

@end

@implementation THNBrandCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 4;
    // 毛玻璃效果
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    visualView.frame = CGRectMake(0, 0, 254, 235);
    [self.backGroundImageView addSubview:visualView];
    
    self.pruductCollectionView.dataSource = self;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]initWithLineSpacing:6.5 initWithWidth:74 initwithHeight:74];
    self.pruductCollectionView.scrollEnabled = NO;
    [self.pruductCollectionView setCollectionViewLayout:flowLayout];
    [self.pruductCollectionView registerNib:[UINib nibWithNibName:@"THNBannnerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kBrandProductCellIdentifier];
    [self.flowButton drawCornerWithType:0 radius:self.flowButton.viewHeight / 2];
}

- (IBAction)flow:(id)sender {
    
}


- (void)setFeatureBrandModel:(THNFeaturedBrandModel *)featureBrandModel {
    _featureBrandModel = featureBrandModel;
    [self.backGroundImageView sd_setImageWithURL:[NSURL URLWithString:featureBrandModel.bgcover]];
    [self.storeImageView sd_setImageWithURL:[NSURL URLWithString:featureBrandModel.logo]];
    self.storeNameLabel.text = featureBrandModel.name;
    self.storePruductCountLabel.text = [NSString stringWithFormat:@"%ld 件",featureBrandModel.store_products_counts];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.featureBrandModel.products_cover.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNBannnerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBrandProductCellIdentifier forIndexPath:indexPath];
    cell.setLabelsView.hidden = YES;
    [cell.cellImageView sd_setImageWithURL:[NSURL URLWithString:self.featureBrandModel.products_cover[indexPath.row]]];
    return cell;
}

@end
