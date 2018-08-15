//
//  THNLifeAestheticsCollectionViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/7/31.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLifeAestheticsCollectionViewCell.h"
#import "UIView+Helper.h"
#import "UIImageView+WebCache.h"
#import "THNLifeRecordModel.h"
#import "THNProductModel.h"
#import <MJExtension/MJExtension.h>

@interface THNLifeAestheticsCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightTopImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightBottomImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@end


@implementation THNLifeAestheticsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self drwaShadow];
    [self.avatarImageView drawCornerWithType:0 radius:self.avatarImageView.viewHeight / 2];
}

- (void)setLifeRecordModel:(THNLifeRecordModel *)lifeRecordModel {
    _lifeRecordModel = lifeRecordModel;
    self.nameLabel.text = lifeRecordModel.user_name;
    self.contentLabel.text = lifeRecordModel.des;
    self.titleLabel.text = lifeRecordModel.title;
    [lifeRecordModel.products enumerateObjectsUsingBlock:^(THNProductModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        THNProductModel *productModel = [THNProductModel mj_objectWithKeyValues:obj];
        switch (idx) {
            case 0:
                [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:productModel.cover]];
                break;
            case 1:
                [self.rightTopImageView sd_setImageWithURL:[NSURL URLWithString:productModel.cover]];
            default:
                [self.rightBottomImageView sd_setImageWithURL:[NSURL URLWithString:productModel.cover]];
                break;
        }
        
    }];
    
}

@end
