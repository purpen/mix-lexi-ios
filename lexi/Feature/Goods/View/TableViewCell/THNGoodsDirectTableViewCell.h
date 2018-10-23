//
//  THNGoodsDirectTableViewCell.h
//  lexi
//
//  Created by FLYang on 2018/9/1.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsBaseTableViewCell.h"

@interface THNGoodsDirectTableViewCell : THNGoodsBaseTableViewCell

/**
 设置“订制商品”的天数
 
 @param days 所需天数
 @param isInclude 是否包含节假日
 */
- (void)thn_setCustomNumberOfDays:(NSInteger)days isIncludeHolidays:(BOOL)isInclude;

@end
