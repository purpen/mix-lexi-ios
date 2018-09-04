//
//  THNGoodsActionButton.h
//  lexi
//
//  Created by FLYang on 2018/9/1.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, THNGoodsActionButtonType) {
    THNGoodsActionButtonTypeLike = 0,   // 喜欢
    THNGoodsActionButtonTypeLikeCount,  // 喜欢的数量
    THNGoodsActionButtonTypeWish,       // 心愿单
    THNGoodsActionButtonTypePutaway,    // 上架
    THNGoodsActionButtonTypeBuy         // 购买
};

@interface THNGoodsActionButton : UIButton

@property (nonatomic, assign) THNGoodsActionButtonType type;
@property (nonatomic, strong) NSString *goodsId;
@property (nonatomic, assign) NSInteger likeCount;

/**
 喜欢的状态
 */
- (void)setLikedGoodsStatus:(BOOL)liked;

/**
 喜欢的状态
 */
- (void)setLikedGoodsStatus:(BOOL)liked count:(NSInteger)count;

/**
 加入心愿单的状态
 */
- (void)setWishGoodsStatus:(BOOL)wish;

/**
 上架商品的状态
 */
- (void)setPutawayGoodsStauts:(BOOL)putaway;

- (instancetype)initWithType:(THNGoodsActionButtonType)type;

@end
