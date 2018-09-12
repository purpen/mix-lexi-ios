//
//  THNGoodsHeaderTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/9/3.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsHeaderTableViewCell.h"

static NSString *const kGoodsHeaderTableViewCellId = @"kGoodsHeaderTableViewCellId";
static NSString *const kTextDefault   = @"默认";
static NSString *const kTextSimilar   = @"相似商品";
static NSString *const kTextGoodsInfo = @"作品详情";

@interface THNGoodsHeaderTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) THNGoodsHeaderCellType cellType;

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

- (void)thn_setHeaderCellWithText:(NSString *)text fontSize:(CGFloat)fontSize colorHex:(NSString *)colorHex {
    self.titleLabel.text = text;
    self.titleLabel.textColor = [UIColor colorWithHexString:colorHex];
    self.titleLabel.font = [UIFont systemFontOfSize:fontSize weight:(UIFontWeightMedium)];
}

- (void)thn_setHeaderCellType:(THNGoodsHeaderCellType)type {
    self.cellType = type;
    
    if (type == THNGoodsHeaderCellTypeGoodsInfo) {
        self.lineView.hidden = YES;
        [self thn_setHeaderCellWithText:self.titleArr[(NSUInteger)type] fontSize:16 colorHex:@"#333333"];
        
    } else {
        self.lineView.hidden = NO;
        [self thn_setHeaderCellWithText:self.titleArr[(NSUInteger)type] fontSize:14 colorHex:kColorMain];
    }
    
    [self layoutIfNeeded];
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    self.titleArr = @[kTextDefault, kTextSimilar, kTextGoodsInfo];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.lineView];
}

#pragma mark - getters and setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 200, 15)];
    }
    return _titleLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 39, 15, 3)];
        _lineView.backgroundColor = [UIColor colorWithHexString:kColorMain];
    }
    return _lineView;
}

@end
