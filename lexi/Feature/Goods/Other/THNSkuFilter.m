//
//  THNSkuFilter.m
//  lexi
//
//  Created by FLYang on 2018/9/13.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSkuFilter.h"

@interface THNSkuFilter ()

/// 型号可组合的条件
@property (nonatomic, strong) NSSet <THNSkuCondition *> *conditions;
/// 选择的位置
@property (nonatomic, strong) NSMutableArray <NSIndexPath *> *selectedIndexPaths;
/// 当前可选择的位置集合
@property (nonatomic, strong) NSMutableSet <NSIndexPath *> *availableIndexPathsSet;
/// 可选择的位置
@property (nonatomic, strong) NSSet <NSIndexPath *> *allAvailableIndexPaths;
/// 当前的结果
@property (nonatomic, strong) id currentResult;

@end

@implementation THNSkuFilter

- (instancetype)initWithDataSource:(id <THNSkuFilterDataSource>)dataSource {
    self = [super init];
    if (self) {
        _dataSource = dataSource;
        _selectedIndexPaths = [NSMutableArray array];
        [self initSkuModesData];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _selectedIndexPaths = [NSMutableArray array];
    }
    return self;
}

- (void)thn_reloadData {
    [_selectedIndexPaths removeAllObjects];
    [self initSkuModesData];
    [self thn_updateCurrentResult];
}

#pragma mark - public methods
- (void)thn_didSelectedModeWithIndexPath:(NSIndexPath *)indexPath {
    // 不可选
    if (![_availableIndexPathsSet containsObject:indexPath]) return;
    
    // 越界
    if (indexPath.section > [_dataSource thn_numberOfSectionsForModeInFilter:self] || \
        indexPath.item >= [[_dataSource thn_filter:self modesInSection:indexPath.section] count]) {
        return;
    }
    
    // 已选中
    if ([_selectedIndexPaths containsObject:indexPath]) {
        [_selectedIndexPaths removeObject:indexPath];
        
        [self thn_updateAvailableIndexPaths];
        [self thn_updateCurrentResult];
        
        return;
    }
    
    __block NSIndexPath *lastIndexPath = nil;
    
    [_selectedIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (indexPath.section == obj.section) {
            lastIndexPath = obj;
        }
    }];
    
    if (!lastIndexPath) {
        // 添加新型号
        [_selectedIndexPaths addObject:indexPath];
        [_availableIndexPathsSet intersectSet:[self thn_availableIndexPathsFromSelctedIndexPath:indexPath sectedIndexPaths:_selectedIndexPaths]];
        [self thn_updateCurrentResult];
        
        return;
    }
    
    if (lastIndexPath.item != indexPath.item) {
        // 切换型号
        [_selectedIndexPaths addObject:indexPath];
        [_selectedIndexPaths removeObject:lastIndexPath];
        [self thn_updateAvailableIndexPaths];
        [self thn_updateCurrentResult];
    }
}

#pragma mark - private methods
// 获取 SKU 型号初始数据
- (void)initSkuModesData {
    NSMutableSet *modeSet = [NSMutableSet set];
    
    for (NSInteger idx = 0; idx < [_dataSource thn_numberOfConditionsInFilter:self]; idx ++) {
        
        THNSkuCondition *model = [THNSkuCondition new];
        NSArray *conditions = [_dataSource thn_filter:self conditionForRow:idx];
        
        if (![self thn_checkMatchingSKuWithConditions:conditions]) continue;
        
        model.modes = [self thn_getModeWithConditionData:conditions];
        model.result = [_dataSource thn_filter:self resultOfConditionForRow:idx];
        
        [modeSet addObject:model];
    }
    
    _conditions = [modeSet copy];
    [self getAllAvailableIndexPaths];
}

// 检查 SKU 数据是否匹配
- (BOOL)thn_checkMatchingSKuWithConditions:(NSArray *)conditions {
    if (conditions.count != [_dataSource thn_numberOfSectionsForModeInFilter:self]) {
        return NO;
    }
    
    __block BOOL flag = YES;
    [conditions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *properties = [self.dataSource thn_filter:self modesInSection:idx];
        if (![properties containsObject:obj]) {
            flag = NO;
            *stop = YES;
        }
    }];
    
    return flag;
}

// 获取型号
- (NSArray<THNSkuMode *> *)thn_getModeWithConditionData:(NSArray *)data {
    NSMutableArray *array = [NSMutableArray array];
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:[self thn_getModeOfValue:obj inSection:idx]];
    }];
    
    return array;
}

- (THNSkuMode *)thn_getModeOfValue:(NSString *)value inSection:(NSInteger)section {
    NSArray *modes = [_dataSource thn_filter:self modesInSection:section];
    
    // 错误信息
    NSString *str = [NSString stringWithFormat:@"Modes for %ld dosen‘t exist %@", (long)section, value];
    NSAssert([modes containsObject:value], str);
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[modes indexOfObject:value] inSection:section];
    
    return [[THNSkuMode alloc] initWithValue:value indexPath:indexPath];
}

