//
//  THNShareWxaViewController.h
//  lexi
//
//  Created by FLYang on 2018/11/29.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNBaseViewController.h"
#import "THNShareWxaView.h"

@interface THNShareWxaViewController : THNBaseViewController

/**
 销售商品的佣金
 */
@property (nonatomic, assign) CGFloat sellMoney;

/**
 分享的各种海报x
 
 @param type 海报的类型
 @param requestId 请求参数 rid
 @return self
 */
- (instancetype)initWithType:(THNShareWxaViewType)type requestId:(NSString *)requestId;

@end
