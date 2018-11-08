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
#import <SVProgressHUD/SVProgressHUD.h>
#import "UIColor+Extension.h"

static NSString *const kUrlAddSubComment = @"/shop_windows/comments";
NSString *const kUrlCommentsPraises = @"/shop_windows/comments/praises";

@interface THNCommentSectionHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentlabel;
@property (weak, nonatomic) IBOutlet UIButton *praisesButton;

@end

@implementation THNCommentSectionHeaderView

- (void)setCommentModel:(THNCommentModel *)commentModel {
    _commentModel = commentModel;
    [self.avatarImageView thn_setCircleImageWithUrlString:commentModel.user_avatar placeholder:[UIImage imageNamed:@"default_user_place"]];
    self.nameLabel.text = commentModel.user_name;
    self.contentlabel.text = commentModel.content;
    self.praisesButton.selected = commentModel.is_praise;
    [self layoutPraisesButton:self.commentModel.praise_count initWithSelect:commentModel.is_praise];
    NSString *currentTimestamp = [NSString getTimestamp];
    NSTimeInterval aTimer = [NSString comparisonStartTimestamp:commentModel.created_at endTimestamp:currentTimestamp];
    int hour = (int)(aTimer/3600);
    
    if (hour > 48) {
        self.timeLabel.text = [NSString timeConversion:commentModel.created_at initWithFormatterType:FormatterDay];
    } else if (hour <= 48 && hour >= 24) {
        self.timeLabel.text = @"昨天";
    } else if (hour <= 24 && hour >= 1) {
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

- (void)layoutPraisesButton:(NSInteger)praiseCount initWithSelect:(BOOL)isSelect {
    if (isSelect) {
        [self.praisesButton setTitleColor:[UIColor colorWithHexString:@"FF6666"] forState:UIControlStateNormal];
    } else {
        [self.praisesButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    }
    NSString *praisesBtnTitle = praiseCount == 0 ? @"赞" : [NSString stringWithFormat:@"%ld", praiseCount];
    [self.praisesButton setTitle:praisesBtnTitle forState:UIControlStateNormal];
}

- (void)addPraises {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"comment_id"] = @(self.commentModel.comment_id);
    THNRequest *request = [THNAPI postWithUrlString:kUrlCommentsPraises requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
            [SVProgressHUD showInfoWithStatus:result.statusMessage];
            return;
        }
        
        self.commentModel.is_praise = YES;
        self.praisesButton.selected = YES;
        self.commentModel.praise_count += 1;
        [self layoutPraisesButton:self.commentModel.praise_count initWithSelect:YES];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

- (void)deletePraises {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"comment_id"] = @(self.commentModel.comment_id);
    THNRequest *request = [THNAPI deleteWithUrlString:kUrlCommentsPraises requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
            [SVProgressHUD showInfoWithStatus:result.statusMessage];
            return;
        }
        
        self.commentModel.is_praise = NO;
        self.praisesButton.selected = NO;
        self.commentModel.praise_count -= 1;
        [self layoutPraisesButton:self.commentModel.praise_count initWithSelect:NO];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

// 赞
- (IBAction)reply:(UIButton *)sender {
    if (self.praisesButton.selected) {
        [self deletePraises];
    } else {
        [self addPraises];
    }
}

// 回复
- (IBAction)awesome:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"rid"] = self.shopWindowRid;
    params[@"pid"] = @(self.commentModel.comment_id);
    params[@"content"] = @"登记上了飞机撒垃圾分类三等奖法拉盛结束啦根据阿里宫颈癌钢结构";
    THNRequest *request = [THNAPI postWithUrlString:kUrlAddSubComment requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {

    } failure:^(THNRequest *request, NSError *error) {

    }];
}


@end
