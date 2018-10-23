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
#import "THNTextTool.h"
#import "UIColor+Extension.h"
#import "NSString+Helper.h"

static NSString *const krecommendCellIdentifier = @"krecommendCellIdentifier";
// 添加或移除用户喜欢
static NSString *const kUrlUserLike = @"/userlike";
// 喜欢商品的用户
static NSString *const kUrlProductUserLike = @"/product/userlike";

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
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelLeftConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *shippingImageView;

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

// 喜欢商品的用户
- (void)loadLikeProductUserData:(NSString *)rid {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = rid;
    THNRequest *request = [THNAPI getWithUrlString:kUrlProductUserLike requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        self.likeProductUserArray = result.data[@"product_like_users"];
        [self.recommendCollectionView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

// 添加喜欢商品
- (void)addLikeUser:(NSString *)rid {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = rid;
    THNRequest *request = [THNAPI postWithUrlString:kUrlUserLike requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [self loadLikeProductUserData:rid];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

//移除喜欢商品
- (void)removeLikeUser:(NSString *)rid {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = rid;
    THNRequest *request = [THNAPI deleteWithUrlString:kUrlUserLike requestDictionary:params delegate:nil ];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        [self loadLikeProductUserData:rid];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

- (IBAction)delete:(id)sender {
    THNObtainedView *obtainedMuseumView = [THNObtainedView sharedManager];
    [obtainedMuseumView show];
    
    obtainedMuseumView.obtainedBlock = ^{
        [self deleteProduct];
    };
}

- (void)deleteProduct {
    if (self.deleteProductBlock) {
         self.deleteProductBlock(self);
    }
}


- (IBAction)changeLikeStatu:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (!sender.selected) {
        self.likeLabel.textColor = [UIColor colorWithHexString:@"959fa7"];
        self.likeImageView.image = [UIImage imageNamed:@"icon_humbsUp_gray"];
        [self removeLikeUser:self.productModel.rid];
       
    } else {
        self.likeLabel.textColor = [UIColor colorWithHexString:@"6ED7AF"];
        self.likeImageView.image = [UIImage imageNamed:@"icon_humbsUp_green"];
        [self addLikeUser:self.productModel.rid];
        
    }
}

- (IBAction)shareButton:(id)sender {
    if (self.shareProductBlock) {
        self.shareProductBlock();
    }
}

- (void)setProductModel:(THNProductModel *)productModel {
    _productModel = productModel;
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:productModel.cover]placeholderImage:[UIImage imageNamed:@"default_image_place"]];
    self.productNameLabel.text = productModel.name;
    
    if (productModel.is_free_postage) {
        self.shippingImageView.hidden = NO;
        self.nameLabelLeftConstraint.constant = 5;
    } else {
        self.shippingImageView.hidden = YES;
        self.nameLabelLeftConstraint.constant = -20;
    }
    
    if (productModel.min_sale_price == 0) {
        
        if (productModel.like_count == 0) {
            self.producrOriginalPriceLabel.hidden = YES;
        } else {
            self.producrOriginalPriceLabel.hidden = NO;
            self.producrOriginalPriceLabel.text = [NSString stringWithFormat:@"喜欢 +%ld",productModel.like_count];
        }
        
        self.productPriceLabel.text = [NSString formatFloat:productModel.min_price];
        self.likeCountLabel.hidden = YES;
    } else {
        self.productPriceLabel.text = [NSString formatFloat:productModel.min_sale_price];
        self.producrOriginalPriceLabel.hidden = NO;
        self.producrOriginalPriceLabel.attributedText = [THNTextTool setStrikethrough:productModel.min_price];
        
        if (productModel.like_count == 0) {
            self.likeCountLabel.hidden = YES;
        } else {
            self.likeCountLabel.hidden = NO;
            self.likeCountLabel.text = [NSString stringWithFormat:@"喜欢 +%ld",productModel.like_count];
        }
    }

    self.recommenDationLabel.text = productModel.stick_text;
    
    if (self.productModel.is_like) {
        self.likeLabel.textColor = [UIColor colorWithHexString:@"6ED7AF"];
        self.likeImageView.image = [UIImage imageNamed:@"icon_humbsUp_green"];
        self.changeLikeStatuButton.selected = YES;
    } else {
        self.likeLabel.textColor = [UIColor colorWithHexString:@"959fa7"];
        self.likeImageView.image = [UIImage imageNamed:@"icon_humbsUp_gray"];
        self.changeLikeStatuButton.selected = NO;
    }
}

// 馆长信息头像
- (void)setCurtorAvatar:(NSString *)storeAvatarUrl {
    [self.curatorAvatarImageView sd_setImageWithURL:[NSURL URLWithString:storeAvatarUrl] placeholderImage:[UIImage imageNamed:@"default_image_place"]];
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
