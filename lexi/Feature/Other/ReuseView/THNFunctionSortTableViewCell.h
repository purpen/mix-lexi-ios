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
    THNFunctionSortTypePriceDown    //  价格低
};

@interface THNFunctionSortTableViewCell : UITableViewCell

- (void)thn_setCellTitleWithType:(THNFunctionSortType)type;

/**
 设置选中状态
 */
- (void)thn_setCellSelected:(BOOL)selected;

@end
