//
//  THNFollowStoreTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/8/20.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNFollowStoreTableViewCell.h"
#import "UIColor+Extension.h"
#import <Masonry/Masonry.h>
#import "UIImageView+WebImage.h"
#import "THNFollowStoreButton.h"
#import "THNFollowStoreButton+SelfManager.h"
#import "UIView+Helper.h"

static NSString *const kTableViewCellId = @"THNFollowStoreTableViewCellId";

@interface THNFollowStoreTableViewCell ()

/// 店铺头像
@property (nonatomic, strong) UIImageView *headerImageView;
/// 店铺名称
@property (nonatomic, strong) UILabel *titleLabel;
/// 商品数量
@property (nonatomic, strong) UILabel *goodsCountLabel;
/// 关注按钮
@property (nonatomic, strong) THNFollowStoreButton *followButton;

@end

@implementation THNFollowStoreTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupCellViewUI];
    }
    return self;
}

+ (instancetype)initStoreCellWithTableView:(UITableView *)tableView cellStyle:(UITableViewCellStyle)style {
    THNFollowStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellId];
    if (!cell) {
        cell = [[THNFollowStoreTableViewCell alloc] initWithStyle:style reuseIdentifier:kTableViewCellId];
        cell.tableView = tableView;
    }
    return cell;
}

#pragma mark - public methods
- (void)thn_setStoreData:(THNStoreModel *)model {
    [self.headerImageView loadImageWithUrl:[model.logo loadImageUrlWithType:(THNLoadImageUrlTypeAvatar)]];
    self.titleLabel.text = model.name;
    self.goodsCountLabel.text = [NSString stringWithFormat:@"%zi 件商品", model.productCount];
    [self.followButton selfManagerFollowStoreStatus:model.followedStatus storeModel:model];
    
    [self setNeedsUpdateConstraints];
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    [self addSubview:self.headerImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.goodsCountLabel];
    [self addSubview:self.followButton];
}

- (void)updateConstraints {
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(12);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(16);
        make.left.mas_offset(75);
        make.top.mas_offset(12);
        make.right.mas_equalTo(-100);
    }];
    
    [self.goodsCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(14);
        make.left.equalTo(self.titleLabel.mas_left).with.offset(0);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(8);
        make.right.mas_equalTo(-100);
    }];
    
    [self.followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(64, 30));
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self);
    }];
    
    [super updateConstraints];
}

#pragma mark - getters and setters
- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headerImageView.layer.masksToBounds = YES;
        _headerImageView.layer.cornerRadius = 2;
    }
    return _headerImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _titleLabel;
}

- (UILabel *)goodsCountLabel {
    if (!_goodsCountLabel) {
        _goodsCountLabel = [[UILabel alloc] init];
        _goodsCountLabel.font = [UIFont systemFontOfSize:12];
        _goodsCountLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _goodsCountLabel;
}

- (THNFollowStoreButton *)followButton {
    if (!_followButton) {
        _followButton = [[THNFollowStoreButton alloc] initWithType:(THNFollowButtonTypeStoreList)];
        _followButton.layer.cornerRadius = 4;
    }
    return _followButton;
}

@end
