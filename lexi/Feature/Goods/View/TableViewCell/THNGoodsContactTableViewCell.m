//
//  THNGoodsContactTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/9/2.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsContactTableViewCell.h"

static NSString *const kGoodsContactTableViewCellId = @"kGoodsContactTableViewCellId";
static NSString *const kTextContact = @"在线咨询";

@interface THNGoodsContactTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end;

@implementation THNGoodsContactTableViewCell

+ (instancetype)initGoodsCellWithTableView:(UITableView *)tableView cellStyle:(UITableViewCellStyle)style {
    THNGoodsContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGoodsContactTableViewCellId];
    if (!cell) {
        cell = [[THNGoodsContactTableViewCell alloc] initWithStyle:style reuseIdentifier:kGoodsContactTableViewCellId];
        cell.tableView = tableView;
    }
    return cell;
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    [self addSubview:self.titleLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 14));
        make.bottom.mas_equalTo(-14);
        make.centerX.mas_equalTo(self);
    }];
}

#pragma mark - getters and setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor colorWithHexString:kColorMain];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = kTextContact;
    }
    return _titleLabel;
}

@end
