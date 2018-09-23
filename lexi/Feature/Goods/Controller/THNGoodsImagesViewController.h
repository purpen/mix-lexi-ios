//
//  THNGoodsImagesViewController.h
//  lexi
//
//  Created by FLYang on 2018/8/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBaseViewController.h"
#import "THNGoodsModel.h"
#import "THNSkuModel.h"
#import "NSObject+EnumManagement.h"

@interface THNGoodsImagesViewController : THNBaseViewController

- (void)thn_scrollContentWithIndex:(NSInteger)index;

- (instancetype)initWithGoodsModel:(THNGoodsModel *)goodsModel skuModel:(THNSkuModel *)skuModel;

/**
 SKU 视图的类型，执行的操作类型
 
 @param functionType 视图类型
 @param handleType 执行的操作
 @param string 标题文字
 */
- (void)thn_setSkuFunctionViewType:(THNGoodsFunctionViewType)functionType
                        handleType:(THNGoodsButtonType)handleType
             titleAttributedString:(NSAttributedString *)string;

@end
