//
//  THNShareImageViewController.h
//  lexi
//
//  Created by FLYang on 2018/11/3.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNBaseViewController.h"
#import "NSObject+EnumManagement.h"

@interface THNShareImageViewController : THNBaseViewController

/**
 分享的各种海报

 @param type 海报的类型
 @param requestId 请求参数 rid
 @return self
 */
- (instancetype)initWithType:(THNSharePosterType)type requestId:(NSString *)requestId;

@end
