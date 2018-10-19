//
//  SVProgressHUD+GIFImage.h
//  lexi
//
//  Created by FLYang on 2018/10/18.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>

@interface SVProgressHUD (Helper)

+ (void)thn_show;
+ (void)thn_showWithStatus:(NSString *)status;
+ (void)thn_showWithStatus:(NSString *)status maskType:(SVProgressHUDMaskType)maskType;

+ (void)thn_showInfoWithStatus:(NSString *)status;
+ (void)thn_showErrorWithStatus:(NSString *)status;
+ (void)thn_showSuccessWithStatus:(NSString *)status;

@end
