//
//  THNTableViewSections.h
//  lexi
//
//  Created by FLYang on 2018/8/15.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNTableViewSectionHeaderView.h"

typedef void (^THNTableViewSectionMoreBlock)(void);

@interface THNTableViewSections : NSObject

/**
 每组排序的位置
 */
@property (nonatomic, assign) NSInteger index;

/**
 每组组顶部的间隔
 */
@property (nonatomic, assign) CGFloat headerHeight;

/**
 每组组底部的间隔
 */
@property (nonatomic, assign) CGFloat footerHeight;

/**
 单元格
 */
@property (nonatomic, strong) NSMutableArray *dataCells;

/**
 头部视图
 */
@property (nonatomic, strong) THNTableViewSectionHeaderView *headerView;
@property (nonatomic, strong) NSString *headerTitle;

/**
 点击查看更多的回调
 */
@property (nonatomic, copy) THNTableViewSectionMoreBlock selectedMoreCompletion;

+ (instancetype)initSections;
+ (instancetype)initSectionsWithCells:(NSMutableArray *)cells;
+ (instancetype)initSectionsWithHeaderTitle:(NSString *)title;
+ (instancetype)initSectionsWithHeaderTitle:(NSString *)title moreCompletion:(void (^)(void))completion;

@end