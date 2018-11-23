//
//  THNZipCodeTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/7/23.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNZipCodeTableViewCell.h"
#import "UIColor+Extension.h"
#import <Masonry/Masonry.h>

@interface THNZipCodeTableViewCell ()

/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 描述
@property (nonatomic, strong) UILabel *describeLabel;

@end

@implementation THNZipCodeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupCellViewUI];
    }
    return self;
}

- (void)thn_setAreaCodeInfoModel:(THNAreaCodeModel *)model {
    self.titleLabel.text = model.name;
    self.describeLabel.text = model.areacode;
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.describeLabel];
    
    [self setMasonryLayout];
}

- (void)setMasonryLayout {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 20));
        make.left.mas_equalTo(0);
        make.centerY.equalTo(self);
    }];
    
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.right.mas_equalTo(0);
        make.centerY.equalTo(self);
    }];
}

#pragma mark - getters and setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightRegular)];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _titleLabel;
}

- (UILabel *)describeLabel {
    if (!_describeLabel) {
        _describeLabel = [[UILabel alloc] init];
        _describeLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightRegular)];
        _describeLabel.textColor = [UIColor colorWithHexString:@"#949EA6"];
        _describeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _describeLabel;
}

@end
