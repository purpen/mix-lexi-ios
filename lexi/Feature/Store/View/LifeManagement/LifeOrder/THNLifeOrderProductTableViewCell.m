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
#import "UIImageView+WebImage.h"
#import "THNLifeOrderItemModel.h"

static NSString *const kTextEarnings = @"预计收益：";

@interface THNLifeOrderProductTableViewCell ()

@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) YYLabel *nameLabel;
@property (nonatomic, strong) YYLabel *modeLabel;
@property (nonatomic, strong) YYLabel *moneyLabel;
@property (nonatomic, strong) YYLabel *countLabel;
@property (nonatomic, strong) YYLabel *earningsLabel;

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
    
    [self.goodsImageView loadImageWithUrl:[model.cover loadImageUrlWithType:(THNLoadImageUrlTypeGoodsCell)]];
    self.nameLabel.text = model.product_name;
    self.countLabel.text = [NSString stringWithFormat:@"x%zi", model.quantity];
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f", model.sale_price];
    NSString *modeStr = model.s_model.length > 0 ? [NSString stringWithFormat:@"/%@", model.s_model] : @"";
    self.modeLabel.text = [NSString stringWithFormat:@"%@%@", model.s_color, modeStr];
    [self thn_showEarningsPrice:model.order_sku_commission_price];
    
    [self setNeedsUpdateConstraints];
}

// 显示商品预计收益
- (void)setShowEearnings:(BOOL)showEearnings {
    _showEearnings = showEearnings;
    
    self.earningsLabel.hidden = !showEearnings;
}

#pragma mark - private methods
// 订单预计收益
- (void)thn_showEarningsPrice:(CGFloat)price {
    NSString *priceStr = [NSString stringWithFormat:@"￥%.2f", price];
    NSMutableAttributedString *earningsAtt = [[NSMutableAttributedString alloc] initWithString:priceStr];
    earningsAtt.color = [UIColor colorWithHexString:@"#FF6666"];
    earningsAtt.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightSemibold)];
    
    NSMutableAttributedString *hintAtt = [[NSMutableAttributedString alloc] initWithString:kTextEarnings];
    hintAtt.color = [UIColor colorWithHexString:@"#999999"];
    hintAtt.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
    
    [earningsAtt insertAttributedString:hintAtt atIndex:0];
    self.earningsLabel.attributedText = earningsAtt;
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.goodsImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.modeLabel];
    [self addSubview:self.moneyLabel];
    [self addSubview:self.countLabel];
    [self addSubview:self.earningsLabel];
}

- (void)updateConstraints {
    [self.goodsImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.showEearnings ? 15 : 0);
    }];
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(17);
        make.left.mas_equalTo(90);
        make.right.mas_equalTo(-60);
        make.top.equalTo(self.goodsImageView.mas_top).with.offset(0);
    }];
    
    [self.modeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(15);
        make.left.mas_equalTo(90);
        make.right.mas_equalTo(-60);
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(5);
    }];
    
    [self.moneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(16);
        make.left.mas_equalTo(90);
        make.right.mas_equalTo(-60);
        make.bottom.equalTo(self.goodsImageView.mas_bottom).with.offset(0);
    }];
    
    [self.countLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 15));
        make.right.mas_equalTo(-20);
        make.centerY.equalTo(self);
    }];
    
    [self.earningsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 16));
        make.left.mas_equalTo(20);
        make.bottom.mas_equalTo(-10);
    }];
    
    [super updateConstraints];
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

- (YYLabel *)earningsLabel {
    if (!_earningsLabel) {
        _earningsLabel = [[YYLabel alloc] init];
        _earningsLabel.hidden = YES;
    }
    return _earningsLabel;
}

@end
