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

static NSString *const kQiNiuToken = @"";

@implementation THNQiNiuUpload

+ (void)uploadQiNiuToken:(NSString *)token image:(UIImage *)image compltion:(void (^)(NSDictionary *))completion {
    if (!token) {
        [SVProgressHUD showErrorWithStatus:@"上传 token 错误"];
        return;
    }
    
    if (!image) {
        [SVProgressHUD showErrorWithStatus:@"上传图片错误"];
        return;
    }
    
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    NSString *key = [[NSString getTimestamp] stringByAddingPercentEncodingWithAllowedCharacters: \
                     [NSCharacterSet URLQueryAllowedCharacterSet]];
    NSData *data = UIImageJPEGRepresentation(image, 1);
    
    [upManager putData:data
                   key:key
                 token:token
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                  if (info.ok) {
                      completion(resp);
                  } else {
                      [SVProgressHUD showErrorWithStatus:@"上传失败"];
                  }
                  
              } option:nil];
}

@end
