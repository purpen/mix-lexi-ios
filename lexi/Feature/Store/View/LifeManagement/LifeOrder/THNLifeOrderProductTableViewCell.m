//
//  THNLifeOrderProductTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/10/9.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNLifeOrderProductTableViewCell.h"
#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>
#import "UIImageView+SDWedImage.h"
#import "THNLifeOrderItemModel.h"

@interface THNLifeOrderProductTableViewCell ()

@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) YYLabel *nameLabel;
@property (nonatomic, strong) YYLabel *modeLabel;
@property (nonatomic, strong) YYLabel *moneyLabel;
@property (nonatomic, strong) YYLabel *countLabel;

@end

@implementation THNLifeOrderProductTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupCellViewUI];
    }
    return self;
}

- (void)thn_setLifeOrderProductData:(NSDictionary *)data {
    THNLifeOrderItemModel *model = [THNLifeOrderItemModel mj_objectWithKeyValues:data];
    
    [self.goodsImageView downloadImage:model.cover place:[UIImage imageNamed:@"default_goods_place"]];
    self.nameLabel.text = model.product_name;
    self.countLabel.text = [NSString stringWithFormat:@"x%zi", model.quantity];
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f", model.sale_price];
    NSString *modeStr = model.s_model.length > 0 ? [NSString stringWithFormat:@"/%@", model.s_model] : @"";
    self.modeLabel.text = [NSString stringWithFormat:@"%@%@", model.s_color, modeStr];
}

#pragma mark - private methods

#pragma mark - setup UI
- (void)setupCellViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.goodsImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.modeLabel];
    [self addSubview:self.moneyLabel];
    [self addSubview:self.countLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.left.mas_equalTo(20);
        make.centerY.equalTo(self);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(17);
        make.left.mas_equalTo(90);
        make.right.mas_equalTo(-60);
        make.top.mas_equalTo(0);
    }];
    
    [self.modeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(15);
        make.left.mas_equalTo(90);
        make.right.mas_equalTo(-60);
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(5);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(16);
        make.left.mas_equalTo(90);
        make.right.mas_equalTo(-60);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 15));
        make.right.mas_equalTo(-20);
        make.centerY.equalTo(self);
    }];
}

#pragma mark - getters and setters
- (UIImageView *)goodsImageView {
    if (!_goodsImageView) {
        _goodsImageView = [[UIImageView alloc] init];
        _goodsImageView.contentMode = UIViewContentModeScaleAspectFill;
        _goodsImageView.layer.masksToBounds = YES;
    }
    return _goodsImageView;
}

- (YYLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[YYLabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _nameLabel;
}

- (YYLabel *)modeLabel {
    if (!_modeLabel) {
        _modeLabel = [[YYLabel alloc] init];
        _modeLabel.font = [UIFont systemFontOfSize:12];
        _modeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _modeLabel;
}

- (YYLabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[YYLabel alloc] init];
        _moneyLabel.font = [UIFont systemFontOfSize:14];
        _moneyLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _moneyLabel;
}

- (YYLabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[YYLabel alloc] init];
        _countLabel.textAlignment = NSTextAlignmentRight;
        _countLabel.font = [UIFont systemFontOfSize:12];
        _countLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _countLabel;
}

@end
