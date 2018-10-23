//
//  THNSkuFilter.h
//  lexi
//
//  Created by FLYang on 2018/9/13.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class THNSkuFilter;
@class THNSkuMode;

@protocol THNSkuFilterDataSource <NSObject>

@required
/// 型号种类的数量
- (NSInteger)thn_numberOfSectionsForModeInFilter:(THNSkuFilter *)filter;
/// 满足筛选条件的数量
- (NSInteger)thn_numberOfConditionsInFilter:(THNSkuFilter *)filter;
/// 型号的属性名称
- (NSArray *)thn_filter:(THNSkuFilter *)filter modesInSection:(NSInteger)section;
/// 可组合的型号
- (NSArray *)thn_filter:(THNSkuFilter *)filter conditionForRow:(NSInteger)row;
/// 可组合的型号结果条件
- (id)thn_filter:(THNSkuFilter *)filter resultOfConditionForRow:(NSInteger)row;

@end

@interface THNSkuFilter : NSObject

@property (nonatomic, assign) id<THNSkuFilterDataSource> dataSource;

/**
 选中的属性
 */
@property (nonatomic, strong, readonly) NSArray<NSIndexPath *> *selectedIndexPaths;

/**
 可选的型号
 */
@property (nonatomic, strong, readonly) NSSet<NSIndexPath *> *availableIndexPathsSet;

/**
 结果
 */
@property (nonatomic, strong, readonly) id currentResult;

/**
 选中型号
 */
- (void)thn_didSelectedModeWithIndexPath:(NSIndexPath *)indexPath;

/**
 刷新数据
 */
- (void)thn_reloadData;

- (instancetype)initWithDataSource:(id <THNSkuFilterDataSource>)dataSource;

@end

#pragma mark - 筛选条件
@interface THNSkuCondition : NSObject

@property (nonatomic, strong) NSArray <THNSkuMode *> *modes;
@property (nonatomic, strong, readonly) NSArray<NSNumber *> *conditionIndexs;
@property (nonatomic, strong) id result;

@end

#pragma mark - SKU 型号
@interface THNSkuMode :NSObject

@property (nonatomic, copy, readonly) NSIndexPath *indexPath;
@property (nonatomic, copy, readonly) NSString *value;

- (instancetype)initWithValue:(NSString *)value indexPath:(NSIndexPath *)indexPath;

@end
