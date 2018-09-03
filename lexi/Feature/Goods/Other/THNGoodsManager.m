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
static NSString *const kURLProductsCountC   = @"/category/products/count"; // 分类商品数量
static NSString *const kURLProductsSku      = @"/products/skus";
static NSString *const kURLCategories       = @"/categories";
static NSString *const kURLChooseCenterCount = @"/fx_distribute/choose_center/count"; // 选品中心商品数量
static NSString *const kURLProductsByStoreCount = @"/core_platforms/products/by_store/count"; // 品牌馆商品数量
/// 接收数据参数
static NSString *const kKeyProducts         = @"products";
static NSString *const kKeyCategories       = @"categories";
static NSString *const kKeyId               = @"id";
static NSString *const kKeyRid              = @"rid";
static NSString *const kKeyPid              = @"pid";
static NSString *const kKeyCount            = @"count";

@implementation THNGoodsManager

#pragma mark - public methods
+ (void)getProductAllDetailWithId:(NSString *)goodsId completion:(void (^)(THNGoodsModel *, NSError *))completion {
    NSString *goodsInfoUrl = [NSString stringWithFormat:@"/products/%@/all_detail", goodsId];
    
    [[THNGoodsManager sharedManager] requestProductAllDetailWithUrl:goodsInfoUrl completion:completion];
}

+ (void)getProductSkusInfoWithId:(NSString *)goodsId params:(NSDictionary *)params completion:(void (^)(THNSkuModel *,NSError *))completion {
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithDictionary:params];
    [paramDict setObject:goodsId forKey:kKeyRid];
    
    [[THNGoodsManager sharedManager] requestProductSkusInfoWithParams:paramDict completion:completion];
}

+ (void)getUserCenterProductsWithType:(THNUserCenterGoodsType)type params:(NSDictionary *)params completion:(void (^)(NSArray *, NSInteger, NSError *))completion {
    NSArray *urlArr = @[kURLUserLikedGoods, kURLUserBrowses, kURLUserWishlist];
    NSString *requestUrl = urlArr[(NSInteger)type];
    
    [[THNGoodsManager sharedManager] requestUserCenterProductsWithUrl:requestUrl params:params completion:completion];
}

+ (void)getCategoryProductsWithParams:(NSDictionary *)params completion:(void (^)(NSArray *, NSInteger , NSError *))completion {
    [[THNGoodsManager sharedManager] requestCategoryProductsWithParams:params completion:completion];
}

+ (void)getCategoryDataWithPid:(NSInteger)pid completion:(void (^)(NSArray *, NSError *))completion {
    [[THNGoodsManager sharedManager] requestCategoryWithPid:pid completion:completion];
}

+ (void)getProductCountWithType:(THNGoodsListViewType)type params:(NSDictionary *)params completion:(void (^)( NSInteger, NSError *))completion {
    switch (type) {
        case THNGoodsListViewTypeCategory:
            [[THNGoodsManager sharedManager] requestProductsCountWithParams:params withUrl:kURLProductsCountC completion:completion];
            break;
        case THNGoodsListViewTypeProductCenter:
            [[THNGoodsManager sharedManager] requestProductsCountWithParams:params withUrl:kURLChooseCenterCount completion:completion];
            break;
        case THNGoodsListViewTypeBrandHall:
            [[THNGoodsManager sharedManager] requestProductsCountWithParams:params withUrl:kURLProductsByStoreCount completion:completion];
        default:
            break;
    }
}

#pragma mark - request
/**
 获取商品全部信息
 */
- (void)requestProductAllDetailWithUrl:(NSString *)url completion:(void (^)(THNGoodsModel *model, NSError *error))completion {
    THNRequest *request = [THNAPI getWithUrlString:url requestDictionary:@{} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (![result hasData] || !result.isSuccess) return;
//        THNLog(@"商品全部信息 === %@", [NSString jsonStringWithObject:result.responseDict]);
        THNGoodsModel *model = [[THNGoodsModel alloc] initWithDictionary:result.data];
        completion(model, nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        completion(nil, error);
    }];
}

- (void)requestProductSkusInfoWithParams:(NSDictionary *)params completion:(void (^)(THNSkuModel *model, NSError *error))completion {
    [SVProgressHUD show];
    THNRequest *request = [THNAPI getWithUrlString:kURLProductsSku requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (![result hasData] || !result.isSuccess) return;
        THNLog(@"商品 SKU 信息 === %@", [NSString jsonStringWithObject:result.responseDict]);
        THNSkuModel *model = [[THNSkuModel alloc] initWithDictionary:result.data];
        completion(model, nil);
        [SVProgressHUD dismiss];
    } failure:^(THNRequest *request, NSError *error) {
        completion(nil, error);
        [SVProgressHUD dismiss];
    }];
}

/**
 根据类型获取用户中心商品数据
 */
- (void)requestUserCenterProductsWithUrl:(NSString *)url
                                  params:(NSDictionary *)params
                              completion:(void (^)(NSArray *, NSInteger , NSError *))completion {
    
    THNRequest *request = [THNAPI getWithUrlString:url requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (![result hasData] || !result.isSuccess) return;
//        NSLog(@"个人中心商品数据 ==== %@", result.data);
        completion((NSArray *)result.data[kKeyProducts], [result.data[kKeyCount] integerValue], nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        completion(nil, 0, error);
    }];
}

/**
 获取分类商品
 */
- (void)requestCategoryProductsWithParams:(NSDictionary *)params completion:(void (^)(NSArray *, NSInteger , NSError *))completion {
    THNRequest *request = [THNAPI getWithUrlString:kURLProductsCategory requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (![result hasData] || !result.isSuccess) return;
//        THNLog(@"分类商品数据 ==== %@", result.data);
        completion((NSArray *)result.data[kKeyProducts], [result.data[kKeyCount] integerValue], nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        completion(nil, 0, error);
    }];
}

/**
 获取商品数量
 */
- (void)requestProductsCountWithParams:(NSDictionary *)params withUrl:(NSString *)requestUrl completion:(void (^)(NSInteger , NSError *))completion {
    THNRequest *request = [THNAPI getWithUrlString:requestUrl requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (![result hasData] || !result.isSuccess) return;
        completion([result.data[kKeyCount] integerValue], nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        completion(0, error);
    }];
}

/**
 获取分类
 */
- (void)requestCategoryWithPid:(NSInteger)pid completion:(void (^)(NSArray *, NSError *))completion {
    THNRequest *request = [THNAPI getWithUrlString:kURLCategories requestDictionary:@{kKeyPid: @(pid)} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (![result hasData] || !result.isSuccess) return;
//        THNLog(@"分类数据 ==== %@", result.data);
        completion((NSArray *)result.data[kKeyCategories], nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        completion(nil, error);
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
