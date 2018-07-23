//
//  THNConst.m
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - API 地址
//NSString *const kDomainBaseUrl    = @"";   //  生产环境
//NSString *const kDomainBaseUrl    = @"";   //  上线正式环境
NSString *const kDomainBaseUrl      = @"https://fx.taihuoniao.com/api/v1.0";   //  开发环境

#pragma mark - 测试账号
NSString *const kTestEmail          = @"demo@taihuoniao.com";
NSString *const kTestPassword       = @"in456321";

#pragma mark -
NSInteger const kAppDebug           = 1;
NSString *const KAppType            = @"1";
NSString *const kChannel            = @"appstore";

#pragma mark - 客户端版本
NSString *const kClientVersion      = @"1.0.0";
NSString *const kClientID           = @"appstore";
NSString *const kClientSecret       = @"appstore";
NSString *const kFontFamily         = @"PingFang";

#pragma mark - App Store ID
NSString *const kAppStoreId         = @"com.taihuoniao.lexi";
NSString *const kAppName            = @"lexi";

#pragma mark - Error Domain
NSString *const kDomain             = @"TaiHuoNiao";
NSInteger const kServerError        = 60001;
NSInteger const kParseError         = 60002;
NSInteger const kNetError           = 60003;

#pragma mark -
NSString *const kUserInfoPath       = @"THN__StoreUserInfo__";
NSString *const kLocalKeyUUID       = @"THN__UUID__";

#pragma mark - 边距、尺寸相关

#pragma mark - Size 大小相关
CGFloat const kFontSizeTabDefault   = 11;
CGFloat const kFontSizeTabSelected  = 11;

#pragma mark - 颜色相关
NSString *const kColorMain          = @"#5FE4B1";
NSString *const kColorWhite         = @"#FFFFFF";
NSString *const kColorBlack         = @"#000000";
NSString *const kColorTabDefault    = @"#666666";
NSString *const kColorTabSelected   = @"#6ed7af";
NSString *const kColorNavTitle      = @"#333333";