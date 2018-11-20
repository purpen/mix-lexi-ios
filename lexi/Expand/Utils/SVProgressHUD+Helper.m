//
//  SVProgressHUD+GIFImage.m
//  lexi
//
//  Created by FLYang on 2018/10/18.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "SVProgressHUD+Helper.h"
#import "UIImage+GIF.h"

@implementation SVProgressHUD (Helper)

+ (void)thn_show {
    return [self thn_showWithStatus:nil];
}

+ (void)thn_showWithStatus:(NSString *)status {
    return [self thn_showWithStatus:status maskType:(SVProgressHUDMaskTypeNone)];
}

+ (void)thn_showWithStatus:(NSString *)status maskType:(SVProgressHUDMaskType)maskType {
    NSData *gifData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"loading" ofType:@".gif"]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showImage:[UIImage imageWithGifData:gifData] status:status];
        [SVProgressHUD setDefaultMaskType:maskType];
        [SVProgressHUD setImageViewSize:CGSizeMake(60, 60)];
    });
}

+ (void)thn_showInfoWithStatus:(NSString *)status {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD setImageViewSize:CGSizeMake(28, 28)];
        [SVProgressHUD showInfoWithStatus:status];
    });
}

+ (void)thn_showErrorWithStatus:(NSString *)status {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD setImageViewSize:CGSizeMake(28, 28)];
        [SVProgressHUD showErrorWithStatus:status];
    });
}

+ (void)thn_showSuccessWithStatus:(NSString *)status {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD setImageViewSize:CGSizeMake(28, 28)];
        [SVProgressHUD showSuccessWithStatus:status];
    });
}

@end
