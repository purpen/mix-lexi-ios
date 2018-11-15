//
//  THNGoodsButton.h
//  lexi
//
//  Created by FLYang on 2018/8/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+EnumManagement.h"

@interface THNGoodsButton : UIButton

/**
 标题
 */
@property (nonatomic, strong) NSString *title;

/**
 商品Id
 */
@property (nonatomic, strong) NSString *productId;

/**
 可赚多少钱
 */
@property (nonatomic, assign) CGFloat makeMoney;

/**
 操作类型
 */
@property (nonatomic, assign) THNGoodsButtonType type;

- (instancetype)initWithType:(THNGoodsButtonType)type;
- (instancetype)initWithFrame:(CGRect)frame type:(THNGoodsButtonType)type;

@end
