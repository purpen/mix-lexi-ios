//
//  THNLivingHallHeadLineTableViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/12/14.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLivingHallHeadLineTableViewCell.h"
#import "UIImageView+WebImage.h"
#import "THNLivingHallHeadLineModel.h"
#import "UIView+Helper.h"

NSString *const livingHallHeadLineCellIdentifier = @"livingHallHeadLineCellIdentifier";

@interface THNLivingHallHeadLineTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *tintLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;


@end

@implementation THNLivingHallHeadLineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self drawCornerWithType:0 radius:self.viewHeight];
}

- (void)setHeadLineModel:(THNLivingHallHeadLineModel *)headLineModel {
    _headLineModel = headLineModel;
    NSString *headLineStr;
    if (headLineModel.event == HeadlineShowTypeOpen) {
         headLineStr = [NSString stringWithFormat:@"%@%@开了生活馆", headLineModel.time, headLineModel.time_info];
    } else {
        NSString *saleOrderCountStr = [NSString stringWithFormat:@"售出%ld单", headLineModel.quantity];
        headLineStr = [NSString stringWithFormat:@"%@%@%@", headLineModel.time, headLineModel.time_info, saleOrderCountStr];
    }
    
    self.tintLabel.text = headLineStr;
    [self.avatarImageView loadImageWithUrl:headLineModel.avatar circular:YES];
}

- (void)setFrame:(CGRect)frame {
    frame.origin.y += 10;
    frame.size.height -= 10;
    [super setFrame:frame];
}

@end
