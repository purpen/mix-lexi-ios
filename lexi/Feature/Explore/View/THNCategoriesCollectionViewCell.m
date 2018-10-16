//
//  THNCategoriesCollectionViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/7/26.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNCategoriesCollectionViewCell.h"
#import "THNCategoriesModel.h"
#import "UIImageView+WebCache.h"
#import "UIView+Helper.h"

@interface THNCategoriesCollectionViewCell()


@property (weak, nonatomic) IBOutlet UIView *categoriesBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *categoriesImageView;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleNumberLabel;

@end

@implementation THNCategoriesCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.categoriesBackgroundView drawCornerWithType:0 radius:self.categoriesBackgroundView.viewHeight / 2];
}

- (void)setCategoriesModel:(THNCategoriesModel *)categoriesModel {
    _categoriesModel = categoriesModel;
    self.desLabel.text = categoriesModel.name;
    self.peopleNumberLabel.text = [NSString stringWithFormat:@"%ld 人",categoriesModel.browse_count];
    [self.categoriesImageView sd_setImageWithURL:[NSURL URLWithString:categoriesModel.cover]placeholderImage:[UIImage imageNamed:@"default_image_place"]];
    
}

@end
