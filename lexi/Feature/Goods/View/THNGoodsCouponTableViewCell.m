//
//  THNGoodsCouponTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/10/23.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNGoodsCouponTableViewCell.h"
#import <YYKit/YYKit.h>
#import "THNCouponModel.h"

static NSString *const kGoodsCouponTableViewCellId = @"THNGoodsCouponTableViewCellId";
///
static NSString *const kTextGet     = @"领取";
static NSString *const kTextHint    = @"  领取设计馆优惠红包";

@interface THNGoodsCouponTableViewCell ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *getButton;
@property (nonatomic, strong) YYLabel *hintLabel;
@property (nonatomic, strong) YYLabel *couponLabel;

@end

@implementation THNGoodsCouponTableViewCell

+ (instancetype)initGoodsCellWithTableView:(UITableView *)tableView cellStyle:(UITableViewCellStyle)style {
    THNGoodsCouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGoodsCouponTableViewCellId];
    if (!cell) {
        cell = [[THNGoodsCouponTableViewCell alloc] initWithStyle:style reuseIdentifier:kGoodsCouponTableViewCellId];
        cell.tableView = tableView;
    }
    return cell;
}

- (void)thn_setCouponData:(NSArray *)data {
    self.containerView.hidden = !data.count;
    
    if (!data.count) return;
    
    [self thn_setHintLabelAttributedStringWithData:data];
    [self thn_setCouponLabelAttributedStringWithData:data];
}

#pragma mark - event response
- (void)getButtonAction:(id)sender {
    self.baseCell.selectedCellBlock(@"");
}

- (void)hintLabelAction:(UITapGestureRecognizer *)tap {
    self.baseCell.selectedCellBlock(@"");
}

- (void)couponLabelAction:(UITapGestureRecognizer *)tap {
    self.baseCell.selectedCellBlock(@"");
}

#pragma mark - private methods
- (void)thn_setHintLabelAttributedStringWithData:(NSArray *)data {
    // 可领取红包
    NSArray *couponArr = [data filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"type = 1 || type = 2"]];
    self.hintLabel.hidden = !couponArr.count;
    self.getButton.hidden = !couponArr.count;
    
    if (!couponArr.count) {
        return;
    }
    NSMutableAttributedString *hintAtt = [[NSMutableAttributedString alloc] initWithString:kTextHint];
    hintAtt.font = [UIFont systemFontOfSize:12];
    hintAtt.color = [UIColor colorWithHexString:@"#555555"];
    
    NSMutableAttributedString *iconAtt = [NSMutableAttributedString attachmentStringWithContent:[UIImage imageNamed:@"icon_coupon"]
                                                                                    contentMode:(UIViewContentModeCenter)
                                                                                 attachmentSize:CGSizeMake(29, 15)
                                                                                    alignToFont:[UIFont systemFontOfSize:12]
                                                                                      alignment:(YYTextVerticalAlignmentCenter)];
    
    [hintAtt insertAttributedString:iconAtt atIndex:0];

    self.hintLabel.attributedText = hintAtt;
}

- (void)thn_setCouponLabelAttributedStringWithData:(NSArray *)data {
    // 满减活动
    NSArray *minusCouponArr = [data filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"type = 3"]];
    self.couponLabel.hidden = !minusCouponArr.count;
    
    if (!minusCouponArr.count) {
        return;
    }
    
    NSMutableAttributedString *textAtt = [NSMutableAttributedString new];
    
    NSMutableAttributedString *iconAtt = [NSMutableAttributedString attachmentStringWithContent:[UIImage imageNamed:@"icon_less"]
                                                                                    contentMode:(UIViewContentModeCenter)
                                                                                 attachmentSize:CGSizeMake(15, 15)
                                                                                    alignToFont:[UIFont systemFontOfSize:12]
                                                                                      alignment:(YYTextVerticalAlignmentCenter)];
    
    [textAtt insertAttributedString:iconAtt atIndex:0];
    
    NSInteger dataCount = minusCouponArr.count > 3 ? 3 : minusCouponArr.count;
    
    for (NSUInteger idx = 0; idx < dataCount; idx ++) {
        THNCouponModel *model = [THNCouponModel mj_objectWithKeyValues:(NSDictionary *)minusCouponArr[idx]];
        
        NSString *punStr = idx == dataCount - 1 ? @"" : @",";
        NSString *amountStr = [NSString stringWithFormat:@"  满%.0f减%.0f%@", model.reach_amount, model.amount, punStr];
        
        NSMutableAttributedString *amountAtt = [[NSMutableAttributedString alloc] initWithString:amountStr];
        amountAtt.font = [UIFont systemFontOfSize:12];
        amountAtt.color = [UIColor colorWithHexString:@"#555555"];
        
        [textAtt appendAttributedString:amountAtt];
    }
    
    self.couponLabel.attributedText = textAtt;
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    [self.containerView addSubview:self.getButton];
    [self.containerView addSubview:self.hintLabel];
    [self.containerView addSubview:self.couponLabel];
    [self addSubview:self.containerView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.containerView.isHidden ? 0 : -15);
    }];
    
    [self.getButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 26));
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
    }];
    
    [self.hintLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-65);
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(16);
    }];
    
    [self.couponLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(self.hintLabel.isHidden ? 12 : 40);
        make.height.mas_equalTo(16);
    }];
}

#pragma mark - getters and setters
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor colorWithHexString:@"#D4AF86" alpha:0.1];
        _containerView.layer.cornerRadius = 4;
        _containerView.hidden = YES;
    }
    return _containerView;
}

- (UIButton *)getButton {
    if (!_getButton) {
        _getButton = [[UIButton alloc] init];
        _getButton.backgroundColor = [UIColor colorWithHexString:@"#D4AF86" alpha:0];
        [_getButton setTitle:kTextGet forState:(UIControlStateNormal)];
        [_getButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:(UIControlStateNormal)];
        _getButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _getButton.layer.borderWidth = 1;
        _getButton.layer.borderColor = [UIColor colorWithHexString:@"#DADADA"].CGColor;
        _getButton.layer.cornerRadius = 13;
        [_getButton addTarget:self action:@selector(getButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _getButton;
}

- (YYLabel *)hintLabel {
    if (!_hintLabel) {
        _hintLabel = [[YYLabel alloc] init];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hintLabelAction:)];
        [_hintLabel addGestureRecognizer:tap];
    }
    return _hintLabel;
}

- (YYLabel *)couponLabel {
    if (!_couponLabel) {
        _couponLabel = [[YYLabel alloc] init];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(couponLabelAction:)];
        [_couponLabel addGestureRecognizer:tap];
    }
    return _couponLabel;
}

@end
