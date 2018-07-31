//
//  THNBrandCollectionViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/7/27.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBrandCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface THNBrandCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *backGroundImageView;

@end

@implementation THNBrandCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 4;
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    visualView.frame = self.bounds;
    [self.backGroundImageView addSubview:visualView];
}

- (void)setFeatureBrandModel:(THNFeaturedBrandModel *)featureBrandModel {
    [self.backGroundImageView sd_setImageWithURL:[NSURL URLWithString:@"https://kg.erp.taihuoniao.com/20180701/5504FtL-iSk6tn4p1F2QKf4UBpJLgbZr.jpg"]];
}

@end
