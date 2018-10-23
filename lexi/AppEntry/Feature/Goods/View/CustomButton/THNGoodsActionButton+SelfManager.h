//
//  THNGoodsActionButton+SelfManager.h
//  lexi
//
//  Created by FLYang on 2018/9/2.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsActionButton.h"

@interface THNGoodsActionButton (SelfManager)

/**
 喜欢商品
 
 @param like 是否喜欢
 @param goodsId 商品 id
 */
- (void)selfManagerLikeGoodsStatus:(BOOL)like goodsId:(NSString *)goodsId;

/**
 喜欢商品
 
 @param like 是否喜欢
 @param count 喜欢数量
 @param goodsId 商品 id
 */
- (void)selfManagerLikeGoodsStatus:(BOOL)like count:(NSInteger)count goodsId:(NSString *)goodsId;

/**
 加入心愿单商品
 
 @param wish 是否加入
 @param goodsId 商品 id
 */
- (void)selfManagerWishGoodsStatus:(BOOL)wish goodsId:(NSString *)goodsId;

@end
