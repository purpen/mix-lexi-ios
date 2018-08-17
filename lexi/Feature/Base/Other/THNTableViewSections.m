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

- (THNTableViewSectionHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[THNTableViewSectionHeaderView alloc] init];
        [_headerView.moreButton addTarget:self action:@selector(moreButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _headerView;
}

#pragma mark - event response
- (void)moreButtonAction:(UIButton *)button {
    self.selectedMoreCompletion();
}

@end
