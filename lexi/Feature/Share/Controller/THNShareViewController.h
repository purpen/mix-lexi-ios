//
//  THNShareViewController.h
//  lexi
//
//  Created by FLYang on 2018/6/22.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBaseViewController.h"

typedef NS_ENUM(NSUInteger, ShareContentType) {
    ShareContentTypeGoods = 0,  // 分享商品
    ShareContentTypeArticle,    // 分享文章
};

@interface THNShareViewController : THNBaseViewController

- (instancetype)initWithType:(ShareContentType)type;

@end
