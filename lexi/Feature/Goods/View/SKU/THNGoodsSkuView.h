//
//  THNGoodsSkuView.h
//  lexi
//
//  Created by FLYang on 2018/8/31.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+EnumManagement.h"
#import "THNSkuModel.h"

@interface THNGoodsSkuView : UIView

/**
 执行的操作类型
 */
@property (nonatomic, assign) THNGoodsButtonType handleType;

/**
 商品 id
 */
@property (nonatomic, copy) NSString *goodsId;

/**
 SKU 数据
 */
- (void)thn_setGoodsSkuModel:(THNSkuModel *)model;

/**
 设置商品标题
 */
- (void)thn_setTitleAttributedString:(NSAttributedString *)string;

/**
 执行的操作类型
 
 @param handleType 执行的操作
 @param string 标题文字
 */
- (void)thn_setGoodsSkuViewHandleType:(THNGoodsButtonType)handleType titleAttributedString:(NSAttributedString *)string;


@end
