//
//  THNResponse.m
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNResponse.h"
#import "NSDictionary+Helper.h"

NSString *const kResponseData           = @"data";
NSString *const kResponseStatus         = @"status";
NSString *const kResponseStatusCode     = @"code";
NSString *const kResponseStatusMessage  = @"message";
NSString *const kResponseSuccess        = @"success";

@implementation THNResponse

- (instancetype)initWithResponseObject:(id)responseObject {
    self = [super init];
    if (self) {
        self.responseDict = responseObject;
        
        if (![self.responseDict[kResponseData] isKindOfClass:[NSNull class]]) {
            self.data = self.responseDict[kResponseData];
        }
        
        if (![self.responseDict[kResponseStatus] isKindOfClass:[NSNull class]]) {
            self.status = self.responseDict[kResponseStatus];
        }
        
        if (![self.status[kResponseStatusCode] isKindOfClass:[NSNull class]]) {
            self.statusCode = [self.status[kResponseStatusCode] integerValue];
        }
        
        if (![self.status[kResponseStatusCode] isKindOfClass:[NSNull class]]) {
            self.statusMessage = self.status[kResponseStatusMessage];
        }
        
        if (![self.responseDict[kResponseSuccess] isKindOfClass:[NSNull class]]) {
            self.success = [self.responseDict[kResponseSuccess] integerValue];
        }
    }
    return self;
}

- (BOOL)isSuccess {
    if (self.success == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)hasData {
    if (!self.data) {
        return NO;
    }
    
    if ([self.data isKindOfClass:[NSNull class]]) {
        return NO;
    }
    
    if (!self.data.count) {
        return NO;
    }
    
    return YES;
}

@end
