//
//  THNTableViewSections.m
//  lexi
//
//  Created by FLYang on 2018/8/15.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNTableViewSections.h"
#import "THNMarco.h"
#import "UIColor+Extension.h"

static NSString *const kMoreButtonTitle = @"查看全部";

@interface THNTableViewSections ()

/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 查看全部
@property (nonatomic, strong) UIButton *moreButton;

@end

@implementation THNTableViewSections

#pragma mark - init
+ (instancetype)initSections {
    return [[self alloc] init];
}

+ (instancetype)initSectionsWithHeaderTitle:(NSString *)title {
    THNTableViewSections *sections = [self initSections];
    sections.headerTitle = title;
    
    return sections;
}

+ (instancetype)initSectionsWithHeaderTitle:(NSString *)title moreCompletion:(void (^)(void))completion {
    THNTableViewSections *sections = [self initSections];
    sections.headerTitle = title;
    sections.selectedMoreCompletion = completion;
    [sections.headerView showMoreButton:YES];
    
    return sections;
}

+ (instancetype)initSectionsWithCells:(NSMutableArray *)cells {
    THNTableViewSections *sections = [self initSections];
    sections.dataCells = cells;
    
    return sections;
}

#pragma mark - getters and setters
- (CGFloat)headerHeight {
    return _headerHeight ? _headerHeight : 0.01;
}

- (CGFloat)footerHeight {
    return _footerHeight ? _footerHeight : 0.01;
}

- (NSMutableArray *)dataCells {
    if (!_dataCells) {
        _dataCells = [NSMutableArray array];
    }
    return _dataCells;
}

- (void)setHeaderTitle:(NSString *)headerTitle {
    _headerTitle = headerTitle;
    
    self.headerView.title = headerTitle;
}

- (NSInteger)index {
    return _index ? _index : 0;
}

- (THNTableViewSectionHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[THNTableViewSectionHeaderView alloc] init];
        _headerView.backgroundColor = [UIColor whiteColor];
        [_headerView.moreButton addTarget:self action:@selector(moreButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _headerView;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] init];
    }
    return _footerView;
}

#pragma mark - event response
- (void)moreButtonAction:(UIButton *)button {
    self.selectedMoreCompletion();
}

@end
