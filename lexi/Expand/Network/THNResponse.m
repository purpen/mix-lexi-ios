//
//  THNResponse.m
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNResponse.h"

@implementation THNResponse

- (void)setError:(NSError *)error {
    _error = error;
    self.statusCode = error.code;
    self.errorMessage = error.localizedDescription;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\n statusCode: %zi \n error: %@ \n headers: %@ \n response: %@", \
            self.statusCode, self.error, self.headers, self.responseObject];
}

@end
