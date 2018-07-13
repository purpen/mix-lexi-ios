//
//  NSString+Encryption.h
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Encryption)

/**
 MD5
 */
+ (NSString *)md5StringFromString:(NSString *)string;
- (NSString *)THNMD5Hash8;
- (NSString *)THNMD5Hash32;

/**
 Base64
 */
+ (NSString *)base64StringFromString:(NSString *)string;

/**
 SHA1
 */
+ (NSString *)sha1StringFromString:(NSString *)string;

@end
