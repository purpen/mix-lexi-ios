//
//  THNAnnouncementView.m
//  lexi
//
//  Created by HongpingRao on 2018/8/28.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNAnnouncementView.h"
#import "THNAnnouncementModel.h"
#import "NSString+Helper.h"

@interface THNAnnouncementView()

@property (weak, nonatomic) IBOutlet UILabel *closedTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *announcementTextLabel;

@end

@implementation THNAnnouncementView

- (void)setAnnouncementModel:(THNAnnouncementModel *)announcementModel {
    _announcementModel = announcementModel;
    NSString *beginDate = [NSString timeConversion:announcementModel.begin_date];
    NSString *endDate = [NSString timeConversion:announcementModel.end_date];
    NSString *deliveryDate = [NSString timeConversion:announcementModel.delivery_date];
    self.closedTimeLabel.text = [NSString stringWithFormat:@"%@-%@",beginDate,endDate];
    self.deliveryTimeLabel.text = deliveryDate;
    self.announcementTextLabel.text = announcementModel.announcement;
}

@end
