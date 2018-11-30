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
NSString *const kDomainBaseUrl      = @"https://wxapi.lexivip.com/v1.0";
NSString *const kTestAppKey         = @"PmVOkj4Un6dfKCqQryMR";
NSString *const kTestAppSecret      = @"e238bf64d77e5be7284686aaacd0232e7248254a";

//  测试环境
//NSString *const kDomainBaseUrl      = @"https://wx.taihuoniao.com/v1.0";
//NSString *const kTestAppKey         = @"zXIPN0ftRj6dlrKFOZpH";
//NSString *const kTestAppSecret      = @"4d8ebaf52b76603a158b67f525a1b9e5f80677da";

#pragma mark - 小程序参数
NSString *const kWxaAuthAppId   = @"wx60ed17bfd850985d";
NSString *const kWxaHomePath    = @"pages/index/index";
NSString *const kWxaProductPath = @"pages/product/product";
NSString *const kWxaWindowPath  = @"pages/windowDetail/windowDetail";

#pragma mark - 分享H5前缀
// 文章
NSString *const kShareArticleUrlPrefix  = @"https://h5.lexivip.com/article/life?rid=";
// 种草清单
NSString *const kShareGrassUrlPrefix    = @"https://h5.lexivip.com/article/grass?rid=";
// 商品
NSString *const kShareProductUrlPrefix  = @"https://h5.lexivip.com/product_view?rid=";
// 个人主页
NSString *const kShareUserUrlPrefix     = @"https://h5.lexivip.com/user/home?uid=";

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
NSString *const kUid                = @"THNUid";

#pragma mark -
NSInteger const kAppDebug           = 1;
NSString *const KAppType            = @"1";
NSString *const kChannel            = @"appstore";

#pragma mark - 客户端版本
NSString *const kClientVersion      = @"1.0.0";
NSString *const kClientID           = @"appstore";
NSString *const kClientSecret       = @"appstore";
NSString *const kFontFamily         = @"PingFang";
// 版本对应的key
NSString *const kClientVersionKey   = @"clientVersion";

#pragma mark - App Store ID
NSString *const kAppStoreId         = @"com.taihuoniao.lexi";
NSString *const kAppName            = @"lexi";

#pragma mark - 第三方平台应用信息
// 友盟
NSString *const kUMAppKey           = @"5bc5c570b465f5c5b2000086";
// 微信
NSString *const kWXURLScheme        = @"wx456e2f0cb22db269";
NSString *const kWXAppKey           = @"wx456e2f0cb22db269";
NSString *const kWXAppSecret        = @"8eddb55d39cbfdb9fee1afa93a495db1";
// 支付宝
NSString *const kALiURLScheme       = @"alipay2018102761828848";
NSString *const kAlipayKey          = @"2018102761828848";
// 微博
NSString *const kWBURLScheme        = @"wb146542115";
NSString *const kWBAppKey           = @"146542115";
NSString *const kWBAppSecret        = @"3d2cff91e7e95529e97aa6a2320c940e";
// QQ
NSString *const kQQTencent          = @"tencent1106125719";
NSString *const kQQURLScheme        = @"QQ41ee2397";
NSString *const kQQAppId            = @"1106125719";
NSString *const kQQAppKey           = @"Vx7fjdJy7i1As15N";

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
NSString *const kCommentCount               = @"kCommentCount";

#pragma mark - NSNotification
NSString *const kOrderLogisticsTracking         = @"OrderLogisticsTracking";
NSString *const kOrderDetailLogisticsTracking   = @"kOrderDetailLogisticsTracking";
NSString *const kShelfSuccess                   = @"shelfSuccess";
NSString *const kUpdateLivingHallStatus         = @"kUpdateLivingHallStatus";
NSString *const kBrandHallReceiveCoupon         = @"kBrandHallReceiveCoupon";
NSString *const kLookAllCommentData             = @"kLookAllCommentData";
NSString *const THNPayMentVCPayCallback         = @"THNPayMentVCPayCallback";
NSString *const AppDelegateBackgroundRemotePush = @"AppDelegateBackgroundRemotePush";
NSString *const kChangeStatusWindowSuccess      = @"kChangeStatusWindowSuccess";
