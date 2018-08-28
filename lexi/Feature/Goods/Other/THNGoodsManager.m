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
static NSString *const kURLUserLikedGoods   = @"/userlike";
static NSString *const kURLUserBrowses      = @"/user_browses";
static NSString *const kURLUserWishlist     = @"/wishlist";
static NSString *const kURLProductsCategory = @"/category/products";
static NSString *const kURLCategories       = @"/categories";
/// 接收数据参数
static NSString *const kKeyProducts        = @"products";
static NSString *const kKeyCategories      = @"categories";
static NSString *const kKeyId              = @"id";
static NSString *const kKeyPid             = @"pid";
static NSString *const kKeyCount           = @"count";

@implementation THNGoodsManager

#pragma mark - public methods
+ (void)getUserCenterProductsWithType:(THNProductsType)type params:(NSDictionary *)params completion:(void (^)(NSArray *, NSError *))completion {
    NSArray *urlArr = @[kURLUserLikedGoods, kURLUserBrowses, kURLUserWishlist];
    NSString *requestUrl = urlArr[(NSInteger)type];
    
    [[THNGoodsManager sharedManager] requestUserCenterProductsWithUrl:requestUrl params:params completion:completion];
}

+ (void)getCategoryProductsWithId:(NSInteger)categoryId params:(NSDictionary *)params completion:(void (^)(NSArray *, NSInteger, NSError *))completion {
    NSMutableDictionary *requestParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [requestParams setObject:@(categoryId) forKey:kKeyId];
    
    [[THNGoodsManager sharedManager] requestCategoryProductsWithParams:requestParams completion:completion];
}

+ (void)getCategoryDataWithPid:(NSInteger)pid completion:(void (^)(NSArray *, NSError *))completion {
    [[THNGoodsManager sharedManager] requestCategoryWithPid:pid completion:completion];
}

+ (void)getScreenProductsWithParams:(NSDictionary *)params completion:(void (^)(NSDictionary *, NSError *))completion {
    [[THNGoodsManager sharedManager] requestScreenProductsWithParams:params completion:completion];
}

#pragma mark - request
/**
 根据类型获取用户中心商品数据
 */
- (void)requestUserCenterProductsWithUrl:(NSString *)url params:(NSDictionary *)params completion:(void (^)(NSArray *, NSError *))completion {
    [SVProgressHUD show];
    THNRequest *request = [THNAPI getWithUrlString:url requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (![result hasData]) return;
        NSLog(@"个人中心商品数据 ==== %@", result.data);
        completion((NSArray *)result.data[kKeyProducts], nil);
        [SVProgressHUD dismiss];
        
    } failure:^(THNRequest *request, NSError *error) {
        completion(nil, error);
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

/**
 获取分类商品
 */
- (void)requestCategoryProductsWithParams:(NSDictionary *)params completion:(void (^)(NSArray *, NSInteger, NSError *))completion {
    [SVProgressHUD show];
    THNRequest *request = [THNAPI getWithUrlString:kURLProductsCategory requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (![result hasData]) return;
        THNLog(@"分类商品数据 ==== %@", result.data);
        
        completion((NSArray *)result.data[kKeyProducts], [result.data[kKeyCount] integerValue], nil);
        [SVProgressHUD dismiss];
        
    } failure:^(THNRequest *request, NSError *error) {
        completion(nil, nil, error);
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

- (void)requestScreenProductsWithParams:(NSDictionary *)params completion:(void (^)(NSDictionary *, NSError *))completion {
    THNRequest *request = [THNAPI getWithUrlString:kURLProductsCategory requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        THNLog(@"筛选出的商品数据 ==== %@", result.data);
        completion(result.data, nil);
        [SVProgressHUD dismiss];
        
    } failure:^(THNRequest *request, NSError *error) {
        completion(nil, error);
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

/**
 获取分类
 */
- (void)requestCategoryWithPid:(NSInteger)pid completion:(void (^)(NSArray *, NSError *))completion {
    [SVProgressHUD show];

    THNRequest *request = [THNAPI getWithUrlString:kURLCategories requestDictionary:@{kKeyPid: @(pid)} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (![result hasData]) return;
        THNLog(@"分类数据 ==== %@", result.data);
        completion((NSArray *)result.data[kKeyCategories], nil);
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
