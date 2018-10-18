//
//  THNBrandHallInfoTableViewCell.m
//  lexi
//
//  Created by rhp on 2018/10/18.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBrandHallInfoTableViewCell.h"
#import "UIView+Helper.h"

@interface THNBrandHallInfoTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *storeImageView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *openStoreDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeDesLabel;
@property (weak, nonatomic) IBOutlet UIView *topView;

@end


@implementation THNBrandHallInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.topView drawCornerWithType:UILayoutCornerRadiusTop radius:15];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
