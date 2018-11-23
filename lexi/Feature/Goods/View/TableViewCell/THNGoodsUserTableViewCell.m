//
//  THNGoodsUserTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/9/1.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsUserTableViewCell.h"
#import "THNGoodsModelProductLikeUsers.h"
#import "UIImageView+WebImage.h"
#import "THNUserModel.h"
#import <Masonry/Masonry.h>

static NSInteger const kHeaderButtonTag = 235;
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
        [headerView loadImageWithUrl:[model.avatar loadImageUrlWithType:(THNLoadImageUrlTypeAvatarSmall)]];
        
        [self addSubview:headerView];
        [self sendSubviewToBack:headerView];

        UIButton *headerButton = [[UIButton alloc] initWithFrame:CGRectMake(20 + 24 * idx, 10, 30, 30)];
        headerButton.tag = kHeaderButtonTag + [model.uid integerValue];
        [headerButton addTarget:self action:@selector(headerButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:headerButton];
    }
}

#pragma mark - event response
- (void)moreButtonAction:(id)sender {
    self.baseCell.selectedCellBlock(@"");
}

- (void)headerButtonAction:(UIButton *)button {
    NSString *userId = [NSString stringWithFormat:@"%zi", button.tag - kHeaderButtonTag];
    
    if ([self.delegate respondsToSelector:@selector(thn_didSelectedGoodsLikedUser:)]) {
        [self.delegate thn_didSelectedGoodsLikedUser:userId];
    }
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    [self addSubview:self.moreButton];
    
    [self setMasonryLayout];
}

- (void)setMasonryLayout {
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.right.mas_equalTo(-15);
        make.centerY.equalTo(self);
    }];
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
        _moreButton.layer.cornerRadius = 30/2;
        [_moreButton addTarget:self action:@selector(moreButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _moreButton;
}

@end
