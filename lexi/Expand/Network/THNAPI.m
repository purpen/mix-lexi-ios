//
//  THNAPI.m
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNAPI.h"
#import "THNConst.h"
#import "NSString+Encryption.h"
#import "NSString+Helper.h"

#import "THNLoginManager.h"

static NSString *const kLoginInfoAppKey     = @"app_key";
static NSString *const kLoginInfoTimestamp  = @"timestamp";
static NSString *const kLoginInfoNonceStr   = @"nonce_str";
static NSString *const kLoginInfoEmail      = @"email";
static NSString *const kLoginInfoPassword   = @"password";

@interface THNAPI ()

@end

@implementation THNAPI

#pragma mark - Private Methods
- (NSString *)appKey {
    NSString *key = [THNLoginManager isLogin] ? [THNLoginManager sharedManager].appKey : @"";
    
    return key;
}

- (NSString *)appSecret {
    NSString *secret = [THNLoginManager isLogin] ? [THNLoginManager sharedManager].accessToken : @"";
    
    return secret;
}

- (NSString *)appToken {
    NSString *token = [THNLoginManager isLogin] ? [THNLoginManager sharedManager].token : @"";
    
    return token;
}

- (NSString *)timestamp {
    NSString *time = [NSString getTimestamp];
    
    return time;
}

- (NSString *)nonceStr {
    NSString *randomStr = [NSString randomStringWithLength:12];
    
    return randomStr;
}

#pragma mark -
/**
 获取授权
 */
- (NSString *)getAuthorizationToken:(NSDictionary *)requestDictionary {
    NSMutableString *prefix = [NSMutableString stringWithFormat:@"Basic  "];
    
    NSString *param1 = [THNLoginManager isLogin] ? [self appToken] : requestDictionary[kLoginInfoEmail];
    NSString *param2 = [THNLoginManager isLogin] ? [self appToken] : requestDictionary[kLoginInfoPassword];
    NSString *paramStr = [NSString stringWithFormat:@"%@:%@", param1, param2];
    
    [prefix appendString:[NSString base64StringFromString:paramStr]];
    
    NSString *tokenStr = [prefix trimString];
    
    return tokenStr;
}

/**
 获取请求的签名
 */
- (NSString *)getSign:(NSDictionary *)params {
    NSMutableArray *keys = [NSMutableArray arrayWithArray:[params allKeys]];
    
    // 参数字典排序
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSUInteger tmp = 0;
        
        NSNumber *key1;
        NSNumber *key2;
        
        do {
            if (tmp > ([(NSString *) obj1 length] - 1)) {
                NSAssert((tmp <= ([(NSString *) obj2 length] - 1)), @"传入了两个完全相同的参数！");
                key1 = @0;
                key2 = @([(NSString *) obj2 characterAtIndex:tmp]);
                break;
            }
            
            if (tmp > ([(NSString *) obj2 length] - 1)) {
                NSAssert((tmp <= ([(NSString *) obj1 length] - 1)), @"传入了两个完全相同的参数！");
                key2 = @0;
                key1 = @([(NSString *) obj1 characterAtIndex:tmp]);
                break;
            }
            
            key1 = @([(NSString *) obj1 characterAtIndex:tmp]);
            key2 = @([(NSString *) obj2 characterAtIndex:tmp]);
            tmp++;
            
        } while ([key1 intValue] == [key2 intValue]);
        
        NSComparisonResult result = [key1 compare:key2];
        
        return result;
    }];
    
    NSMutableString *paraStr = [NSMutableString stringWithCapacity:0];
    
    int i = 0;
    for (NSString *key in sortedKeys) {
        NSString *value = params[key];
        if (i == 0) {
            [paraStr appendString:[NSString stringWithFormat:@"%@=%@", key, value]];
        } else {
            [paraStr appendString:[NSString stringWithFormat:@"&%@=%@", key, value]];
        }
        i++;
    }
    
    // 拼接参数末尾拼接 AppSecret
    [paraStr appendString:[self appSecret]];
    
    return [NSString sha1StringFromString:paraStr];
}

/**
 设置 HTTP 头
 */
- (NSDictionary *)HTTPHeaderFieldsWithValues {
    NSString *token = [self getAuthorizationToken:self.requestDictionary];
    
    return @{@"Authorization": token};
}

/**
 改变请求的参数，添加公共参数
 */
