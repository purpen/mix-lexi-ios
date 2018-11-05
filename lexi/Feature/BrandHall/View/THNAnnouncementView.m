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
#import "UIView+Helper.h"
#import "YYLabel+Helper.h"
#import <Masonry/Masonry.h>
#import "UIColor+Extension.h"
#import "THNAllAnnouncementView.h"

@interface THNAnnouncementView()

@property (weak, nonatomic) IBOutlet UILabel *closedTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *closeTimeView;
@property (weak, nonatomic) IBOutlet UIView *announcementTitleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *announcementViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *closeTimeViewHeightConstraint;
@property (nonatomic,strong) YYLabel *label;
@property (nonatomic, strong) THNAllAnnouncementView *allAnnouncementView;

@end

@implementation THNAnnouncementView

- (void)setAnnouncementModel:(THNAnnouncementModel *)announcementModel {
    _announcementModel = announcementModel;
    NSString *beginDate = [NSString timeConversion:announcementModel.begin_date initWithFormatterType:FormatterDay];
    NSString *endDate = [NSString timeConversion:announcementModel.end_date initWithFormatterType:FormatterDay];
    NSString *deliveryDate = [NSString timeConversion:announcementModel.delivery_date initWithFormatterType:FormatterDay];
    self.closedTimeLabel.text = [NSString stringWithFormat:@"%@-%@",beginDate,endDate];
    self.deliveryTimeLabel.text = deliveryDate;
    
    if (announcementModel.is_closed) {
        self.closeTimeView.hidden = NO;
    } else {
        self.closeTimeView.hidden = YES;
        self.closeTimeViewHeightConstraint.constant = 0;
        self.announcementViewTopConstraint.constant = -12;
    }
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:announcementModel.announcement];
    [self layoutAnnouncementTextLabel:attributedString];
    
}

- (void)layoutAnnouncementTextLabel:(NSAttributedString *)text {
    
    _label = [YYLabel new];
    _label.userInteractionEnabled = YES;
    _label.textVerticalAlignment = YYTextVerticalAlignmentTop;
    _label.attributedText = text;
    _label.numberOfLines = 2;
    _label.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
    _label.textColor = [UIColor colorWithHexString:@"666666"];
    [self.announcementTitleView addSubview:self.label];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.announcementTitleView);
        make.leading.equalTo(self.announcementTitleView).with.offset(15);
        make.trailing.equalTo(self.announcementTitleView).with.offset(-20);
        make.height.equalTo(@37);
    }];
   
    
    // 添加阅读更多
    [self addSeeMoreButton];
}

- (void)addSeeMoreButton {
    __weak typeof(self)weakSelf = self;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"...阅读更多"];
    
    YYTextHighlight *hi = [YYTextHighlight new];
    [hi setColor:[UIColor colorWithHexString:@"6ED7AF"]];
    
    hi.tapAction = ^(UIView *containerView,NSAttributedString *text,NSRange range, CGRect rect) {
        UIWindow *window  = [UIApplication sharedApplication].keyWindow;
        weakSelf.allAnnouncementView.frame = window.bounds;
        weakSelf.allAnnouncementView.announcementModel = weakSelf.announcementModel;
        [window addSubview:weakSelf.allAnnouncementView];
    };
    
    
    [text setColor:[UIColor colorWithHexString:@"6ED7AF"] range:[text.string rangeOfString:@"阅读更多"]];
    
    [text setTextHighlight:hi range:[text.string rangeOfString:@"阅读更多"]];
    text.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    
    
    YYLabel *seeMore = [YYLabel new];
    seeMore.attributedText = text;
    [seeMore sizeToFit];
    
    
    NSAttributedString *truncationToken = [NSAttributedString attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize:seeMore.frame.size alignToFont:text.font alignment:YYTextVerticalAlignmentCenter];
    
    _label.truncationToken = truncationToken;
}

- (THNAllAnnouncementView *)allAnnouncementView {
    if (!_allAnnouncementView) {
        _allAnnouncementView = [THNAllAnnouncementView viewFromXib];
    }
    return _allAnnouncementView;
}


@end
