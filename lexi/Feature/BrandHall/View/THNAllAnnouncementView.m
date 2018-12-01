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
#import "UIColor+Extension.h"
#import "THNMarco.h"

@interface THNAllAnnouncementView()

@property (weak, nonatomic) IBOutlet UILabel *announcementTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *closedTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *closeTintView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *closeTintViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *closeTintViewTopConstraint;

@end

@implementation THNAllAnnouncementView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.closeTintViewTopConstraint.constant = NAVIGATION_BAR_HEIGHT;
}


- (IBAction)close:(id)sender {
    [self removeFromSuperview];
}

- (void)setAnnouncementModel:(THNAnnouncementModel *)announcementModel {
    _announcementModel = announcementModel;
    self.closeTintView.hidden = !announcementModel.is_closed;
    self.closeTintViewHeightConstraint.constant = announcementModel.is_closed ? 100 : 0;
    NSString *beginDate = [NSString timeConversion:announcementModel.begin_date initWithFormatterType:FormatterDay];
    NSString *endDate = [NSString timeConversion:announcementModel.end_date initWithFormatterType:FormatterDay];
    NSString *deliveryDate = [NSString timeConversion:announcementModel.delivery_date initWithFormatterType:FormatterDay];
    self.closedTimeLabel.text = [NSString stringWithFormat:@"%@-%@",beginDate,endDate];
    self.deliveryTimeLabel.text = deliveryDate;
    self.announcementTitleLabel.text = announcementModel.announcement;
}

@end