// 获取选择条件对应的型号
- (id)thn_getSkuResultWithConditionIndexs:(NSArray<NSNumber *> *)conditionIndexs {
    __block id result = nil;
    
    [_conditions enumerateObjectsUsingBlock:^(THNSkuCondition * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj.conditionIndexs isEqual:conditionIndexs]) {
            result = obj.result;
            *stop = YES;
        }
    }];
    
    return result;
}

// 获取初始可选的 IndexPath
- (NSMutableSet<NSIndexPath *> *)getAllAvailableIndexPaths {
    NSMutableSet *set = [NSMutableSet set];
    
    [_conditions enumerateObjectsUsingBlock:^(THNSkuCondition * _Nonnull obj, BOOL * _Nonnull stop) {
        [obj.conditionIndexs enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
            [set addObject:[NSIndexPath indexPathForItem:obj1.integerValue inSection:idx1]];
        }];
    }];
    
    _availableIndexPathsSet = set;
    _allAvailableIndexPaths = [set copy];
    
    return set;
}

// 选中型号时，根据已选中的型号，获取可选 SKU 的 IndexPath
- (NSMutableSet<NSIndexPath *> *)thn_availableIndexPathsFromSelctedIndexPath:(NSIndexPath *)selectedIndexPath
                                                            sectedIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    
    NSMutableSet *set = [NSMutableSet set];
    
    [_conditions enumerateObjectsUsingBlock:^(THNSkuCondition * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj.conditionIndexs objectAtIndex:selectedIndexPath.section].integerValue == selectedIndexPath.item) {
            [obj.modes enumerateObjectsUsingBlock:^(THNSkuMode * _Nonnull property, NSUInteger idx2, BOOL * _Nonnull stop1) {
                
                // 选择种类不同的型号时，需要根据已选中的型号过滤
                if (property.indexPath.section != selectedIndexPath.section) {
                    __block BOOL flag = YES;
                    
                    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj1, NSUInteger idx, BOOL * _Nonnull stop) {
                        flag = (([obj.conditionIndexs[obj1.section] integerValue] == obj1.row) || \
                                (obj1.section == property.indexPath.section)) && flag;
                    }];
                    
                    if (flag) {
                        [set addObject:property.indexPath];
                    }
                    
                } else {
                    [set addObject:property.indexPath];
                }
            }];
        }
    }];
    
    [_allAvailableIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.section == selectedIndexPath.section) {
            [set addObject:obj];
        }
    }];
    
    return set;
}

// 刷新当前可选择的位置
- (void)thn_updateAvailableIndexPaths {
    if (_selectedIndexPaths.count == 0) {
        _availableIndexPathsSet = [_allAvailableIndexPaths mutableCopy];
        return ;
    }
    
    __block NSMutableSet *set = [NSMutableSet set];
    NSMutableArray *seleted = [NSMutableArray array];
    
    [_selectedIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [seleted addObject:obj];

        NSMutableSet *tempSet = nil;
        tempSet = [self thn_availableIndexPathsFromSelctedIndexPath:obj sectedIndexPaths:seleted];
        
        if (set.count == 0) {
            set = [tempSet mutableCopy];
            
        } else {
            [set intersectSet:tempSet];
        }
    }];
    
    _availableIndexPathsSet = set;
}

// 刷新当前结果
- (void)thn_updateCurrentResult {
    if (_selectedIndexPaths.count != [_dataSource thn_numberOfSectionsForModeInFilter:self]) {
        _currentResult = nil;
        return;
    }
    
    NSMutableArray *conditions = [NSMutableArray array];
    
    for (NSInteger i = 0; i < [_dataSource thn_numberOfSectionsForModeInFilter:self]; i ++) {
        [_selectedIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.section == i) {
                [conditions addObject:@(obj.row)];
            }
        }];
    }
    
    _currentResult = [self thn_getSkuResultWithConditionIndexs:[conditions copy]];
}

- (BOOL)isAvailableWithPropertyIndexPath:(NSIndexPath *)indexPath {
    __block BOOL isAvailable = NO;
    
    [_conditions enumerateObjectsUsingBlock:^(THNSkuCondition * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj.conditionIndexs objectAtIndex:indexPath.section].integerValue == indexPath.row) {
            isAvailable = YES;
            *stop = YES;
        }
    }];
    
    return isAvailable;
}

#pragma mark - getters and setters
- (void)setDataSource:(id<THNSkuFilterDataSource>)dataSource {
    _dataSource = dataSource;
    
    [self initSkuModesData];
}

@end

#pragma mark - Condition
@implementation THNSkuCondition
- (void)setModes:(NSArray<THNSkuMode *> *)modes {
    _modes = modes;
    NSMutableArray *array = [NSMutableArray array];
    
    [modes enumerateObjectsUsingBlock:^(THNSkuMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:@(obj.indexPath.item)];
    }];
    
    _conditionIndexs = [array copy];
}

@end

#pragma mark - Mode
@implementation THNSkuMode

- (instancetype)initWithValue:(id)value indexPath:(NSIndexPath *)indexPath {
    self = [super init];
    if (self) {
        _value = value;
        _indexPath = indexPath;
    }
    return self;
}

@end
