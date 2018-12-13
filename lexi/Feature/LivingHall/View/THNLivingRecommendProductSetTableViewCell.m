//
//  THNLivingRecommendProductSetTableViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/12/13.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLivingRecommendProductSetTableViewCell.h"
#import "THNProductCollectionViewCell.h"
#import "THNProductModel.h"
#import "THNAPI.h"
#import "THNLoginManager.h"
#import "SVProgressHUD+Helper.h"
#import <MJExtension/MJExtension.h>
#import "UIImageView+WebImage.h"
#import "UIView+Helper.h"

static NSString *const kRecommendProductCellIdentifier = @"kRecommendProductCellIdentifier";
// 馆长推荐
static NSString *const kUrlCuratorRecommended = @"/core_platforms/products/by_store";
static NSInteger const maxShowMoreViewCount = 4;
static NSString *const kRecommendProductMoreViewCellIdentifier = @"kRecommendProductMoreViewCellIdentifier";

@interface THNLivingRecommendProductSetTableViewCell () <
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, strong) NSMutableArray *recommendedMutableArray;
@property (nonatomic, assign) BOOL isHaveMoreData;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, strong) UIImageView *moreImageView;

@end

@implementation THNLivingRecommendProductSetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.pageCount = 1;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"THNProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kRecommendProductCellIdentifier];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kRecommendProductMoreViewCellIdentifier];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    flowLayout.itemSize = CGSizeMake(105, 155);
    flowLayout.minimumLineSpacing = 10;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView setCollectionViewLayout:flowLayout];
    [self loadCuratorRecommendedData];
}

- (void)setStoreAvatarUrl:(NSString *)storeAvatarUrl {
    [self.avatarImageView loadImageWithUrl:[storeAvatarUrl loadImageUrlWithType:(THNLoadImageUrlTypeAvatar)] circular:YES];
}

// 馆长推荐
- (void)loadCuratorRecommendedData {
    [self setRecommendData];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sid"] = [THNLoginManager sharedManager].storeRid;
    params[@"is_distributed"] = @(2);
    params[@"page"] = @(self.pageCount);
    params[@"per_page"] = @(10);
    
    THNRequest *request = [THNAPI getWithUrlString:kUrlCuratorRecommended requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
            [SVProgressHUD thn_showErrorWithStatus:result.statusMessage];
            return;
        }
        
        NSArray *array = result.data[@"products"];
        self.isHaveMoreData = [result.data[@"next"] boolValue];
        [self.recommendedMutableArray addObjectsFromArray:[THNProductModel mj_objectArrayWithKeyValuesArray:array]];
        [self.collectionView reloadData];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

- (void)setRecommendData {
    if (self.isMergeRecommendData) {
        
        return;
    }

    self.pageCount = 1;
    [self.recommendedMutableArray removeAllObjects];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger recommendDataCount = self.recommendedMutableArray.count;
    return recommendDataCount > maxShowMoreViewCount ? recommendDataCount + 1 : recommendDataCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.recommendedMutableArray.count) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRecommendProductMoreViewCellIdentifier forIndexPath:indexPath];
        NSString *imageStr = self.isHaveMoreData ? @"icon_look_more" : @"icon_no_more";
        [self.moreImageView setImage:[UIImage imageNamed:imageStr]];
        [cell addSubview:self.moreImageView];
        return cell;
    } else {
        THNProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRecommendProductCellIdentifier forIndexPath:indexPath];
        THNProductModel *productModel = [THNProductModel mj_objectWithKeyValues:self.recommendedMutableArray[indexPath.row]];
        [cell setProductModel:productModel initWithType:THNHomeTypeShowPrice];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.recommendedMutableArray.count) {
        if (self.isHaveMoreData) {
            self.isMergeRecommendData = YES;
            self.pageCount++;
            [self loadCuratorRecommendedData];
        }
    } else {
        THNProductModel *productModel = [THNProductModel mj_objectWithKeyValues:self.recommendedMutableArray[indexPath.row]];
        if (self.recommendCellBlock) {
            self.recommendCellBlock(productModel.rid);
        }
    }
}

- (IBAction)lookMoreData:(id)sender {
    if (self.lookMoreRecommenDataBlock) {
        self.lookMoreRecommenDataBlock();
    }
}

#pragma mark - lazy
- (NSMutableArray *)recommendedMutableArray {
    if (!_recommendedMutableArray) {
        _recommendedMutableArray = [NSMutableArray array];
    }
    return _recommendedMutableArray;
}

- (UIImageView *)moreImageView {
    if (!_moreImageView) {
        _moreImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 1, 110, 108)];
        [_moreImageView drawShadow:0.06];
    }
    
    return _moreImageView;
}

@end
