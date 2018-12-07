//
//  THNShareViewController.h
//  lexi
//
//  Created by FLYang on 2018/6/22.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBaseViewController.h"
#import "NSObject+EnumManagement.h"

@interface THNShareViewController : THNBaseViewController

- (instancetype)initWithType:(THNSharePosterType)posterType;

/**
 初始化分享视图

 @param posterType 生成的海报类型
 @param requestId 海报链接的 id
 @return self
 */
- (instancetype)initWithType:(THNSharePosterType)posterType requestId:(NSString *)requestId;

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
