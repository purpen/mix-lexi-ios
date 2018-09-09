//
//  THNOrderDetailTableViewCell.m
//  lexi
//
//  Created by rhp on 2018/9/9.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNOrderDetailTableViewCell.h"

@interface THNOrderDetailTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *originalMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *modeLabel;

@end

@implementation THNOrderDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
