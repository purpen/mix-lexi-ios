//
//  THNSecondLevelCommentTableViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/8/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSecondLevelCommentTableViewCell.h"
#import "UIView+Helper.h"
#import "THNCommentModel.h"
#import "UIImageView+WebImage.h"
#import "NSString+Helper.h"
#import "UIColor+Extension.h"
#import "THNAPI.h"
#import "THNCommentSectionHeaderView.h"
#import "SVProgressHUD+Helper.h"
#import "THNMarco.h"
#import "THNCommentSectionHeaderView.h"

CGFloat const loadViewHeight = 30;
CGFloat const allSubCommentHeight = 66;

@interface THNSecondLevelCommentTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *praisesButton;
@property (nonatomic, strong) UIView *loadMoreView;
@property (nonatomic, strong) UIButton *loadMoreButton;

@end

@implementation THNSecondLevelCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSubCommentModel:(THNCommentModel *)subCommentModel {
    _subCommentModel = subCommentModel;

    [self.avatarImageView loadImageWithUrl:[subCommentModel.user_avatar loadImageUrlWithType:(THNLoadImageUrlTypeAvatar)]
                                  circular:YES];
    self.nameLabel.text = subCommentModel.user_name;
    self.contentLabel.text = subCommentModel.content;
    self.praisesButton.selected = subCommentModel.is_praise;
    [self layoutPraisesButton:subCommentModel.praise_count initWithSelect:subCommentModel.is_praise];
    NSString *currentTimestamp = [NSString getTimestamp];
    NSTimeInterval aTimer = [NSString comparisonStartTimestamp:subCommentModel.created_at endTimestamp:currentTimestamp];
    int hour = (int)(aTimer/3600);
    
    if (hour > 24) {
        self.timeLabel.text = [NSString timeConversion:subCommentModel.created_at initWithFormatterType:FormatterDay];
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
    
    if (self.isHiddenLoadMoreDataView) {
        self.loadMoreView.hidden = YES;
    } else {
        self.loadMoreView.hidden = NO;
        self.loadMoreView.frame = CGRectMake(0, subCommentModel.height + allSubCommentHeight, SCREEN_WIDTH - 82, loadViewHeight);
        [self.loadMoreButton setTitle:[NSString stringWithFormat:@"查看%ld条回复",self.commentModel.sub_comment_count] forState:UIControlStateNormal];
        [self addSubview:self.loadMoreView];
      
    }
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x += 62;
    frame.size.width -= 82;
    [super setFrame:frame];
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
    NSString *requestUrl = self.isShopWindow ? kUrlCommentsPraises : kLifeRecordsCommentsPraises;
    params[@"comment_id"] = @(self.subCommentModel.comment_id);
    THNRequest *request = [THNAPI postWithUrlString:requestUrl requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        self.subCommentModel.is_praise = YES;
        self.praisesButton.selected = YES;
        self.subCommentModel.praise_count += 1;
        [self layoutPraisesButton:self.subCommentModel.praise_count initWithSelect:YES];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

- (void)loadMoreSubCommentData {
    self.secondLevelBlock(self);
}

- (void)deletePraises {
    NSString *requestUrl = self.isShopWindow ? kUrlCommentsPraises : kLifeRecordsCommentsPraises;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"comment_id"] = @(self.subCommentModel.comment_id);
    THNRequest *request = [THNAPI deleteWithUrlString:requestUrl requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.success) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return;
        }
        
        self.subCommentModel.is_praise = NO;
        self.praisesButton.selected = NO;
        self.subCommentModel.praise_count -= 1;
        [self layoutPraisesButton:self.subCommentModel.praise_count initWithSelect:NO];
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

#pragma mark - lazy
- (UIView *)loadMoreView {
    if (!_loadMoreView) {
        _loadMoreView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH - 82, loadViewHeight)];
        UIButton *loadMoreButton = [[UIButton alloc]initWithFrame:_loadMoreView.bounds];
        _loadMoreButton = loadMoreButton;
        loadMoreButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [loadMoreButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        loadMoreButton.imageEdgeInsets = UIEdgeInsetsMake(0, 125, 0, 0);
        loadMoreButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 50);
        [loadMoreButton setImage:[UIImage imageNamed:@"icon_arrow_down"] forState:UIControlStateNormal];
        [loadMoreButton addTarget:self action:@selector(loadMoreSubCommentData) forControlEvents:UIControlEventTouchUpInside];
        loadMoreButton.backgroundColor = [UIColor colorWithHexString:@"F5F7F9"];
        [_loadMoreView drawCornerWithType:UILayoutCornerRadiusBottom radius:4];
        [_loadMoreView addSubview:loadMoreButton];
    }
    
    return _loadMoreView;
}

@end
