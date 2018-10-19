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
    [SVProgressHUD showImage:[UIImage imageWithGifData:gifData] status:status];
    [SVProgressHUD setDefaultMaskType:maskType];
    [SVProgressHUD setImageViewSize:CGSizeMake(60, 60)];
}

+ (void)thn_showInfoWithStatus:(NSString *)status {
    [SVProgressHUD showInfoWithStatus:status];
    [SVProgressHUD setImageViewSize:CGSizeMake(28, 28)];
}

+ (void)thn_showErrorWithStatus:(NSString *)status {
    [SVProgressHUD showErrorWithStatus:status];
    [SVProgressHUD setImageViewSize:CGSizeMake(28, 28)];
}

+ (void)thn_showSuccessWithStatus:(NSString *)status {
    [SVProgressHUD showSuccessWithStatus:status];
    [SVProgressHUD setImageViewSize:CGSizeMake(28, 28)];
}

@end
