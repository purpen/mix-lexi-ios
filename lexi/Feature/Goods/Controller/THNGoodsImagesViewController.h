//
//  THNGoodsImagesViewController.h
//  lexi
//
//  Created by FLYang on 2018/8/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBaseViewController.h"
#import "THNGoodsModel.h"

typedef void(^BuyGoodsCompleted)(void);

@interface THNGoodsImagesViewController : THNBaseViewController

@property (nonatomic, copy) BuyGoodsCompleted buyGoodsCompleted;

- (instancetype)initWithGoodsModel:(THNGoodsModel *)model;

@end
