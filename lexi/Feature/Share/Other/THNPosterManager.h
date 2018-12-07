//
//  THNPosterManager.h
//  lexi
//
//  Created by FLYang on 2018/12/5.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+EnumManagement.h"

@interface THNPosterManager : NSObject

/**
 获取分享的海报图片

 @param type 海报类型
 @param requestId rid
 @param completion 海报图片
 */
+ (void)getSharePosterImageDataWithType:(THNSharePosterType)type
                              requestId:(NSString *)requestId
                             completion:(void (^)(NSString *imageUrl))completion;

@end
