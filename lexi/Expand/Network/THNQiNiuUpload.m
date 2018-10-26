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
#import "SVProgressHUD+Helper.h"
#import "THNMarco.h"
#import "THNAPI.h"

static NSString *const kResultToken     = @"up_token";
static NSString *const kResultDirectory = @"directory_id";
static NSString *const kResultEndPoint  = @"up_endpoint";
static NSString *const kResultUserId    = @"user_id";
/// 获取七牛token
static NSString *const kURLUpToken      = @"/assets/user_upload_token";

@interface THNQiNiuUpload()

@property (nonatomic, strong) NSMutableDictionary *params;

@end

@implementation THNQiNiuUpload

- (void)uploadQiNiuWithImageData:(NSData *)imageData compltion:(void (^)(NSDictionary *))completion {
    THNRequest *request = [THNAPI getWithUrlString:kURLUpToken requestDictionary:nil delegate:nil];
    
    [SVProgressHUD thn_show];
    
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (![result hasData]) return;
        
       self.params = result.responseDict[@"data"];
        
        NSString *token = self.params[kResultToken];
        
        if (!imageData || !token.length) {
            [SVProgressHUD thn_showErrorWithStatus:@"上传图片错误"];
            return;
        }
        
        NSString *filePath = [NSString getImagePath:[UIImage imageWithData:imageData]];
        NSString *directoryId = [NSString stringWithFormat:@"%zi", [self.params[kResultDirectory] integerValue]];
        NSString *userId = [NSString stringWithFormat:@"%zi", [self.params[kResultUserId] integerValue]];
        
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
                      if (!info.ok) {
                          [SVProgressHUD thn_showErrorWithStatus:@"上传失败"];
                          return ;
                      }
                      
                      if (completion) {
                          completion(resp);
                      }
                  }
                    option:opt];
        
        [SVProgressHUD dismiss];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - shared
static id _instance = nil;

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_instance) {
            _instance = [[self alloc] init];
        }
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

#pragma mark - lazy
- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [NSMutableDictionary dictionary];
    }
    return _params;
}

@end
