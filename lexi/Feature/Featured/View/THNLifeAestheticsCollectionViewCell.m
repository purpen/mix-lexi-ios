//
//  THNLifeAestheticsCollectionViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/7/31.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLifeAestheticsCollectionViewCell.h"
#import "UIView+Helper.h"
#import "UIImageView+WebImage.h"
#import "THNShopWindowModel.h"
#import "THNProductModel.h"
#import <MJExtension/MJExtension.h>
#import "UIColor+Extension.h"

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
    self.rightTopImageView.layer.masksToBounds = YES;
    self.rightBottomImageView.layer.masksToBounds = YES;
    self.leftImageView.layer.masksToBounds = YES;
    [self drwaShadow];
}

- (void)setLifeRecordModel:(THNShopWindowModel *)lifeRecordModel {
    _lifeRecordModel = lifeRecordModel;
    self.nameLabel.text = lifeRecordModel.user_name;
    self.contentLabel.text = lifeRecordModel.des;
    self.titleLabel.text = lifeRecordModel.title;
    [self.avatarImageView loadImageWithUrl:[lifeRecordModel.user_avatar loadImageUrlWithType:(THNLoadImageUrlTypeAvatar)]
                                  circular:YES];
    [lifeRecordModel.products enumerateObjectsUsingBlock:^(THNProductModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        THNProductModel *productModel = [THNProductModel mj_objectWithKeyValues:obj];
        switch (idx) {
            case 0:
                [self.leftImageView loadImageWithUrl:productModel.cover];
                break;
            case 1:
                [self.rightTopImageView loadImageWithUrl:productModel.cover];
                break;
            default:
                [self.rightBottomImageView loadImageWithUrl:productModel.cover];
                break;
        }
        
    }];
    
}

@end
