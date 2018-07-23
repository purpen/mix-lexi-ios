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

#pragma mark - App Store ID
UIKIT_EXTERN NSString *const kAppStoreId;
UIKIT_EXTERN NSString *const kAppName;

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
