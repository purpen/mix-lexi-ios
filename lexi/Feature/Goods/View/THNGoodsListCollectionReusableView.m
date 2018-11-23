//
//  THNGoodsListCollectionReusableView.m
//  lexi
//
//  Created by FLYang on 2018/9/22.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsListCollectionReusableView.h"
#import "UIColor+Extension.h"
#import <Masonry/Masonry.h>
#import "UIView+Helper.h"
#import <YYKit/YYKit.h>
#import "THNUserModel.h"
#import "UIImageView+WebImage.h"
#import "THNMarco.h"

static NSString *const kTitleEditors        = @"编辑推荐";
static NSString *const kSloganEditors       = @"品质与设计并存的精选好物";
static NSString *const kTitleNewProduct     = @"优质新品";
static NSString *const kSloganNewProduct    = @"品质与设计并存的精选好物";
static NSString *const kTitleDesign         = @"特惠好设计";
static NSString *const kSloganDesign        = @"品质与设计并存的精选好物";
static NSString *const kTitleGoodThing      = @"百元好物";
static NSString *const kSloganGoodThing     = @"品质与设计并存的精选好物";

@interface THNGoodsListCollectionReusableView ()

/// 头图
@property (nonatomic, strong) UIImageView *headerImageView;
/// icon
@property (nonatomic, strong) UIImageView *iconImageView;
/// 名称
@property (nonatomic, strong) UILabel *titleLabel;
/// 用户视图
@property (nonatomic, strong) UIView *userView;
/// 宣传语
@property (nonatomic, strong) UILabel *sloganLabel;
/// 数量按钮
@property (nonatomic, strong) UIButton *countButton;

@end

@implementation THNGoodsListCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

- (void)thn_setShowContentWithListType:(THNGoodsListViewType)listType userData:(NSArray *)userData {
    NSDictionary *titleDict = @{@(THNGoodsListViewTypeEditors)   : kTitleEditors,
                                @(THNGoodsListViewTypeNewProduct): kTitleNewProduct,
                                @(THNGoodsListViewTypeDesign)    : kTitleDesign,
                                @(THNGoodsListViewTypeGoodThing) : kTitleGoodThing};
    
    NSDictionary *sloganDict = @{@(THNGoodsListViewTypeEditors)   : kSloganEditors,
                                 @(THNGoodsListViewTypeNewProduct): kSloganNewProduct,
                                 @(THNGoodsListViewTypeDesign)    : kSloganDesign,
                                 @(THNGoodsListViewTypeGoodThing) : kSloganGoodThing};
    
    NSDictionary *bgImageIndex = @{@(THNGoodsListViewTypeEditors)   : @"column_header_0",
                                   @(THNGoodsListViewTypeNewProduct): @"column_header_1",
                                   @(THNGoodsListViewTypeDesign)    : @"column_header_2",
                                   @(THNGoodsListViewTypeGoodThing) : @"column_header_3"};
    
    [self thn_setViewContentWithTitle:titleDict[@(listType)]
                             iconName:@"icon_column_0"
                          bgImageName:bgImageIndex[@(listType)]
                           sloganText:sloganDict[@(listType)]];
    
    if (userData.count) {
        [self thn_setRecordUserData:[self thn_getUserModelWithData:userData]];
        [self thn_setUserCountWithValue:userData.count];
    }
}

#pragma mark - private methods
- (void)thn_setViewContentWithTitle:(NSString *)title iconName:(NSString *)iconName bgImageName:(NSString *)bgImageName sloganText:(NSString *)sloganText {
    
    self.titleLabel.text = title;
    self.sloganLabel.text = sloganText;
    self.iconImageView.image = [UIImage imageNamed:iconName];
    self.headerImageView.image = [UIImage imageNamed:bgImageName];
}

- (void)thn_setUserCountWithValue:(NSInteger)value {
    NSString *countStr = value > 999 ? @"999+" : [NSString stringWithFormat:@"%zi", value];
    [self.countButton setTitle:countStr forState:(UIControlStateNormal)];
}

- (void)thn_setRecordUserData:(NSArray *)data {
    for (NSUInteger idx = 0; idx < data.count; idx ++) {
        THNUserModel *model = data[idx];
        UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(20 + 24 * idx, 44, 30, 30)];
        headerView.contentMode = UIViewContentModeScaleAspectFill;
        headerView.layer.borderWidth = 1;
        headerView.layer.borderColor = [UIColor whiteColor].CGColor;
        headerView.layer.cornerRadius = 30 / 2;
        headerView.layer.masksToBounds = YES;
        [headerView loadImageWithUrl:[model.avatar loadImageUrlWithType:(THNLoadImageUrlTypeAvatarSmall)]];
        
        [self.userView addSubview:headerView];
    }
    
    self.userView.hidden = NO;
}

- (NSArray *)thn_getUserModelWithData:(NSArray *)data {
    NSInteger maxCount = kDeviceiPhone5 ? 7 : 11;
    NSInteger count = data.count > maxCount ? maxCount : data.count;
    
    NSMutableArray *modelArr = [NSMutableArray array];
    
    for (NSInteger idx = 0; idx < count; idx ++) {
        THNUserModel *model = [THNUserModel mj_objectWithKeyValues:data[idx]];
        [modelArr addObject:model];
    }
    
    return [modelArr copy];
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.headerImageView];
    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLabel];
    [self.userView addSubview:self.sloganLabel];
    [self.userView addSubview:self.countButton];
    [self addSubview:self.userView];
    
    [self setMasonryLayout];
}

- (void)setMasonryLayout {
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-65);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_centerX).with.offset(-30);
        make.top.mas_equalTo(45);
        make.size.mas_equalTo(CGSizeMake(150, 25));
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLabel);
        make.right.equalTo(self.titleLabel.mas_left).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [self.userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(88);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-20);
    }];
    
    [self.sloganLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(15);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(15);
    }];
    
    [self.countButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-15);
        make.right.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

#pragma mark - getters and setters
- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headerImageView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeCenter;
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:23 weight:(UIFontWeightMedium)];
    }
    return _titleLabel;
}

- (UIView *)userView {
    if (!_userView) {
        _userView = [[UIView alloc] init];
        _userView.backgroundColor = [UIColor whiteColor];
        _userView.layer.cornerRadius = 4;
        _userView.layer.shadowColor = [UIColor colorWithHexString:@"#000000" alpha:1].CGColor;
        _userView.layer.shadowOffset = CGSizeMake(0, 0);
        _userView.layer.shadowRadius = 5;
        _userView.layer.shadowOpacity = 0.1;
        _userView.hidden = YES;
    }
    return _userView;
}

- (UILabel *)sloganLabel {
    if (!_sloganLabel) {
        _sloganLabel = [[UILabel alloc] init];
        _sloganLabel.textColor = [UIColor colorWithHexString:@"#555555"];
        _sloganLabel.font = [UIFont systemFontOfSize:14];
    }
    return _sloganLabel;
}

- (UIButton *)countButton {
    if (!_countButton) {
        _countButton = [[UIButton alloc] init];
        _countButton.backgroundColor = [UIColor blackColor];
        [_countButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _countButton.titleLabel.font = [UIFont systemFontOfSize:10];
        _countButton.layer.cornerRadius = 30 / 2;
    }
    return _countButton;
}

@end
