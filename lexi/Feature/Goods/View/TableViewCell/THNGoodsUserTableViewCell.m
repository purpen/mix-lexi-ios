//
//  THNGoodsUserTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/9/1.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsUserTableViewCell.h"
#import "THNGoodsModelProductLikeUser.h"
#include "UIImageView+SDWedImage.h"
#import "THNUserModel.h"

static NSString *const kGoodUserTableViewCellId = @"kGoodUserTableViewCellId";

@interface THNGoodsUserTableViewCell ()

/// 查看更多按钮
@property (nonatomic, strong) UIButton *moreButton;

@end

@implementation THNGoodsUserTableViewCell

+ (instancetype)initGoodsCellWithTableView:(UITableView *)tableView cellStyle:(UITableViewCellStyle)style {
    THNGoodsUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGoodUserTableViewCellId];
    if (!cell) {
        cell = [[THNGoodsUserTableViewCell alloc] initWithStyle:style reuseIdentifier:kGoodUserTableViewCellId];
        cell.tableView = tableView;
    }
    return cell;
}

- (void)thn_setLikedUserData:(NSArray *)data {
    self.moreButton.hidden = !data.count;
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        };
    }
    
    for (NSUInteger idx = 0; idx < data.count; idx ++) {
        THNUserModel *model = data[idx];
        UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(20 + 24 * idx, 10, 30, 30)];
        headerView.contentMode = UIViewContentModeScaleAspectFill;
        headerView.layer.borderWidth = 1;
        headerView.layer.borderColor = [UIColor whiteColor].CGColor;
        headerView.layer.cornerRadius = 30/2;
        headerView.layer.masksToBounds = YES;
        [headerView downloadImage:model.avatar place:[UIImage imageNamed:@"default_user_place"]];
        
        [self addSubview:headerView];
        [self sendSubviewToBack:headerView];
    }
}

#pragma mark - event response
- (void)moreButtonAction:(id)sender {
    self.baseCell.selectedCellBlock(@"");
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    [self addSubview:self.moreButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.moreButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - 45, 10, 30, 30);
    self.moreButton.layer.cornerRadius = 30/2;
}

- (void)drawRect:(CGRect)rect {
    [UIView drawRectLineStart:CGPointMake(0, 0)
                          end:CGPointMake(CGRectGetWidth(self.bounds), 0)
                        width:0.5
                        color:[UIColor colorWithHexString:@"#E9E9E9"]];
}

#pragma mark - getters and setters
- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [[UIButton alloc] init];
        [_moreButton setImage:[UIImage imageNamed:@"icon_more_gray"] forState:(UIControlStateNormal)];
        _moreButton.backgroundColor = [UIColor whiteColor];
        _moreButton.layer.borderWidth = 1;
        _moreButton.layer.borderColor = [UIColor colorWithHexString:@"#E9E9E9"].CGColor;
        [_moreButton addTarget:self action:@selector(moreButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _moreButton;
}

@end
