//
//  THNConst.m
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - API 地址
////  正式环境
//NSString *const kDomainBaseUrl      = @"https://wxapi.lexivip.com/v1.0";
//NSString *const kTestAppKey         = @"PmVOkj4Un6dfKCqQryMR";
//NSString *const kTestAppSecret      = @"e238bf64d77e5be7284686aaacd0232e7248254a";

//  开发环境
NSString *const kDomainBaseUrl      = @"https://wx.taihuoniao.com/v1.0";
NSString *const kTestAppKey         = @"zXIPN0ftRj6dlrKFOZpH";
NSString *const kTestAppSecret      = @"4d8ebaf52b76603a158b67f525a1b9e5f80677da";

#pragma mark - 测试账号
/**
 (正式环境)小B账号：
 18612963205
 in456321
 */
NSString *const kAdminUrl           = @"https://lx.taihuoniao.com/#/";
NSString *const kAdminPhone         = @"13716171560";
NSString *const kAdminPWD           = @"123456";
NSString *const kTestEmail          = @"18518391827";
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

#pragma mark - Third
// 友盟
NSString *const kUMAppleKey         = @"5bc5c570b465f5c5b2000086";
// 微信分享
NSString *const kWXShareAppKey      = @"wx777520ec6a61fff5";
NSString *const kWXShareAppSecret   = @"a049e19a6f464e7d53ad28b4dbc905e2";
// 微信支付
NSString *const kWXPayAppKey        = @"wx456e2f0cb22db269";
NSString *const kWXPayAppSecret     = @"8eddb55d39cbfdb9fee1afa93a495db1";
// 微博
NSString *const kWBAppKey           = @"146542115";
NSString *const kWBAppSecret        = @"3d2cff91e7e95529e97aa6a2320c940e";

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
NSString *const kIsCloseLivingHallView      = @"kIsCloseLivingHallView";
NSString *const kIsCloseOpenedPromptView    = @"kIsCloseOpenedPromptView";
NSString *const kSearchKeyword              = @"kSearchKeyword";
NSString *const kBrandHallRid               = @"kBrandHallRid"; // 进入他人品牌馆的ID

#pragma mark - NSNotification
NSString *const kOrderLogisticsTracking         = @"OrderLogisticsTracking";
NSString *const kOrderDetailLogisticsTracking   = @"kOrderDetailLogisticsTracking";
NSString *const kShelfSuccess                   = @"shelfSuccess";
NSString *const kUpdateLivingHallStatus         = @"kUpdateLivingHallStatus";
NSString *const kBrandHallReceiveCoupon         = @"kBrandHallReceiveCoupon";
