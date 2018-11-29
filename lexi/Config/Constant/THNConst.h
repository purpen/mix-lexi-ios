//
//  THNConst.h
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - API 服务器地址
UIKIT_EXTERN NSString *const kDomainBaseUrl;

#pragma mark - 测试账号
UIKIT_EXTERN NSString *const kTestEmail;
UIKIT_EXTERN NSString *const kTestPassword;
UIKIT_EXTERN NSString *const kTestAppKey;
UIKIT_EXTERN NSString *const kTestAppSecret;

#pragma mark - 小程序参数
UIKIT_EXTERN NSString *const kWxaAuthAppId;
UIKIT_EXTERN NSString *const kWxaHomePath;
UIKIT_EXTERN NSString *const kWxaProductPath;
UIKIT_EXTERN NSString *const kWxaWindowPath;

#pragma mark - 分享H5前缀
// 文章
UIKIT_EXTERN NSString *const kShareArticleUrlPrefix;
// 种草清单
UIKIT_EXTERN NSString *const kShareGrassUrlPrefix;
// 商品
UIKIT_EXTERN NSString *const kShareProductUrlPrefix;
// 个人主页
UIKIT_EXTERN NSString *const kShareUserUrlPrefix;

#pragma mark - App 公共参数
UIKIT_EXTERN NSInteger const kAppDebug;
UIKIT_EXTERN NSString *const KAppType;
UIKIT_EXTERN NSString *const kChannel;
UIKIT_EXTERN NSString *const kUserInfoPath;
UIKIT_EXTERN NSString *const kLocalKeyUUID;

#pragma mark - 客户端版本
UIKIT_EXTERN NSString *const kClientVersion;
UIKIT_EXTERN NSString *const kClientID;
UIKIT_EXTERN NSString *const kClientSecret;
UIKIT_EXTERN NSString *const kFontFamily;
UIKIT_EXTERN NSString *const kClientVersionKey;

#pragma mark - App Store ID
UIKIT_EXTERN NSString *const kAppStoreId;
UIKIT_EXTERN NSString *const kAppName;

#pragma mark - 第三方平台应用信息
#pragma mark UM
UIKIT_EXTERN NSString *const kUMAppKey;
#pragma mark WX
UIKIT_EXTERN NSString *const kWXURLScheme;
UIKIT_EXTERN NSString *const kWXAppKey;
UIKIT_EXTERN NSString *const kWXAppSecret;
#pragma mark Alipay
UIKIT_EXTERN NSString *const kALiURLScheme;
UIKIT_EXTERN NSString *const kAlipayKey;
#pragma mark WB
UIKIT_EXTERN NSString *const kWBURLScheme;
UIKIT_EXTERN NSString *const kWBAppKey;
UIKIT_EXTERN NSString *const kWBAppSecret;
#pragma mark QQ
UIKIT_EXTERN NSString *const kQQURLScheme;
UIKIT_EXTERN NSString *const kQQAppId;
UIKIT_EXTERN NSString *const kQQAppKey;

#pragma mark - Error Domain
UIKIT_EXTERN NSString *const kDomain;
UIKIT_EXTERN NSInteger const kServerError;
UIKIT_EXTERN NSInteger const kParseError;
UIKIT_EXTERN NSInteger const kNetError;

#pragma mark - 边距、尺寸相关

#pragma mark - Size 大小相关
UIKIT_EXTERN CGFloat const kFontSizeTabDefault;
UIKIT_EXTERN CGFloat const kFontSizeTabSelected;

#pragma mark - 颜色相关
UIKIT_EXTERN NSString *const kColorMain;
UIKIT_EXTERN NSString *const kColorWhite;
UIKIT_EXTERN NSString *const kColorBlack;
UIKIT_EXTERN NSString *const kColorTabDefault;
UIKIT_EXTERN NSString *const kColorTabSelected;
UIKIT_EXTERN NSString *const kColorNavTitle;
UIKIT_EXTERN NSString *const kColorBackground;

#pragma mark - 本地记录状态
UIKIT_EXTERN NSString *const kIsCloseLivingHallView;
UIKIT_EXTERN NSString *const kBrandHallRid;
UIKIT_EXTERN NSString *const kSearchKeyword;
UIKIT_EXTERN NSString *const kCommentCount;

#pragma mark - NSNotification
UIKIT_EXTERN NSString *const kOrderLogisticsTracking;
UIKIT_EXTERN NSString *const kOrderDetailLogisticsTracking;
UIKIT_EXTERN NSString *const kIsCloseOpenedPromptView;
UIKIT_EXTERN NSString *const kShelfSuccess;
UIKIT_EXTERN NSString *const kUpdateLivingHallStatus;
UIKIT_EXTERN NSString *const kBrandHallReceiveCoupon;
UIKIT_EXTERN NSString *const kLookAllCommentData;
UIKIT_EXTERN NSString *const THNPayMentVCPayCallback;
UIKIT_EXTERN NSString *const AppDelegateBackgroundRemotePush;
UIKIT_EXTERN NSString *const kChangeStatusWindowSuccess;