- (NSDictionary *)transformRequestDictionary {
    NSMutableDictionary *fullDictionary = [[NSMutableDictionary alloc] initWithDictionary:self.requestDictionary];
    
    //  加密的参数
    NSDictionary *paramDictionary = @{kLoginInfoAppKey: [self appKey],
                                      kLoginInfoNonceStr: [self nonceStr],
                                      kLoginInfoTimestamp: [self timestamp]};
    
    [fullDictionary setValuesForKeysWithDictionary:paramDictionary];
    
    if (self.sign) {
        // 获取签名
        NSString *sign = [self getSign:paramDictionary];
        [fullDictionary setValue:sign forKey:@"sign"];
    }
    
    return fullDictionary;
}

/**
 改变请求的数据
 */
- (id)transformRequestData:(id)data {
    return data;
}

#pragma mark - request

+ (instancetype)getWithUrlString:(NSString *)urlString
               requestDictionary:(NSDictionary *)requestDictionary
                          isSign:(BOOL)sign
                        delegate:(id)delegate {
    
    return [THNAPI requestWithUrlString:[kDomainBaseUrl stringByAppendingString:urlString]
                      requestDictionary:requestDictionary
                               delegate:delegate
                        timeoutInterval:600.0
                                   flag:nil
                                 isSign:sign
                          requestMethod:AFNetworkingRequestMethodGET
                            requestType:AFNetworkingRequestTypeJSON
                           responseType:AFNetworkingResponseTypeJSON];
}

+ (instancetype)postWithUrlString:(NSString *)urlString
                requestDictionary:(NSDictionary *)requestDictionary
                           isSign:(BOOL)sign
                         delegate:(id)delegate {
    
    return [THNAPI requestWithUrlString:[kDomainBaseUrl stringByAppendingString:urlString]
                      requestDictionary:requestDictionary
                               delegate:delegate
                        timeoutInterval:600.0
                                   flag:nil
                                 isSign:sign
                          requestMethod:AFNetworkingRequestMethodPOST
                            requestType:AFNetworkingRequestTypeJSON
                           responseType:AFNetworkingResponseTypeJSON];
}

+ (instancetype)uploadWithUrlString:(NSString *)urlString
                  requestDictionary:(NSDictionary *)requestDictionary
                             isSign:(BOOL)sign
                           delegate:(id)delegate {
    
    return [THNAPI requestWithUrlString:[kDomainBaseUrl stringByAppendingString:urlString]
                      requestDictionary:requestDictionary
                               delegate:delegate
                        timeoutInterval:600.0
                                   flag:nil
                                 isSign:sign
                          requestMethod:AFNetworkingRequestMethodUPLOAD
                            requestType:AFNetworkingRequestTypeJSON
                           responseType:AFNetworkingResponseTypeJSON];
}

+ (instancetype)deleteWithUrlString:(NSString *)urlString
                  requestDictionary:(NSDictionary *)requestDictionary
                             isSign:(BOOL)sign
                           delegate:(id)delegate {
    
    return [THNAPI requestWithUrlString:[kDomainBaseUrl stringByAppendingString:urlString]
                      requestDictionary:requestDictionary
                               delegate:delegate
                        timeoutInterval:600.0
                                   flag:nil
                                 isSign:sign
                          requestMethod:AFNetworkingRequestMethodDELETE
                            requestType:AFNetworkingRequestTypeJSON
                           responseType:AFNetworkingResponseTypeJSON];
}

#pragma mark -

/**
 从返回的URL中读取参数
 
 @param url 链接
 @param paramName 参数名
 @return 读取参数
 */
+ (NSString *)getParamValueFromUrl:(NSString *)url paramName:(NSString *)paramName {
    if (![paramName hasSuffix:@"="]) {
        paramName = [NSString stringWithFormat:@"%@=", paramName];
    }
    
    NSString *str = nil;
    NSRange start = [url rangeOfString:paramName];
    if (start.location != NSNotFound) {
        unichar c = '?';
        if (start.location != 0) {
            c = [url characterAtIndex:start.location - 1];
        }
        if (c == '?' || c == '&' || c == '#') {
            NSRange end = [[url substringFromIndex:start.location + start.length] rangeOfString:@"&"];
            NSUInteger offset = start.location + start.length;
            str = end.location == NSNotFound ? [url substringFromIndex:offset] : [url substringWithRange:NSMakeRange(offset, end.location)];
            str = [str stringByRemovingPercentEncoding];
        }
    }
    
    return str;
}

@end
