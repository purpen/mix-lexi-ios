//
//  THNGoodsDirectTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/9/1.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsDirectTableViewCell.h"

#define kNeedDays(day) [NSString stringWithFormat:@"“接单订制”在付款后开始制作，需%zi个制作天", day]

static NSString *const kTextDirect = @"请选择规格和尺码";
static NSString *const kTextInclude = @"（不包含节假日）";
static NSString *const kGoodsDirectTableViewCellId = @"kGoodsDirectTableViewCellId";

@interface THNGoodsDirectTableViewCell ()

/// 直接选择尺码、尺寸按钮
@property (nonatomic, strong) UIButton *directButton;
/// 定制商品提示说明
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

- (void)thn_setCustomNumberOfDays:(NSInteger)days isIncludeHolidays:(BOOL)isInclude {
    self.hintLabel.text = isInclude ? [NSString stringWithFormat:@"%@%@", kNeedDays(days), kTextInclude]: kNeedDays(days);
    self.hintLabel.hidden = days == 0 ? YES : NO;
}

#pragma mark - event response
- (void)directButtonAction:(id)sender {
    self.baseCell.selectedCellBlock();
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    [self addSubview:self.directButton];
    [self addSubview:self.hintLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.directButton.frame = CGRectMake(15, 0, CGRectGetWidth(self.bounds) - 30, 40);
    [self.directButton setImageEdgeInsets:(UIEdgeInsetsMake(0, CGRectGetWidth(self.bounds) - 58, 0, 0))];
    [self.directButton drawCornerWithType:(UILayoutCornerRadiusAll) radius:4];
    
    self.hintLabel.frame = CGRectMake(15, 40, CGRectGetWidth(self.bounds) - 30, 40);
}

#pragma mark - getters and setters
- (UIButton *)directButton {
    if (!_directButton) {
        _directButton = [[UIButton alloc] init];
        _directButton.backgroundColor = [UIColor colorWithHexString:@"#F0F4F7"];
        [_directButton setTitle:kTextDirect forState:(UIControlStateNormal)];
        [_directButton setTitleColor:[UIColor colorWithHexString:@"#555555"] forState:(UIControlStateNormal)];
        _directButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_directButton setImage:[UIImage imageNamed:@"icon_down_direct"] forState:(UIControlStateNormal)];
        [_directButton addTarget:self action:@selector(directButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _directButton;
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
