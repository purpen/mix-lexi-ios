//
//  THNLifeOrderStoreTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/10/9.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNLifeOrderStoreTableViewCell.h"
#import "UIView+Helper.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>
#import "UIImageView+WebImage.h"
#import "THNLifeOrderStoreModel.h"
#import "THNLifeOrderUserModel.h"

static NSString *const kTextStatus = @"  状态：";
static NSString *const kTextMoney  = @"订单总计";

@interface THNLifeOrderStoreTableViewCell ()

@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) YYLabel *nameLabel;
@property (nonatomic, strong) YYLabel *storeLabel;
@property (nonatomic, strong) YYLabel *moneyLabel;

@end

@implementation THNLifeOrderStoreTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupCellViewUI];
    }
    return self;
}

- (void)thn_setLifeOrderData:(THNLifeOrderModel *)model {
    THNLifeOrderUserModel *userModel = [THNLifeOrderUserModel mj_objectWithKeyValues:model.user_info];
    [self thn_setLifeOrderUserData:userModel];
    
    THNLifeOrderStoreModel *storeModel = [THNLifeOrderStoreModel mj_objectWithKeyValues:model.store];
    [self thn_setLifeOrderStoreName:storeModel.store_name status:model.life_order_status];
    
    [self thn_setLifeOrderMoney:model.pay_amount];
}

#pragma mark - private methods
- (void)thn_setLifeOrderUserData:(THNLifeOrderUserModel *)model {
    [self.headView loadImageWithUrl:[model.user_logo loadImageUrlWithType:(THNLoadImageUrlTypeAvatar)]];
    self.nameLabel.text = model.user_name;
}

- (void)thn_setLifeOrderMoney:(CGFloat)money {
    NSString *moneyStr = [NSString stringWithFormat:@"\n%.2f", money];
    NSMutableAttributedString *moneyAtt = [[NSMutableAttributedString alloc] initWithString:moneyStr];
    moneyAtt.color = [UIColor colorWithHexString:@"#333333"];
    moneyAtt.font = [UIFont systemFontOfSize:14];
    moneyAtt.alignment = NSTextAlignmentRight;
    
    NSMutableAttributedString *hintAtt = [[NSMutableAttributedString alloc] initWithString:kTextMoney];
    hintAtt.color = [UIColor colorWithHexString:@"#999999"];
    hintAtt.font = [UIFont systemFontOfSize:12];
    hintAtt.alignment = NSTextAlignmentRight;
    
    [moneyAtt insertAttributedString:hintAtt atIndex:0];
    moneyAtt.lineSpacing = 4;
    
    self.moneyLabel.attributedText = moneyAtt;
}

- (void)thn_setLifeOrderStoreName:(NSString *)storeName status:(NSInteger)status {
    NSArray *statusArr = @[@"待发货", @"已发货", @"已完成"];
    
    NSMutableAttributedString *storeAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", storeName]];
    storeAtt.color = [UIColor colorWithHexString:@"#949EA6"];
    storeAtt.font = [UIFont systemFontOfSize:11];
    
    NSMutableAttributedString *hintAtt = [[NSMutableAttributedString alloc] initWithString:kTextStatus];
    hintAtt.color = [UIColor colorWithHexString:@"#B2B2B2"];
    hintAtt.font = [UIFont systemFontOfSize:11];
    [storeAtt appendAttributedString:hintAtt];
    
    NSMutableAttributedString *statusAtt = [[NSMutableAttributedString alloc] initWithString:statusArr[status - 1]];
    statusAtt.color = [UIColor colorWithHexString:@"#6ED7AF"];
    statusAtt.font = [UIFont systemFontOfSize:11 weight:(UIFontWeightMedium)];
    [storeAtt appendAttributedString:statusAtt];
    
    UIImageView *iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_store_main"]];
    NSMutableAttributedString *iconAtt = [NSMutableAttributedString attachmentStringWithContent:iconImage
                                                                                    contentMode:(UIViewContentModeCenter)
                                                                                 attachmentSize:CGSizeMake(10, 10)
                                                                                    alignToFont:[UIFont systemFontOfSize:11]
                                                                                      alignment:(YYTextVerticalAlignmentCenter)];
    [storeAtt insertAttributedString:iconAtt atIndex:0];
    
    self.storeLabel.attributedText = storeAtt;
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.headView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.storeLabel];
    [self addSubview:self.moneyLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.left.mas_equalTo(20);
        make.centerY.equalTo(self);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(15);
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-100);
        make.bottom.equalTo(self.mas_centerY).with.offset(-1);
    }];
    
    [self.storeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(15);
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-100);
        make.top.equalTo(self.mas_centerY).with.offset(1);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(150, 40));
    }];
}

#pragma mark - getters and setters
- (UIImageView *)headView {
    if (!_headView) {
        _headView = [[UIImageView alloc] init];
        _headView.contentMode = UIViewContentModeScaleAspectFill;
        _headView.layer.cornerRadius = 12;
        _headView.layer.masksToBounds = YES;
    }
    return _headView;
}

- (YYLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[YYLabel alloc] init];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _nameLabel.font = [UIFont systemFontOfSize:13];
    }
    return _nameLabel;
}

- (YYLabel *)storeLabel {
    if (!_storeLabel) {
        _storeLabel = [[YYLabel alloc] init];
    }
    return _storeLabel;
}

- (YYLabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[YYLabel alloc] init];
        _moneyLabel.numberOfLines = 2;
    }
    return _moneyLabel;
}

@end
