//
//  THNBannnerCollectionViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/7/26.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBannnerCollectionViewCell.h"
#import "UIView+Helper.h"
#import "UIImageView+WebCache.h"
#import "THNSetModel.h"

@implementation THNBannnerCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 4;
}

- (void)setSetModel:(THNSetModel *)setModel {
    
    if ([setModel.type isEqualToString:@"avatar"]) {
       self.layer.cornerRadius = self.viewHeight / 2;
    }
    
    [self.cellImageView sd_setImageWithURL:[NSURL URLWithString:@"https://kg.erp.taihuoniao.com/20180706/4605FpseCHcjdicYOsLROtwF_SVFKg_9.jpg"]];
}

@end
