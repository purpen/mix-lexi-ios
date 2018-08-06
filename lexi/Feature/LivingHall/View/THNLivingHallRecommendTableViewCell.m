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

static NSString *const krecommendCellIdentifier = @"krecommendCellIdentifier";

@interface THNLivingHallRecommendTableViewCell()<UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *recommendCollectionView;

@end

@implementation THNLivingHallRecommendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.recommendCollectionView.dataSource = self;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]initWithLineSpacing:5 initWithWidth:25 initwithHeight:25];
    [self.recommendCollectionView setCollectionViewLayout:flowLayout];
    [self.recommendCollectionView registerNib:[UINib nibWithNibName:@"THNBannnerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:krecommendCellIdentifier];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 设置 cell 与 cell 之间的间距
- (void)setFrame:(CGRect)frame{
    frame.origin.y += 15;
    frame.size.height -= 15;
    [super setFrame:frame];
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  3;
}

- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    THNBannnerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:krecommendCellIdentifier forIndexPath:indexPath];
    THNSetModel *model = [[THNSetModel alloc]init];
    model.type = @"avatar";
    [cell setSetModel:model];
    return cell;
}

@end
