//
//  THNSectionHeaderView.m
//  lexi
//
//  Created by HongpingRao on 2018/11/6.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNCommentSectionHeaderView.h"
#import "THNCommentModel.h"
#import "UIImageView+SDWedImage.h"
#import "THNAPI.h"
#import "NSString+Helper.h"

static NSString *const kUrlAddSubCommentUrl = @"/shop_windows/comments";

@interface THNCommentSectionHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentlabel;

@end

@implementation THNCommentSectionHeaderView

- (void)setCommentModel:(THNCommentModel *)commentModel {
    _commentModel = commentModel;
    [self.avatarImageView thn_setCircleImageWithUrlString:commentModel.user_avatar placeholder:[UIImage imageNamed:@"default_user_place"]];
    self.nameLabel.text = commentModel.user_name;
    self.contentlabel.text = commentModel.content;
    NSString *currentTimestamp = [NSString getTimestamp];
    NSTimeInterval aTimer = [NSString comparisonStartTimestamp:commentModel.created_at endTimestamp:currentTimestamp];
    int hour = (int)(aTimer/3600);
    
    if (hour > 48) {
        self.timeLabel.text = [NSString timeConversion:commentModel.created_at initWithFormatterType:FormatterDay];
    } else if (hour <= 24 && hour >= 12) {
        self.timeLabel.text = @"昨天";
    } else if (hour <= 12 && hour >= 1) {
        self.timeLabel.text =  self.timeLabel.text = [NSString stringWithFormat:@"%d小时前",hour];
    } else if (hour < 1) {
        NSInteger min = aTimer / 60;
        if (min < 1) {
            self.timeLabel.text = @"刚刚";
        } else {
            self.timeLabel.text = [NSString stringWithFormat:@"%ld分钟前",min];
        }
    }
}


// 赞
- (IBAction)reply:(id)sender {
    
}

// 回复
- (IBAction)awesome:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = self.shopWindowRid;
    params[@"pid"] = @(self.commentModel.comment_id);
    params[@"content"] = @"登记上了飞机撒垃圾分类三等奖法拉盛结束啦根据阿里宫颈癌钢结构";
    THNRequest *request = [THNAPI postWithUrlString:kUrlAddSubCommentUrl requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {

    } failure:^(THNRequest *request, NSError *error) {

    }];
}


@end
