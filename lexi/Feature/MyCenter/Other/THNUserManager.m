//
//  THNUserManager.m
//  lexi
//
//  Created by FLYang on 2018/8/17.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNUserManager.h"
#import "THNAPI.h"

/// api 拼接地址
static NSString *const kURLUserCenter    = @"/users/user_center";

@implementation THNUserManager

- (void)requestUserCenterCompletion:(void (^)(THNUserModel *, NSError *))completion {
    THNRequest *request = [THNAPI getWithUrlString:kURLUserCenter requestDictionary:nil isSign:YES delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (![result hasData]) return;
        
        NSLog(@"data ==== %@", result.data);
        THNUserModel *model = [THNUserModel mj_objectWithKeyValues:result.data];
        completion(model, nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        completion(nil, error);
    }];
}

+ (void)getUserCenterCompletion:(void (^)(THNUserModel *, NSError *))completion {
    [[THNUserManager sharedManager] requestUserCenterCompletion:completion];
}

/**
 存档文件路径
 */
+ (NSString *)archiveFilePath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingString:NSStringFromClass(self)];
}

#pragma mark - shared
static id _instance = nil;

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [NSKeyedUnarchiver unarchiveObjectWithFile:[self archiveFilePath]];
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


@end
