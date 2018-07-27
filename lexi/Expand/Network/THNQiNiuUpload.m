//
//  THNQiNiuUpload.m
//  lexi
//
//  Created by FLYang on 2018/7/25.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNQiNiuUpload.h"
#import <Qiniu/QiniuSDK.h>
#import "NSString+Helper.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "THNMarco.h"

static NSString *const kResultToken     = @"up_token";
static NSString *const kResultDirectory = @"directory_id";
static NSString *const kResultEndPoint  = @"up_endpoint";
static NSString *const kResultUserId    = @"user_id";

@implementation THNQiNiuUpload

+ (void)uploadQiNiuWithParams:(NSDictionary *)params image:(UIImage *)image compltion:(void (^)(NSDictionary *))completion {
    NSString *token = params[kResultToken];
    
    if (!token.length) {
        [SVProgressHUD showErrorWithStatus:@"上传token不存在"];
        return;
    }
    
    if (!image) {
        [SVProgressHUD showErrorWithStatus:@"上传图片错误"];
        return;
    }
    
    NSString *filePath = [NSString getImagePath:image];
    NSString *directoryId = [NSString stringWithFormat:@"%zi", [params[kResultDirectory] integerValue]];
    NSString *userId = [NSString stringWithFormat:@"%zi", [params[kResultUserId] integerValue]];
    
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:nil
                                               progressHandler:nil
                                                        params:@{@"x:directory_id": directoryId,
                                                                 @"x:user_id": userId}
                                                      checkCrc:YES
                                            cancellationSignal:nil];
    
    [upManager putFile:filePath
                   key:nil
                 token:token
              complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                  if (info.ok) {
                      completion(resp);
                  } else {
                      [SVProgressHUD showErrorWithStatus:@"上传失败"];
                  }
              }
                option:opt];
}

@end
