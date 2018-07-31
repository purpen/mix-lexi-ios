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

+ (instancetype)sharedManager;

/**
 上传图片到七牛

 @param params 七牛服务端参数
 @param imageData 图片数据
 @param completion 上传成功的回调
 */
- (void)uploadQiNiuWithParams:(NSDictionary *)params
                    imageData:(NSData *)imageData
                    compltion:(void (^)(NSDictionary *result))completion;

@end