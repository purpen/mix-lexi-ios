//
//  THNAllAnnouncementView.m
//  lexi
//
//  Created by HongpingRao on 2018/8/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNAllAnnouncementView.h"
#import "THNAnnouncementModel.h"
#import "NSString+Helper.h"
#import "UIView+Helper.h"

@interface THNAllAnnouncementView()

@property (weak, nonatomic) IBOutlet UILabel *announcementTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *closedTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryTimeLabel;
//遮罩
@property (weak, nonatomic) IBOutlet UIView *maskView;

@end

@implementation THNAllAnnouncementView

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (IBAction)close:(id)sender {
    [self removeFromSuperview];
}

- (void)setAnnouncementModel:(THNAnnouncementModel *)announcementModel {
    _announcementModel = announcementModel;
    NSString *beginDate = [NSString timeConversion:announcementModel.begin_date];
    NSString *endDate = [NSString timeConversion:announcementModel.end_date];
    NSString *deliveryDate = [NSString timeConversion:announcementModel.delivery_date];
    self.closedTimeLabel.text = [NSString stringWithFormat:@"%@-%@",beginDate,endDate];
    self.deliveryTimeLabel.text = deliveryDate;
    self.announcementTitleLabel.text = announcementModel.announcement;
}

@end
