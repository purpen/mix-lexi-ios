//
//  THNFunctionSortTableViewCell.h
//  lexi
//
//  Created by FLYang on 2018/8/28.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, THNFunctionSortType) {
    THNFunctionSortTypeDefault = 0, //  默认
    THNFunctionSortTypeSynthesize,  //  综合
    THNFunctionSortTypePriceUp,     //  价格高
    THNFunctionSortTypePriceDown,   //  价格低
    THNFunctionSortTypeNewest       //  最新
};

@interface THNFunctionSortTableViewCell : UITableViewCell

@property (nonatomic, assign) THNFunctionSortType sortType;

/// 标题
@property (nonatomic, strong) UILabel *titleLabel;

/**
 设置排序条件

 @param type 排序类型
 */
- (void)thn_setSortConditionWithType:(THNFunctionSortType)type;

/**
 设置选中状态
 */
- (void)thn_setCellSelected:(BOOL)selected;

@end
