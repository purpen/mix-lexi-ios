//
//  THNBrandHallInfoTableViewCell.m
//  lexi
//
//  Created by rhp on 2018/10/18.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBrandHallInfoTableViewCell.h"
#import "UIView+Helper.h"
#import "THNStoreModel.h"
#import "UIImageView+WebImage.h"
#import "NSString+Helper.h"

@interface THNBrandHallInfoTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *storeImageView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *openStoreDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeDesLabel;

@end


@implementation THNBrandHallInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setStoreModel:(THNStoreModel *)storeModel {
    _storeModel = storeModel;
    
    self.storeNameLabel.text = storeModel.name;
    self.cityLabel.text = storeModel.city;
    self.countryLabel.text = [NSString stringWithFormat:@"%@ .",storeModel.country];
    self.storeDesLabel.text = storeModel.tagLine;
    self.openStoreDateLabel.text = [NSString timeConversion:[NSString stringWithFormat:@"%ld",storeModel.createdAt ]initWithFormatterType:FormatterDay];
    [self.storeImageView loadImageWithUrl:[storeModel.logo loadImageUrlWithType:(THNLoadImageUrlTypeAvatar)]];
}

@end
