//
//  THNFunctionSortTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/8/28.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNFunctionSortTableViewCell.h"
#import "UIColor+Extension.h"
#import "THNConst.h"
#import "THNMarco.h"

static NSString *const kTitleDefault    = @"不限";
static NSString *const kTitleSynthesize = @"综合排序";
static NSString *const kTitleNewest     = @"新品";
static NSString *const kTitlePriceUp    = @"由低至高";
static NSString *const kTitlePriceDown  = @"由高至低";

@interface THNFunctionSortTableViewCell ()

/// 选中的icon
@property (nonatomic, strong) UIImageView *iconImageView;
/// 标题数组
@property (nonatomic, strong) NSArray *titleArr;

@end

@implementation THNFunctionSortTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupCellViewUI];
    }
    return self;
}

- (void)thn_setSortConditionWithType:(THNFunctionSortType)type {
    self.sortType = type;
    self.titleLabel.text = self.titleArr[(NSInteger)type];
}

- (void)thn_setCellSelected:(BOOL)selected {
    self.titleLabel.textColor = [UIColor colorWithHexString:selected ? kColorMain : @"#333333"];
    self.iconImageView.hidden = !selected;
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    [self addSubview:self.titleLabel];
    [self addSubview:self.iconImageView];
    self.titleArr = @[kTitleDefault, kTitleSynthesize, kTitlePriceUp, kTitlePriceDown, kTitleNewest];
}

#pragma mark - getters and setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, CGRectGetHeight(self.bounds))];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _titleLabel;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 42, 11, 22, 22)];
        _iconImageView.image = [UIImage imageNamed:@"icon_selected_main"];
        _iconImageView.hidden = YES;
    }
    return _iconImageView;
}

@end
