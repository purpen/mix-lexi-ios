//
//  THNGoodsDirectTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/9/1.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsDirectTableViewCell.h"
#import <Masonry/Masonry.h>

#define kNeedDays(day) [NSString stringWithFormat:@"“接单订制”在付款后开始制作，需%zi个制作天", day]

/// text
static NSString *const kTextDirect  = @"请选择规格和尺码";
static NSString *const kTextInclude = @"（不包含节假日）";
///
static NSString *const kGoodsDirectTableViewCellId = @"kGoodsDirectTableViewCellId";

@interface THNGoodsDirectTableViewCell ()

/// 直接选择尺码、尺寸按钮
@property (nonatomic, strong) UIButton *directButton;
/// icon
@property (nonatomic, strong) UIImageView *iconImageView;
/// 订制商品提示说明
@property (nonatomic, strong) UILabel *hintLabel;

@end

@implementation THNGoodsDirectTableViewCell

+ (instancetype)initGoodsCellWithTableView:(UITableView *)tableView cellStyle:(UITableViewCellStyle)style {
    THNGoodsDirectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGoodsDirectTableViewCellId];
    if (!cell) {
        cell = [[THNGoodsDirectTableViewCell alloc] initWithStyle:style reuseIdentifier:kGoodsDirectTableViewCellId];
        cell.tableView = tableView;
    }
    return cell;
}

- (void)thn_setCustomDaysWithGoodsModel:(THNGoodsModel *)model {
    self.hintLabel.text = model.isMadeHoliday ? [NSString stringWithFormat:@"%@%@", kNeedDays(model.madeCycle), kTextInclude] : kNeedDays(model.madeCycle);
    self.hintLabel.hidden = !model.isCustomService;
}

- (void)thn_setCustomNumberOfDays:(NSInteger)days isIncludeHolidays:(BOOL)isInclude {
    self.hintLabel.text = isInclude ? [NSString stringWithFormat:@"%@%@", kNeedDays(days), kTextInclude]: kNeedDays(days);
    self.hintLabel.hidden = days == 0 ? YES : NO;
}

#pragma mark - event response
- (void)directButtonAction:(id)sender {
    self.baseCell.selectedCellBlock(@"");
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    [self addSubview:self.directButton];
    [self addSubview:self.iconImageView];
    [self addSubview:self.hintLabel];
}

- (void)updateConstraints {
    [self.directButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(0);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(10, 10));
        make.right.equalTo(self.directButton.mas_right).with.offset(-10);
        make.centerY.equalTo(self.directButton);
    }];
    
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.equalTo(self.directButton.mas_bottom).with.offset(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [super updateConstraints];
}

#pragma mark - getters and setters
- (UIButton *)directButton {
    if (!_directButton) {
        _directButton = [[UIButton alloc] init];
        _directButton.backgroundColor = [UIColor colorWithHexString:@"#F0F4F7"];
        [_directButton setTitle:kTextDirect forState:(UIControlStateNormal)];
        [_directButton setTitleColor:[UIColor colorWithHexString:@"#555555"] forState:(UIControlStateNormal)];
        _directButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _directButton.layer.cornerRadius = 4;
        [_directButton addTarget:self action:@selector(directButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _directButton;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_down_direct"]];
        _iconImageView.contentMode = UIViewContentModeCenter;
    }
    return _iconImageView;
}

- (UILabel *)hintLabel {
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.font = [UIFont systemFontOfSize:11];
        _hintLabel.textColor = [UIColor colorWithHexString:@"#555555"];
        _hintLabel.hidden = YES;
    }
    return _hintLabel;
}

@end
