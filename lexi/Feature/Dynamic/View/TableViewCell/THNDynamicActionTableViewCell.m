//
//  THNDynamicActionTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/11/13.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNDynamicActionTableViewCell.h"
#import "UIColor+Extension.h"
#import <Masonry/Masonry.h>
#import "UIView+Helper.h"
#import "NSString+Helper.h"
#import "THNDynamicActionTableViewCell+Action.h"

static NSString *const kDynamicActionCellId = @"THNDynamicActionTableViewCellId";

@interface THNDynamicActionTableViewCell ()

@end

@implementation THNDynamicActionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupCellViewUI];
    }
    return self;
}

+ (instancetype)initDynamicActionCellWithTableView:(UITableView *)tableView {
    THNDynamicActionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDynamicActionCellId];
    if (!cell) {
        cell = [[THNDynamicActionTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:kDynamicActionCellId];
        cell.tableView = tableView;
    }
    return cell;
}

- (void)thn_setDynamicAcitonWithModel:(THNDynamicModelLines *)model {
    self.dynamicModel = model;
    self.dynamicRid = [NSString stringWithFormat:@"%zi", model.rid];
    
    [self thn_setDynamicActionButtonText:model.likeCount commentCount:model.commentCount];
    [self thn_likeDynamicWithStatusWithModel:model];
    [self thn_checkDynamicComment];
}

#pragma mark - private methods
- (void)thn_setDynamicActionButtonText:(NSInteger)likeCount commentCount:(NSInteger)commentCount {
    NSString *likeStr = [[NSString alloc] initWithFormat:@"%zi", likeCount];
    [self.likeButton setTitle:likeStr forState:(UIControlStateNormal)];
    CGFloat likeCountW = [likeStr boundingSizeWidthWithFontSize:11] + 35;
    [self.likeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(likeCountW, 40));
        make.left.mas_equalTo(20);
        make.centerY.equalTo(self);
    }];
    
    
    NSString *commentStr = [[NSString alloc] initWithFormat:@"%zi", commentCount];
    [self.commentButton setTitle:commentStr forState:(UIControlStateNormal)];
    CGFloat commentCountW = [commentStr boundingSizeWidthWithFontSize:11] + 35;
    [self.commentButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(commentCountW, 40));
        make.left.equalTo(self.likeButton.mas_right).with.offset(10);
        make.centerY.equalTo(self);
    }];
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.likeButton];
    [self addSubview:self.commentButton];
}

- (void)drawRect:(CGRect)rect {
    [UIView drawRectLineStart:CGPointMake(0, 0)
                          end:CGPointMake(CGRectGetWidth(self.bounds), 0)
                        width:1
                        color:[UIColor colorWithHexString:@"#E9E9E9"]];
}

#pragma mark - getters and setters
- (UIButton *)likeButton {
    if (!_likeButton) {
        _likeButton = [[UIButton alloc] init];
        [_likeButton setImage:[UIImage imageNamed:@"icon_unflow"] forState:(UIControlStateNormal)];
        [_likeButton setImage:[UIImage imageNamed:@"icon_flow"] forState:(UIControlStateSelected)];
        [_likeButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateNormal)];
        _likeButton.titleLabel.font = [UIFont systemFontOfSize:11];
        [_likeButton setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentLeft)];
        [_likeButton setTitleEdgeInsets:(UIEdgeInsetsMake(0, 3, 0, 0))];
    }
    return _likeButton;
}

- (UIButton *)commentButton {
    if (!_commentButton) {
        _commentButton = [[UIButton alloc] init];
        [_commentButton setImage:[UIImage imageNamed:@"icon_comment"] forState:(UIControlStateNormal)];
        [_commentButton setImage:[UIImage imageNamed:@"icon_comment"] forState:(UIControlStateSelected)];
        [_commentButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateNormal)];
        _commentButton.titleLabel.font = [UIFont systemFontOfSize:11];
        [_commentButton setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentLeft)];
        [_commentButton setTitleEdgeInsets:(UIEdgeInsetsMake(0, 3, 0, 0))];
    }
    return _commentButton;
}

@end
