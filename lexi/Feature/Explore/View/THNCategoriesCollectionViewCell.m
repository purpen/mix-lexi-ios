//
//  THNCategoriesCollectionViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/7/26.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNCategoriesCollectionViewCell.h"
#import "THNCategoriesModel.h"
#import "UIImageView+WebImage.h"
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
    
    [self.categoriesImageView loadImageWithUrl:[categoriesModel.cover loadImageUrlWithType:(THNLoadImageUrlTypeAvatar)]];
    
    NSString *numberStr;
    
    if (categoriesModel.browse_count > 100000) {
        
        NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f", floor(categoriesModel.browse_count)/ 10000]];
        numberStr = [NSString stringWithFormat:@"%@w", number];
    } else {
        numberStr = [NSString stringWithFormat:@"%ld", categoriesModel.browse_count];
    }
    
    self.peopleNumberLabel.text = [NSString stringWithFormat:@"%@ 人", numberStr];
}

@end
