//
//  THNCategoriesCollectionViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/7/26.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNCategoriesCollectionViewCell.h"

@interface THNCategoriesCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *categoriesImageView;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleNumberLabel;

@end

@implementation THNCategoriesCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setCategoriesModel:(THNCategoriesModel *)categoriesModel {
    _categoriesModel = categoriesModel;
    
}

@end
