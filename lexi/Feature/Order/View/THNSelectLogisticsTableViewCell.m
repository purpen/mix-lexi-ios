//
//  THNSelectLogisticsTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/9/11.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSelectLogisticsTableViewCell.h"
#import <Masonry/Masonry.h>
#import "UIColor+Extension.h"

static NSString *const kSelectLogisticsTableViewCellId = @"kSelectLogisticsTableViewCellId";
///
#define kTextExpressTime(min, max) [NSString stringWithFormat:@"物流时长：%@至%@天送达", min, max]

@interface THNSelectLogisticsTableViewCell ()

/// icon
@property (nonatomic, strong) UIImageView *iconImageView;
/// 名称
@property (nonatomic, strong) UILabel *nameLabel;
/// 时间
@property (nonatomic, strong) UILabel *timeLabel;
/// 价格
@property (nonatomic, strong) UILabel *pricelabel;
/// 选择按钮
@property (nonatomic, strong) UIButton *selectButton;

@end

@implementation THNSelectLogisticsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupCellViewUI];
    }
    return self;
}

+ (instancetype)initSelectLogisticsCellWithTableView:(UITableView *)tableView cellStyle:(UITableViewCellStyle)style {
    THNSelectLogisticsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSelectLogisticsTableViewCellId];
    if (!cell) {
        cell = [[THNSelectLogisticsTableViewCell alloc] initWithStyle:style reuseIdentifier:kSelectLogisticsTableViewCellId];
    }
    return cell;
}

+ (instancetype)initSelectLogisticsCellWithTableView:(UITableView *)tableView {
    return [self initSelectLogisticsCellWithTableView:tableView cellStyle:(UITableViewCellStyleDefault)];
}

- (void)thn_setLogisticsDataWithModel:(THNFreightModelItem *)model {
    self.nameLabel.text = model.expressName;
    self.timeLabel.text = kTextExpressTime(@(model.minDays), @(model.maxDays));
    self.pricelabel.text = [NSString stringWithFormat:@"￥%.2f", model.firstAmount];
    self.selected = model.isDefault;
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    [self addSubview:self.selectButton];
    [self addSubview:self.iconImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.pricelabel];
    
    self.nameLabel.text = @"顺丰速运";
    self.timeLabel.text = kTextExpressTime(@1, @3);
    self.pricelabel.text = [NSString stringWithFormat:@"￥%.2f", 18.0];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(25);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(17, 17));
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(26);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(42);
        make.right.mas_equalTo(-60);
        make.height.mas_equalTo(15);
        make.top.mas_equalTo(20);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(42);
        make.right.mas_equalTo(-60);
        make.height.mas_equalTo(15);
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(7);
    }];
    
    [self.pricelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(42);
        make.right.mas_equalTo(-60);
        make.height.mas_equalTo(15);
        make.top.equalTo(self.timeLabel.mas_bottom).with.offset(7);
    }];
}

#pragma mark - getters and setters
- (void)setSelected:(BOOL)selected {
    self.selectButton.selected = selected;
}

- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [[UIButton alloc] init];
        [_selectButton setImage:[UIImage imageNamed:@"icon_selected_none"] forState:(UIControlStateNormal)];
        [_selectButton setImage:[UIImage imageNamed:@"icon_selected_main"] forState:(UIControlStateSelected)];
        _selectButton.imageView.contentMode = UIViewContentModeCenter;
        [_selectButton setImageEdgeInsets:(UIEdgeInsetsMake(0, -15, 0, 0))];
        _selectButton.selected = NO;
    }
    return _selectButton;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_store_practice"]];
        _iconImageView.contentMode = UIViewContentModeCenter;
    }
    return _iconImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightLight)];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _timeLabel;
}

- (UILabel *)pricelabel {
    if (!_pricelabel) {
        _pricelabel = [[UILabel alloc] init];
        _pricelabel.font = [UIFont systemFontOfSize:12];
        _pricelabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _pricelabel;
}

@end
