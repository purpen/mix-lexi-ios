//
//  THNGoodsStoreTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/9/1.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsStoreTableViewCell.h"
#import "THNFollowStoreButton.h"
#import "THNFollowStoreButton+SelfManager.h"

static NSString *const kTextType = @"原创品牌设计馆";
static NSString *const kGoodsStoreTableViewCellId = @"kGoodsStoreTableViewCellId";

@interface THNGoodsStoreTableViewCell ()

/// 店铺头像
@property (nonatomic, strong) UIImageView *headerImageView;
/// 店铺名称
@property (nonatomic, strong) UILabel *titleLabel;
/// 店铺类型名称
@property (nonatomic, strong) UILabel *typeLabel;
/// 关注按钮
@property (nonatomic, strong) THNFollowStoreButton *followButton;

@end

@implementation THNGoodsStoreTableViewCell

+ (instancetype)initGoodsCellWithTableView:(UITableView *)tableView cellStyle:(UITableViewCellStyle)style {
    THNGoodsStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGoodsStoreTableViewCellId];
    if (!cell) {
        cell = [[THNGoodsStoreTableViewCell alloc] initWithStyle:style reuseIdentifier:kGoodsStoreTableViewCellId];
        cell.tableView = tableView;
    }
    return cell;
}

- (void)thn_setGoodsStoreInfoWithModel:(THNStoreModel *)model {
    [self.headerImageView downloadImage:model.logo place:[UIImage imageNamed:@"default_header_place"]];
    self.typeLabel.text = kTextType;
    self.titleLabel.text = model.name;
    [self.followButton selfManagerFollowStoreStatus:model.followedStatus storeRid:model.rid];
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    [self addSubview:self.headerImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.typeLabel];
    [self addSubview:self.followButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.top.left.mas_equalTo(15);
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(13);
        make.left.equalTo(self.headerImageView.mas_right).with.offset(10);
        make.top.equalTo(self.headerImageView.mas_top).with.offset(5);
        make.right.mas_equalTo(-100);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(16);
        make.left.equalTo(self.typeLabel.mas_left).with.offset(0);
        make.top.equalTo(self.typeLabel.mas_bottom).with.offset(6);
        make.right.mas_equalTo(-100);
    }];
    
    [self.followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(64, 30));
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.headerImageView);
    }];
    [self.followButton drawCornerWithType:(UILayoutCornerRadiusAll) radius:4];
}

- (void)drawRect:(CGRect)rect {
    [UIView drawRectLineStart:CGPointMake(15, CGRectGetHeight(self.bounds) - 10)
                          end:CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 10)
                        width:0.5
                        color:[UIColor colorWithHexString:@"#E9E9E9"]];
}

#pragma mark - getters and setters
- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _headerImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _titleLabel;
}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.font = [UIFont systemFontOfSize:12];
        _typeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _typeLabel;
}

- (THNFollowStoreButton *)followButton {
    if (!_followButton) {
        _followButton = [[THNFollowStoreButton alloc] initWithType:(THNFollowButtonTypeGoodsInfo)];
    }
    return _followButton;
}

@end
