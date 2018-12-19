//
//  THNAdvertUpdateView.m
//  lexi
//
//  Created by FLYang on 2018/12/19.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNAdvertUpdateView.h"
#import "THNMarco.h"
#import "THNConst.h"
#import "UIColor+Extension.h"

static NSString *const kTextHint    = @"【新版本更新】";
static NSString *const kTextDone    = @"立即更新";
static NSString *const kTextCancel  = @"暂不更新";

static NSString *const kTableViewCellID = @"TableViewCellID";

@interface THNAdvertUpdateView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UITableView *contentTable;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation THNAdvertUpdateView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

#pragma mark - event response
- (void)doneButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_updateDoneAction)]) {
        [self.delegate thn_updateDoneAction];
    }
}

- (void)cancelButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_updateCancelAction)]) {
        [self.delegate thn_updateCancelAction];
    }
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0];
    
    [self addSubview:self.contentTable];
    [self.containerView addSubview:self.doneButton];
    [self.containerView addSubview:self.cancelButton];
    [self addSubview:self.containerView];
}

#pragma mark - tableView datasource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:kTableViewCellID];
    }
    
    return cell;
}

#pragma mark - getters and setters
- (UITableView *)contentTable {
    if (!_contentTable) {
        _contentTable = [[UITableView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 260) / 2, (SCREEN_HEIGHT - 340) / 2, 260, 237)
                                                     style:(UITableViewStylePlain)];
        _contentTable.delegate = self;
        _contentTable.dataSource = self;
        _contentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _contentTable.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0];
        _contentTable.tableHeaderView = self.iconImageView;
    }
    return _contentTable;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 260, 105)];
        _iconImageView.image = [UIImage imageNamed:@"advert_update_bg"];
    }
    return _iconImageView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame: \
                          CGRectMake(CGRectGetMinX(self.contentTable.frame), CGRectGetMaxY(self.contentTable.frame), 260, 110)];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

- (UIButton *)doneButton {
    if (!_doneButton) {
        _doneButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, 220, 40)];
        _doneButton.backgroundColor = [UIColor colorWithHexString:kColorMain];
        [_doneButton setTitle:kTextDone forState:(UIControlStateNormal)];
        [_doneButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightMedium)];
        _doneButton.layer.cornerRadius = 4;
        [_doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _doneButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 55, 220, 40)];
        _cancelButton.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [_cancelButton setTitle:kTextCancel forState:(UIControlStateNormal)];
        [_cancelButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:(UIControlStateNormal)];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _cancelButton.layer.cornerRadius = 4;
        [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _cancelButton;
}

@end
