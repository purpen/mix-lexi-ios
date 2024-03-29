//
//  THNShopWindowModel.h
//  lexi
//
//  Created by HongpingRao on 2018/8/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>
#import <UIKit/UIKit.h>

/**
 用户身份

 - UserIdentityTypeIndependent: 独立设计师
 - UserIdentityTypeArtist: 艺术家
 - UserIdentityTypeHandMadePerson: 手作人
 - UserIdentityTypeOriginal: 原创设计达人
 - UserIdentityTypeMerchant: 原创商户经营
 */
typedef NS_ENUM(NSUInteger, UserIdentityType) {
    UserIdentityTypeIndependent = 1,
    UserIdentityTypeArtist,
    UserIdentityTypeHandMadePerson,
    UserIdentityTypeOriginal,
    UserIdentityTypeMerchant
};

@class THNProductModel;

@interface THNShopWindowModel : NSObject

@property (nonatomic, strong) NSArray *keywords;
//是否关注过该用户
@property (nonatomic, assign) BOOL is_follow;
//是否喜欢过该橱窗
@property (nonatomic, assign) BOOL is_like;
//橱窗喜欢数
@property (nonatomic, assign) NSInteger like_count;
// 评论数
@property (nonatomic, assign) NSInteger comment_count;
@property (nonatomic, strong) NSArray <THNProductModel *>*products;
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *user_avatar;
@property (nonatomic, assign) UserIdentityType user_identity;
@property (nonatomic, strong) NSString *title;
//橱窗详情
@property (nonatomic, strong) NSString *des;
//橱窗图片数组
@property (nonatomic, strong) NSArray *product_covers;
//橱窗编号
@property (nonatomic, strong) NSString *rid;
// 是否官方橱窗
@property (nonatomic, assign) BOOL is_official;
// 是否达人
@property (nonatomic, assign) BOOL is_expert;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, assign) BOOL isOpening;
@property (nonatomic, assign) CGFloat cellHeight;

@end
