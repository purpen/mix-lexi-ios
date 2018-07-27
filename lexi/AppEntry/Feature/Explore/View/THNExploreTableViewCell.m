//
//  THNExploreTableViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/7/26.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNExploreTableViewCell.h"
#import "THNBannnerCollectionViewCell.h"
#import "UICollectionViewFlowLayout+THN_flowLayout.h"
#import "UIImageView+WebCache.h"
#import "UIView+Helper.h"

static NSString *const kProductCellIdentifier = @"kProductCellIdentifier";

@interface THNExploreTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *productCollectionView;

@end

@implementation THNExploreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.productCollectionView registerNib:[UINib nibWithNibName:@"THNBannnerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kProductCellIdentifier];
    self.productCollectionView.delegate = self;
    self.productCollectionView.dataSource = self;
    self.productCollectionView.showsHorizontalScrollIndicator = NO;
    
}

- (void)test {
    [self.productCollectionView reloadData];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]initWithLineSpacing:20 initWithWidth:250 initwithHeight:160];
    [self.productCollectionView setCollectionViewLayout:flowLayout];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNBannnerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kProductCellIdentifier forIndexPath:indexPath];
    [cell.cellImageView sd_setImageWithURL:[NSURL URLWithString:@"https://kg.erp.taihuoniao.com/20180706/4605FpseCHcjdicYOsLROtwF_SVFKg_9.jpg"]];
    return cell;
}

@end
