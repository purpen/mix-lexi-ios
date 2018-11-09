//
//  THNDealContentTableViewCell.h
//  lexi
//
//  Created by FLYang on 2018/9/3.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNGoodsBaseTableViewCell.h"
#import "NSObject+EnumManagement.h"

@interface THNDealContentTableViewCell : THNGoodsBaseTableViewCell

/**
 设置图文详情内容
 */
- (void)thn_setDealContentData:(NSArray *)dealContent;
- (void)thn_setDealContentData:(NSArray *)dealContent type:(THNDealContentType)type;

@end
