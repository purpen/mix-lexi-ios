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
    THNGoodsActionButtonTypeWish,       // 心愿单
    THNGoodsActionButtonTypePutaway,    // 上架
    THNGoodsActionButtonTypeBuy         // 购买
};

@interface THNGoodsActionButton : UIButton

- (instancetype)initWithType:(THNGoodsActionButtonType)type;

@end
