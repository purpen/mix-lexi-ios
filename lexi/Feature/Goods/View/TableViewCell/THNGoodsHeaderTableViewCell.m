//
//  THNGoodsHeaderTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/9/3.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsHeaderTableViewCell.h"

static NSString *const kGoodsHeaderTableViewCellId = @"kGoodsHeaderTableViewCellId";
static NSString *const kTextDefault = @"默认";
static NSString *const kTextSimilar = @"相似商品";

@interface THNGoodsHeaderTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSArray *titleArr;

@end;

@implementation THNGoodsHeaderTableViewCell

+ (instancetype)initGoodsCellWithTableView:(UITableView *)tableView cellStyle:(UITableViewCellStyle)style {
    THNGoodsHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGoodsHeaderTableViewCellId];
    if (!cell) {
        cell = [[THNGoodsHeaderTableViewCell alloc] initWithStyle:style reuseIdentifier:kGoodsHeaderTableViewCellId];
        cell.tableView = tableView;
    }
    return cell;
}

- (void)thn_setHeaderCellWithText:(NSString *)text {
    self.titleLabel.text = text;
}

- (void)thn_setHeaderCellType:(THNGoodsHeaderCellType)type {
    [self thn_setHeaderCellWithText:self.titleArr[(NSUInteger)type]];
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    self.titleArr = @[kTextDefault, kTextSimilar];
    
    [self addSubview:self.titleLabel];
}

- (void)drawRect:(CGRect)rect {
    [UIView drawRectLineStart:CGPointMake(15, 39)
                          end:CGPointMake(30, 39)
                        width:3
                        color:[UIColor colorWithHexString:kColorMain]];
}

#pragma mark - getters and setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 200, 15)];
        _titleLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)];
        _titleLabel.textColor = [UIColor colorWithHexString:kColorMain];
    }
    return _titleLabel;
}

@end
