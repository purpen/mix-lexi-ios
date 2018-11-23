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

@property (nonatomic, strong) UIButton *contactButton;

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

#pragma mark - event response
- (void)contactButtonAction:(id)sender {
    self.baseCell.selectedCellBlock(@"");
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    [self addSubview:self.contactButton];
    
    [self setMasonryLayout];
}

- (void)setMasonryLayout {
    [self.contactButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 14));
        make.bottom.mas_equalTo(-14);
        make.centerX.mas_equalTo(self);
    }];
}

#pragma mark - getters and setters
- (UIButton *)contactButton {
    if (!_contactButton) {
        _contactButton = [[UIButton alloc] init];
        _contactButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_contactButton setTitleColor:[UIColor colorWithHexString:kColorMain] forState:(UIControlStateNormal)];
        [_contactButton setTitle:kTextContact forState:(UIControlStateNormal)];
        [_contactButton addTarget:self action:@selector(contactButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _contactButton;
}

@end
