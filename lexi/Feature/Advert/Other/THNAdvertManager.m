//
//  THNAdvertManager.m
//  lexi
//
//  Created by FLYang on 2018/11/27.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNAdvertManager.h"
#import <MJExtension/MJExtension.h>
#import "THNAPI.h"
#import "THNMarco.h"
#import "THNLoginManager.h"

/// url
static NSString *const kURLNewUserBonus = @"/market/is_new_user_bonus";
/// key
static NSString *const kKeyIsGrant = @"is_grant";

@implementation THNAdvertManager

MJCodingImplementation

+ (BOOL)canGetBonus {
    if ([THNAdvertManager sharedManager].isGrant) {
        return NO;
    }
    
    if (![THNLoginManager isLogin]) {
        return YES;
        
    } else {
        return ![THNAdvertManager sharedManager].isGrant;
    }
    
    return YES;
}

/**
 清除登录信息
 */
- (void)clearAdvertInfo {
    self.isGrant = NO;
    
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if ([defaultManager isDeletableFileAtPath:[[self class] archiveFilePath]]) {
        [defaultManager removeItemAtPath:[[self class] archiveFilePath] error:nil];
    }
}

+ (void)checkIsNewUserBonus {
    [[THNAdvertManager sharedManager] networkIsNewUserBonus];
}

- (void)updateGrantStatus:(BOOL)status {
    self.isGrant = status;
    [self saveAdvertDataInfo];
}

#pragma mark - network
- (void)networkIsNewUserBonus {
    THNRequest *request = [THNAPI getWithUrlString:kURLNewUserBonus requestDictionary:@{} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.isSuccess) {
            self.isGrant = NO;
            [self saveAdvertDataInfo];
        }
        
        self.isGrant = [result.data[kKeyIsGrant] boolValue];
        [self saveAdvertDataInfo];
        
    } failure:^(THNRequest *request, NSError *error) {
        self.isGrant = NO;
        [self saveAdvertDataInfo];
    }];
}

#pragma mark - private methods
/**
 保存广告活动信息
 */
- (void)saveAdvertDataInfo {
    [NSKeyedArchiver archiveRootObject:self toFile:[[self class] archiveFilePath]];
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
