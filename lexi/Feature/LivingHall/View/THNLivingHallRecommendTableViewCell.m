//
//  THNLivingHallRecommendTableViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/8/1.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLivingHallRecommendTableViewCell.h"
#import "UICollectionViewFlowLayout+THN_flowLayout.h"
#import "THNBannnerCollectionViewCell.h"
#import "THNSetModel.h"
#import "UIView+Helper.h"
#import "THNMarco.h"
#import "THNUserPartieModel.h"
#import "THNProductModel.h"
#import "UIImageView+WebCache.h"
#import <MJExtension/MJExtension.h>
#import "THNAPI.h"
#import "THNObtainedView.h"

static NSString *const krecommendCellIdentifier = @"krecommendCellIdentifier";
// 喜欢商品的用户
static NSString *const kUrlLikeProductUser = @"/product/userlike";

@interface THNLivingHallRecommendTableViewCell()<UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *recommendCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *producrOriginalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *recommenDationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *curatorAvatarImageView;
@property (nonatomic, strong) NSArray *likeProductUserArray;

@end

@implementation THNLivingHallRecommendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.productImageView drawCornerWithType:0 radius:4];
    [self.curatorAvatarImageView drawCornerWithType:0 radius:4];
    self.recommendCollectionView.dataSource = self;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]initWithLineSpacing:5 initWithWidth:25 initwithHeight:25];
    [self.recommendCollectionView setCollectionViewLayout:flowLayout];
    [self.recommendCollectionView registerNib:[UINib nibWithNibName:@"THNBannnerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:krecommendCellIdentifier];
}

- (void)loadLikeProductUserData:(NSString *)rid {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = rid;
    THNRequest *request = [THNAPI getWithUrlString:kUrlLikeProductUser requestDictionary:params isSign:YES delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.likeProductUserArray = result.data[@"product_like_users"];
        [self.recommendCollectionView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

- (IBAction)delete:(id)sender {
    [THNObtainedView show];
}

- (void)setProductModel:(THNProductModel *)productModel {
    _productModel = productModel;
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:productModel.cover]];
    self.productNameLabel.text = productModel.name;
    self.productPriceLabel.text = [NSString stringWithFormat:@"%2.f",productModel.min_sale_price];
    self.producrOriginalPriceLabel.text = [NSString stringWithFormat:@"%2.f",productModel.min_price];
    self.likeCountLabel.text = [NSString stringWithFormat:@"喜欢 +%ld",productModel.like_count];
    self.recommenDationLabel.text = productModel.features;
}

// 馆长信息头像
- (void)setCurtorAvatar:(NSString *)storeAvatarUrl {
    [self.curatorAvatarImageView sd_setImageWithURL:[NSURL URLWithString:storeAvatarUrl]];
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   return self.likeProductUserArray.count < 3 ? self.likeProductUserArray.count : 3;
}

- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    THNBannnerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:krecommendCellIdentifier forIndexPath:indexPath];
    THNUserPartieModel *userPatieModel = [THNUserPartieModel mj_objectWithKeyValues:self.likeProductUserArray[indexPath.row]];
    [cell setUserPartieModel:userPatieModel];
    return cell;
}

@end
