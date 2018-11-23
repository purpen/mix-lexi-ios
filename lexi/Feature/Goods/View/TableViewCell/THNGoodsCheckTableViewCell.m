//
//  THNGoodsCheckTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/9/3.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsCheckTableViewCell.h"

static NSString *const kGoodsCheckTableViewCellId = @"kGoodsCheckTableViewCellId";
static NSString *const kTitleAll = @"查看全部";

@interface THNGoodsCheckTableViewCell ()

@property (nonatomic, strong) UIButton *checkButton;

@end

@implementation THNGoodsCheckTableViewCell

+ (instancetype)initGoodsCellWithTableView:(UITableView *)tableView cellStyle:(UITableViewCellStyle)style {
    THNGoodsCheckTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGoodsCheckTableViewCellId];
    if (!cell) {
        cell = [[THNGoodsCheckTableViewCell alloc] initWithStyle:style reuseIdentifier:kGoodsCheckTableViewCellId];
        cell.tableView = tableView;
    }
    return cell;
}

- (void)thn_setGoodsCheckCellType:(THNGoodsCheckTableViewCellType)type {
    switch (type) {
        case THNGoodsCheckTableViewCellTypeAllDescribe: {
            [self thn_setButtonTitleText:kTitleAll];
            [self thn_showButtonBorderWidth:0.5 borderColor:@"#666666"];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - event response
- (void)checkButtonAction:(id)sender {
    self.baseCell.selectedCellBlock(@"");
}

#pragma mark - private methods
- (void)thn_setButtonTitleText:(NSString *)text {
    [self.checkButton setTitle:text forState:(UIControlStateNormal)];
}

- (void)thn_showButtonBorderWidth:(CGFloat)width borderColor:(NSString *)borderColor {
    self.checkButton.layer.borderColor = [UIColor colorWithHexString:borderColor].CGColor;
    self.checkButton.layer.borderWidth = width;
    self.checkButton.layer.cornerRadius = 4;
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    [self addSubview:self.checkButton];
}

- (void)updateConstraints {
    [self.checkButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 40));
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(0);
    }];
    
    [super updateConstraints];
}

#pragma mark - getters and setters
- (UIButton *)checkButton {
    if (!_checkButton) {
        _checkButton = [[UIButton alloc] init];
        [_checkButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:(UIControlStateNormal)];
        _checkButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_checkButton addTarget:self action:@selector(checkButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _checkButton;
}

@end
