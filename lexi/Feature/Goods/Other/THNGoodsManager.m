//
//  THNGoodsManager.m
//  lexi
//
//  Created by FLYang on 2018/8/27.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsManager.h"
#import "THNAPI.h"
#import "THNMarco.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "NSString+Helper.h"

/// api 拼接地址
static NSString *const kURLUserLikedGoods  = @"/userlike";
static NSString *const kURLUserBrowses     = @"/user_browses";
static NSString *const kURLUserWishlist    = @"/wishlist";
/// 接收数据参数
static NSString *const kKeyProducts     = @"products";

@implementation THNGoodsManager

+ (void)getProductsWithType:(THNProductsType)type params:(NSDictionary *)params completion:(void (^)(NSArray *, NSError *))completion {
    NSArray *urlArr = @[kURLUserLikedGoods, kURLUserBrowses, kURLUserWishlist];
    NSString *requestUrl = urlArr[(NSInteger)type];
    [[THNGoodsManager sharedManager] requestProductsWithUrl:requestUrl params:params completion:completion];
}

#pragma mark - request
/**
 根据类型获取商品数据
 
 @param url api 地址
 @param params 附加参数
 @param completion 完成回调
 */
- (void)requestProductsWithUrl:(NSString *)url params:(NSDictionary *)params completion:(void (^)(NSArray *, NSError *))completion {
    [SVProgressHUD show];
    THNRequest *request = [THNAPI getWithUrlString:url requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (![result hasData]) return;
        
//        NSLog(@"商品数据 ==== %@", result.data);
        completion((NSArray *)result.data[kKeyProducts], nil);
        [SVProgressHUD dismiss];
        
    } failure:^(THNRequest *request, NSError *error) {
        completion(nil, error);
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - shared
static id _instance = nil;

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_instance) {
            _instance = [[self alloc] init];
        }
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

@end
