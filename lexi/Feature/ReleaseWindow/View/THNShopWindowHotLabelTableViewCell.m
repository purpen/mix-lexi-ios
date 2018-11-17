//
//  THNShopWindowHotLabelTableViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/11/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNShopWindowHotLabelTableViewCell.h"
#import "THNHotKeywordModel.h"
#import "NSString+Helper.h"

NSString *const shopWindowHotLabelCellIdentifier = @"shopWindowHotLabelCellIdentifier";

@interface THNShopWindowHotLabelTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleNumberLabel;

@end

@implementation THNShopWindowHotLabelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setHotKeywordModel:(THNHotKeywordModel *)hotKeywordModel {
    _hotKeywordModel = hotKeywordModel;
    self.nameLabel.text = [NSString stringWithFormat:@"# %@",hotKeywordModel.name];
    self.desLabel.hidden = hotKeywordModel.type == 0 ?: NO;
    
    NSString *numberStr;
    
    if (hotKeywordModel.numbers > 10000) {

        NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f", floor(hotKeywordModel.numbers)/ 10000]];
        numberStr = [NSString stringWithFormat:@"%@w", number];
    } else {
        numberStr = [NSString stringWithFormat:@"%ld", hotKeywordModel.numbers];
    }
  
    self.peopleNumberLabel.text = [NSString stringWithFormat:@"%@人参与", numberStr];
}


@end
