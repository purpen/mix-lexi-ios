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
NSString *const kDomainBaseUrl      = @"https://wx.taihuoniao.com/v1.0";   //  开发环境

#pragma mark - 测试账号
NSString *const kAdminUrl           = @"https://lx.taihuoniao.com/#/";
NSString *const kAdminPhone         = @"13716171560";
NSString *const kAdminPWD           = @"123456";
//NSString *const kTestEmail          = @"18548918450";
/**
 小程序账号:
 17600351560
 
 小 B 账号：
 13260180689
 13260180689ljy
 */
NSString *const kTestEmail          = @"18518391827";
NSString *const kTestPassword       = @"in456321";
NSString *const kTestAppKey         = @"zXIPN0ftRj6dlrKFOZpH";
NSString *const kTestAppSecret      = @"4d8ebaf52b76603a158b67f525a1b9e5f80677da";

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
NSString *const kColorBackground    = @"#f7f9fb";

#pragma mark - 本地记录状态
NSString *const kIsCloseLivingHallView = @"kIsCloseLivingHallView";
NSString *const kLoginSuccess = @"kLoginSuccess";
NSString *const kSearchKeyword = @"kSearchKeyword";
NSString *const kBrandHallRid = @"kBrandHallRid"; // 进入他人品牌馆的ID
