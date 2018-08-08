//
//  THNLivingHallHeaderView.m
//  lexi
//
//  Created by HongpingRao on 2018/8/1.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLivingHallHeaderView.h"
#import "THNBannnerCollectionViewCell.h"
#import "UIView+Helper.h"
#import "THNAPI.h"
#import "UICollectionViewFlowLayout+THN_flowLayout.h"
#import "THNSetModel.h"
#import "THNMarco.h"
#import "UIImageView+WebCache.h"

static NSString *const kUrlStoreInfo = @"/store/info";
static NSString *const kAvatarCellIdentifier = @"kAvatarCellIdentifier";

@interface THNLivingHallHeaderView()<UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *livingHallView;
@property (weak, nonatomic) IBOutlet UIView *selectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *avatarCollectionView;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *tintLabels;
@property (weak, nonatomic) IBOutlet UIImageView *insideImageView;
@property (weak, nonatomic) IBOutlet UIImageView *outsideImageView;
@property (weak, nonatomic) IBOutlet UIImageView *middleImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectionTitleConstraint;

@end

@implementation THNLivingHallHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // 添加阴影
    [self.livingHallView drwaShadow];
    self.livingHallView.layer.borderWidth = 0;
    self.avatarCollectionView.dataSource = self;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]initWithLineSpacing:-5 initWithWidth:29 initwithHeight:29];
    self.avatarCollectionView.scrollEnabled = NO;   
    [self.avatarCollectionView setCollectionViewLayout:flowLayout];
    [self.avatarCollectionView registerNib:[UINib nibWithNibName:@"THNBannnerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kAvatarCellIdentifier];
    
    [self.insideImageView drawCornerWithType:0 radius:4];
    [self.middleImageView drawCornerWithType:0 radius:4];
    [self.outsideImageView drawCornerWithType:0 radius:4];
    [self.insideImageView sd_setImageWithURL:[NSURL URLWithString:@"https://kg.erp.taihuoniao.com/20180711/1808FgkTUxcFE3_2DAXlTdi4rQMRU7IY.jpg"]];
    [self.middleImageView sd_setImageWithURL:[NSURL URLWithString:@"https://kg.erp.taihuoniao.com/20180706/4605FpseCHcjdicYOsLROtwF_SVFKg_9.jpg"]];
    [self.outsideImageView sd_setImageWithURL:[NSURL URLWithString:@"https://kg.erp.taihuoniao.com/20180701/5504FtL-iSk6tn4p1F2QKf4UBpJLgbZr.jpg"]];
    
    // 适配5S的样式
    if (SCREEN_WIDTH == 320) {
        for (UILabel *label in self.tintLabels) {
            label.font = [UIFont systemFontOfSize:9];
        }
        self.selectionTitleConstraint.constant = 3;
    }
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (SCREEN_WIDTH -  94.5) / 24;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNBannnerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAvatarCellIdentifier forIndexPath:indexPath];
    THNSetModel *model = [[THNSetModel alloc]init];
    model.type = @"avatar";
    [cell setSetModel:model];
    return cell;
}

@end
