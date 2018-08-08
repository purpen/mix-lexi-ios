//
//  THNGrassListCollectionViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/7/31.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGrassListCollectionViewCell.h"
#import "THNLifeRecordModel.h"
#import "UIImageView+WebCache.h"
#import "THNLifeRecordModel.h"

@interface THNGrassListCollectionViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;

@end

@implementation THNGrassListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 4;
}

-  (void)setLifeRecordModel:(THNLifeRecordModel *)lifeRecordModel {
    _lifeRecordModel = lifeRecordModel;
    self.contentLabel.text = lifeRecordModel.content;
    self.titleLabel.text = lifeRecordModel.title;
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:lifeRecordModel.cover]];
}

@end
