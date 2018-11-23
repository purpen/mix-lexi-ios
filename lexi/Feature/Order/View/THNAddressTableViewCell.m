//
//  THNAddressTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/9/10.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNAddressTableViewCell.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>
#import "UIView+Helper.h"

static NSString *const kAddressTableViewCellId = @"kAddressTableViewCellId";

@interface THNAddressTableViewCell ()

/// 名字
@property (nonatomic, strong) YYLabel *namelabel;
/// 地区
@property (nonatomic, strong) YYLabel *citylabel;
/// 地址
@property (nonatomic, strong) YYLabel *addresslabel;
/// 电话
@property (nonatomic, strong) YYLabel *phonelabel;
/// 选择按钮
@property (nonatomic, strong) UIButton *selectButton;

@end

@implementation THNAddressTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupCellViewUI];
    }
    return self;
}

+ (instancetype)initAddressCellWithTableView:(UITableView *)tableView cellStyle:(UITableViewCellStyle)style type:(THNAddressCellType)type  {
    THNAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAddressTableViewCellId];
    if (!cell) {
        cell = [[THNAddressTableViewCell alloc] initWithStyle:style reuseIdentifier:kAddressTableViewCellId];
        cell.type = type;
    }
    return cell;
}

+ (instancetype)initAddressCellWithTableView:(UITableView *)tableView type:(THNAddressCellType)type {
    return [self initAddressCellWithTableView:tableView cellStyle:(UITableViewCellStyleDefault) type:type];
}

- (void)thn_setAddressModel:(THNAddressModel *)model {
    self.namelabel.text = model.fullName;
    self.addresslabel.text = model.fullAddress;
    NSString *province = model.province.length ? [NSString stringWithFormat:@"%@，", model.province] : @"";
    self.citylabel.text = [NSString stringWithFormat:@"%@%@  %@", province, model.city, model.zipcode];
    self.phonelabel.text = model.mobile;
    
    [self setNeedsUpdateConstraints];
}

#pragma mark - event response
- (void)selectButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_didSelectedAddressCell:)]) {
        [self.delegate thn_didSelectedAddressCell:self];
    }
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.selectButton];
    [self addSubview:self.namelabel];
    [self addSubview:self.addresslabel];
    [self addSubview:self.citylabel];
    [self addSubview:self.phonelabel];
}

- (void)updateConstraints {
    [self.selectButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(37);
    }];
    
    [self.namelabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.type == THNAddressCellTypeNormal ? 15 : 52);
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-44);
        make.height.mas_equalTo(16);
    }];
    
    [self.addresslabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.namelabel.mas_left).with.offset(0);
        make.top.equalTo(self.namelabel.mas_bottom).with.offset(5);
        make.right.mas_equalTo(-44);
        make.height.mas_equalTo(15);
    }];
    
    [self.citylabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addresslabel.mas_left).with.offset(0);
        make.top.equalTo(self.addresslabel.mas_bottom).with.offset(5);
        make.right.mas_equalTo(-44);
        make.height.mas_equalTo(15);
    }];
    
    [self.phonelabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.citylabel.mas_left).with.offset(0);
        make.top.equalTo(self.citylabel.mas_bottom).with.offset(5);
        make.right.mas_equalTo(-44);
        make.height.mas_equalTo(15);
    }];
    
    [super updateConstraints];
}

- (void)drawRect:(CGRect)rect {
    [UIView drawRectLineStart:CGPointMake(0, CGRectGetHeight(self.bounds) - 1)
                          end:CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 1)
                        width:0.5
                        color:[UIColor colorWithHexString:@"#E9E9E9"]];
}

#pragma mark - getters and setters
- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    
    self.selectButton.selected = isSelected;
}

- (void)setType:(THNAddressCellType)type {
    _type = type;
    
    self.selectButton.hidden = type == THNAddressCellTypeNormal;
}

- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [[UIButton alloc] init];
        [_selectButton setImage:[UIImage imageNamed:@"icon_selected_none"] forState:(UIControlStateNormal)];
        [_selectButton setImage:[UIImage imageNamed:@"icon_selected_main"] forState:(UIControlStateSelected)];
        _selectButton.imageView.contentMode = UIViewContentModeCenter;
        [_selectButton setImageEdgeInsets:(UIEdgeInsetsMake(0, 15, 0, 0))];
        _selectButton.selected = NO;
        [_selectButton addTarget:self action:@selector(selectButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _selectButton;
}

- (YYLabel *)namelabel {
    if (!_namelabel) {
        _namelabel = [[YYLabel alloc] init];
        _namelabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)];
        _namelabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _namelabel;
}

- (YYLabel *)addresslabel {
    if (!_addresslabel) {
        _addresslabel = [[YYLabel alloc] init];
        _addresslabel.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightLight)];
        _addresslabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _addresslabel;
}

- (YYLabel *)citylabel {
    if (!_citylabel) {
        _citylabel = [[YYLabel alloc] init];
        _citylabel.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightLight)];
        _citylabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _citylabel;
}

- (YYLabel *)phonelabel {
    if (!_phonelabel) {
        _phonelabel = [[YYLabel alloc] init];
        _phonelabel.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightLight)];
        _phonelabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _phonelabel;
}

@end
