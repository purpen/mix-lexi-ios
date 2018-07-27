//
//  THNQiNiuUpload.h
//  lexi
//
//  Created by FLYang on 2018/7/25.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface THNQiNiuUpload : NSObject

/**
 上传图片到七牛

 @param params 七牛服务端参数
 @param image 图片
 @param completion 上传成功的回调
 */
+ (void)uploadQiNiuWithParams:(NSDictionary *)params
                        image:(UIImage *)image
                    compltion:(void (^)(NSDictionary *result))completion;

@end
