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

/**
 * @param title 标题
 * @param descr 描述
 * @param thumImageStr 缩略图
 * @param url 链接地址
 *
 */
- (void)shareObjectWithTitle:(NSString *)title
                       descr:(NSString *)descr
                   thumImage:(NSString *)thumImageStr
                      webUrl:(NSString *)url;


@end
