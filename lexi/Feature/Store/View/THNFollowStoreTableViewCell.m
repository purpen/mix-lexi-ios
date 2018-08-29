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
#import "UIImageView+SDWedImage.h"
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
    [self.headerImageView downloadImage:model.logo place:[UIImage imageNamed:@"default_image_place"]];
    self.titleLabel.text = model.name;
    self.goodsCountLabel.text = [NSString stringWithFormat:@"%zi 件商品", model.store_products_counts];
    [self.followButton selfManagerFollowStoreStatus:(BOOL)model.followed_status storeRid:model.rid];
    
    [self layoutIfNeeded];
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    [self addSubview:self.headerImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.goodsCountLabel];
    [self addSubview:self.followButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(12);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(16);
        make.left.equalTo(self.headerImageView.mas_right).with.offset(10);
        make.top.equalTo(self.headerImageView.mas_top).with.offset(0);
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
        make.centerY.mas_equalTo(self.headerImageView);
    }];
    [self.followButton drawCornerWithType:(UILayoutCornerRadiusAll) radius:4];
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
    }
    return _followButton;
}

@end
