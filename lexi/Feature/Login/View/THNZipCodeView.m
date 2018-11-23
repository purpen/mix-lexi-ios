//
//  THNZipCodeView.m
//  lexi
//
//  Created by FLYang on 2018/7/23.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNZipCodeView.h"
#import "THNMarco.h"
#import "UIColor+Extension.h"
#import "UIView+Helper.h"
#import <Masonry/Masonry.h>
#import "THNZipCodeTableViewCell.h"
#import <MJExtension/MJExtension.h>

/// text
static NSString *const kTextTitle   = @"选择国家与地区";
static NSString *const kTextHint    = @"常用";
/// tableViewCell id
static NSString *const kTableViewCellIdentifier = @"THNZipCodeTableViewCellId";

@interface THNZipCodeView () <UITableViewDelegate, UITableViewDataSource>

/// 国家区号列表
@property (nonatomic, strong) UITableView *zipCodeTable;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 头部提示内容
@property (nonatomic, strong) UILabel *hintLabel;
/// 关闭按钮
@property (nonatomic, strong) UIButton *closeButton;
/// 国家区号数据
@property (nonatomic, strong) NSMutableArray *zipCodeArray;

@end

@implementation THNZipCodeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

#pragma mark - public methods
- (void)thn_setAreaCodes:(NSArray *)codes {
    if (self.zipCodeArray.count) {
        [self.zipCodeArray removeAllObjects];
    }
    
    for (NSDictionary *data in codes) {
        THNAreaCodeModel *model = [THNAreaCodeModel mj_objectWithKeyValues:data];
        [self.zipCodeArray addObject:model];
    }
    
    [self.zipCodeTable reloadData];
}

#pragma mark - event response
- (void)closeButtonAction:(UIButton *)button {
    self.CloseZipCodeViewBlock();
}

#pragma mark - tableView delegate&dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.zipCodeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNZipCodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier];
    if (!cell) {
        cell = [[THNZipCodeTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:kTableViewCellIdentifier];
    }
    
    if (self.zipCodeArray.count) {
        [cell thn_setAreaCodeInfoModel:self.zipCodeArray[indexPath.row]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.zipCodeArray.count) {
        self.SelectedZipCodeBlock(self.zipCodeArray[indexPath.row]);
    }
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.hintLabel];
    [self addSubview:self.zipCodeTable];
    [self addSubview:self.closeButton];
}

- (void)updateConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(kDeviceiPhoneX ? 60 : 30);
        make.height.mas_equalTo(24);
    }];
    
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(30);
        make.height.mas_equalTo(20);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.centerX.equalTo(self);
        make.bottom.mas_equalTo(kDeviceiPhoneX ? -60 : -30);
    }];
    
    [self.zipCodeTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.hintLabel.mas_bottom).with.offset(15);
        make.bottom.mas_equalTo(kDeviceiPhoneX ? -140 : -100);
    }];
    
    [super updateConstraints];
}

- (void)drawRect:(CGRect)rect {
    [UIView drawRectLineStart:(CGPointMake(0, CGRectGetMaxY(self.hintLabel.frame) + 8))
                          end:(CGPointMake(SCREEN_WIDTH, CGRectGetMaxY(self.hintLabel.frame) + 8))
                        width:0.5
                        color:[UIColor colorWithHexString:@"#E9E9E9" alpha:1]];
}

#pragma mark - getters and setters
- (UITableView *)zipCodeTable {
    if (!_zipCodeTable) {
        _zipCodeTable = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _zipCodeTable.delegate = self;
        _zipCodeTable.dataSource = self;
        _zipCodeTable.tableFooterView = [UIView new];
        _zipCodeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _zipCodeTable.showsVerticalScrollIndicator = NO;
    }
    return _zipCodeTable;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:17 weight:(UIFontWeightRegular)];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = kTextTitle;
    }
    return _titleLabel;
}

- (UILabel *)hintLabel {
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)];
        _hintLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _hintLabel.text = kTextHint;
    }
    return _hintLabel;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        [_closeButton setImage:[UIImage imageNamed:@"icon_close_black"] forState:(UIControlStateNormal)];
        [_closeButton setImageEdgeInsets:(UIEdgeInsetsMake(10, 10, 10, 10))];
        [_closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeButton;
}

- (NSMutableArray *)zipCodeArray {
    if (!_zipCodeArray) {
        _zipCodeArray = [NSMutableArray array];
    }
    return _zipCodeArray;
}

@end
