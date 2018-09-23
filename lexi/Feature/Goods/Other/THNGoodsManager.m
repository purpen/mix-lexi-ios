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
#import "THNUserModel.h"

#define kURLFreightTemplate(rid) [NSString stringWithFormat:@"/logistics/core_freight_template/%@", rid]

#pragma mark - api 拼接地址
#pragma mark 用户商品
static NSString *const kURLUserLikedGoods       = @"/userlike";
static NSString *const kURLUserBrowses          = @"/user_browses";
static NSString *const kURLUserWishlist         = @"/wishlist";
#pragma mark 分类商品
static NSString *const kURLCategories           = @"/categories";
static NSString *const kURLProductsCategory     = @"/category/products";
static NSString *const kURLSimilar              = @"/products/similar";
static NSString *const kURLLikeGoodsUser        = @"/product/userlike";
static NSString *const kURLProductsCountC       = @"/category/products/count";
static NSString *const kURLProductsSku          = @"/products/skus";
static NSString *const kURLChooseCenterCount    = @"/fx_distribute/choose_center/count";
static NSString *const kURLProductsByStoreCount = @"/core_platforms/products/by_store/count";
#pragma mark 店铺信息
static NSString *const kURLOfficialStore        = @"/official_store/info";
#pragma mark 商品下单/购物车
static NSString *const kURLCart                 = @"/cart";
static NSString *const kURLCartCount            = @"/cart/item_count";
static NSString *const kURLCartRemove           = @"/cart/remove";

#pragma mark - 接收数据参数
static NSString *const kKeyProducts         = @"products";
static NSString *const kKeyCategories       = @"categories";
static NSString *const kKeyUserRecord       = @"user_record";
static NSString *const kKeyId               = @"id";
static NSString *const kKeyRid              = @"rid";
static NSString *const kKeyRids             = @"rids";
static NSString *const kKeyPid              = @"pid";
static NSString *const kKeyProductId        = @"product_rid";
static NSString *const kKeyStoreId          = @"store_rid";
static NSString *const kKeyCount            = @"count";
static NSString *const kKeyLikeUsers        = @"product_like_users";
static NSString *const kKeyItems            = @"items";
static NSString *const kKeyItemCount        = @"item_count";
static NSString *const kKeyQuantity         = @"quantity";

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

+ (void)getSimilarGoodsWithGoodsId:(NSString *)goodsId completion:(void (^)(NSArray *, NSError *))completion {
    [[THNGoodsManager sharedManager] requestSimilarGoodsWithParams:@{kKeyRid: goodsId} completion:completion];
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

+ (void)getOfficialStoreInfoWithId:(NSString *)storeId completion:(void (^)(THNStoreModel *, NSError *))completion {
    [[THNGoodsManager sharedManager] requestOfficialStoreInfoWithParams:@{kKeyRid: storeId} completion:completion];
}

+ (void)getFreightTemplateDataWithRid:(NSString *)rid goodsId:(NSString *)goodsId storeId:(NSString *)storeId completion:(void (^)(THNFreightModel *, NSError *))completion {;
    NSDictionary *param = @{kKeyRid: rid,
                            kKeyProductId: goodsId,
                            kKeyStoreId: storeId};
    
    [[THNGoodsManager sharedManager] requestFreightTemplateDataWithUrl:kURLFreightTemplate(rid) params:param completion:completion];
}

+ (void)getLikeGoodsUserDataWithGoodsId:(NSString *)goodsId params:(NSDictionary *)params completion:(void (^)(NSArray *, NSError *))completion {
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithDictionary:params];
    [paramDict setObject:goodsId forKey:kKeyRid];
    
    [[THNGoodsManager sharedManager] requestLikeGoodsUserDataWithParams:paramDict completion:completion];
}

+ (void)getProductCountWithType:(THNGoodsListViewType)type params:(NSDictionary *)params completion:(void (^)( NSInteger, NSError *))completion {
    switch (type) {
        case THNGoodsListViewTypeCategory:
            [[THNGoodsManager sharedManager] requestProductsCountWithParams:params withUrl:kURLProductsCountC completion:completion];
            break;
        case THNGoodsListViewTypeProductCenter:
            [[THNGoodsManager sharedManager] requestProductsCountWithParams:params withUrl:kURLChooseCenterCount completion:completion];
            break;
        case THNGoodsListViewTypeStore:
            [[THNGoodsManager sharedManager] requestProductsCountWithParams:params withUrl:kURLProductsByStoreCount completion:completion];
        default:
            break;
    }
}

+ (void)postAddGoodsToCartWithSkuParams:(NSDictionary *)params completion:(void (^)(NSError *))completion {
    [[THNGoodsManager sharedManager] requestAddGoodsToCartWithParams:params completion:completion];
}

+ (void)getCartGoodsCompletion:(void (^)(NSArray *, NSError *))completion {
    [[THNGoodsManager sharedManager] requestCartGoodsCompletion:completion];
}

+ (void)getCartGoodsCountCompletion:(void (^)(NSInteger, NSError *))completion {
    [[THNGoodsManager sharedManager] requestCartGoodsCountCompletion:completion];
}

+ (void)postRemoveCartGoodsWithSkuRids:(NSArray *)skuRids completion:(void (^)(NSError *))completion {
    [[THNGoodsManager sharedManager] requestRemoveCartGoodsWithParams:@{kKeyRids: skuRids} completion:completion];
}

+ (void)postAddGoodsToWishListWithRids:(NSArray *)rids completion:(void (^)(NSError *))completion {
    [[THNGoodsManager sharedManager] requestAddGoodsToWishListWithParams:@{kKeyRids: rids} completion:completion];
}

+ (void)putCartGoodsCountWithSkuId:(NSString *)skuId count:(NSInteger)count completion:(void (^)(NSError *))completion {
    NSDictionary *param = @{kKeyRid: skuId,
                            kKeyQuantity: @(count)};
    
    [[THNGoodsManager sharedManager] requestUpdateCartGoodsCountWithParams:param completion:completion];
}

#pragma mark - request
/**
 获取商品全部信息
 */
- (void)requestProductAllDetailWithUrl:(NSString *)url completion:(void (^)(THNGoodsModel *model, NSError *error))completion {
    THNRequest *request = [THNAPI getWithUrlString:url requestDictionary:@{kKeyUserRecord: @(1)} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (![result hasData] || !result.isSuccess) return;
        THNLog(@"\n === 商品全部信息 === \n%@\n", [NSString jsonStringWithObject:result.responseDict]);
//        THNLog(@"\n === 商品详情信息 === \n%@\n", [NSString jsonStringWithObject:result.data[@"deal_content"]]);
        THNGoodsModel *model = [[THNGoodsModel alloc] initWithDictionary:result.data];
        completion(model, nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        completion(nil, error);
    }];
}

/**
 获取商品的 SKU 信息
 */
- (void)requestProductSkusInfoWithParams:(NSDictionary *)params completion:(void (^)(THNSkuModel *model, NSError *error))completion {
    THNRequest *request = [THNAPI getWithUrlString:kURLProductsSku requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (![result hasData] || !result.isSuccess) return;
        THNLog(@"\n === SKU 信息 === \n%@\n", [NSString jsonStringWithObject:result.responseDict]);
        THNSkuModel *model = [[THNSkuModel alloc] initWithDictionary:result.data];
        completion(model, nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        completion(nil, error);
    }];
}

/**
 获取相似的商品
 */
- (void)requestSimilarGoodsWithParams:(NSDictionary *)params completion:(void (^)(NSArray *, NSError *))completion {
    THNRequest *request = [THNAPI getWithUrlString:kURLSimilar requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (![result hasData] || !result.isSuccess) return;
        NSMutableArray *goodsModelArr = [NSMutableArray array];
        for (NSDictionary *dict in result.data[kKeyProducts]) {
            THNGoodsModel *model = [[THNGoodsModel alloc] initWithDictionary:dict];
            [goodsModelArr addObject:model];
        }
        completion([goodsModelArr copy], nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        completion(nil, error);
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
//        THNLog(@"\n === 个人中心商品 信息 === \n%@\n", [NSString jsonStringWithObject:result.responseDict]);
        if (![result hasData] || !result.isSuccess) return;
        NSMutableArray *goodsModelArr = [NSMutableArray array];
        for (NSDictionary *dict in result.data[kKeyProducts]) {
            THNGoodsModel *model = [[THNGoodsModel alloc] initWithDictionary:dict];
            [goodsModelArr addObject:model];
        }
        completion([goodsModelArr copy], [result.data[kKeyCount] integerValue], nil);
        
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
 获取店铺信息
 */
- (void)requestOfficialStoreInfoWithParams:(NSDictionary *)params completion:(void (^)(THNStoreModel *model, NSError *error))completion {
    THNRequest *request = [THNAPI getWithUrlString:kURLOfficialStore requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (![result hasData] || !result.isSuccess) return;
        THNStoreModel *model = [[THNStoreModel alloc] initWithDictionary:result.data];
        completion(model, nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        completion(nil, error);
    }];
}

/**
 获取分类
 */
- (void)requestCategoryWithPid:(NSInteger)pid completion:(void (^)(NSArray *, NSError *))completion {
    THNRequest *request = [THNAPI getWithUrlString:kURLCategories requestDictionary:@{kKeyPid: @(pid)} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (![result hasData] || !result.isSuccess) return;
        completion((NSArray *)result.data[kKeyCategories], nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        completion(nil, error);
    }];
}

/**
 获取运费模版

 @param url api 地址
 @param params 附加参数
 @param completion 完成回调
 */
- (void)requestFreightTemplateDataWithUrl:(NSString *)url params:(NSDictionary *)params completion:(void (^)(THNFreightModel *model, NSError *error))completion {
    THNRequest *request = [THNAPI getWithUrlString:url requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (![result hasData] || !result.isSuccess) return;
        THNFreightModel *model = [[THNFreightModel alloc] initWithDictionary:result.data];
        completion(model, nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        completion(nil, error);
    }];
}

/**
 喜欢商品的用户列表
 */
- (void)requestLikeGoodsUserDataWithParams:(NSDictionary *)params completion:(void (^)(NSArray *userData, NSError *error))completion {
    THNRequest *request = [THNAPI getWithUrlString:kURLLikeGoodsUser requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (![result hasData] || !result.isSuccess) return;
        NSMutableArray *userModelArr = [NSMutableArray array];
        for (NSDictionary *dict in result.data[kKeyLikeUsers]) {
            THNUserModel *model = [THNUserModel mj_objectWithKeyValues:dict];
            [userModelArr addObject:model];
        }
        completion([userModelArr copy], nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        completion(nil, error);
    }];
}

/**
 商品添加到心愿单
 */
- (void)requestAddGoodsToWishListWithParams:(NSDictionary *)params completion:(void (^)(NSError *error))completion {
    THNRequest *request = [THNAPI postWithUrlString:kURLUserWishlist requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (result.isSuccess) {
            completion(nil);
        }
        
    } failure:^(THNRequest *request, NSError *error) {
        completion(error);
    }];
}


/**
 商品添加到购物车
 */
- (void)requestAddGoodsToCartWithParams:(NSDictionary *)params completion:(void (^)(NSError *error))completion {
    THNRequest *request = [THNAPI postWithUrlString:kURLCart requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (result.isSuccess) {
            completion(nil);
        }
        
    } failure:^(THNRequest *request, NSError *error) {
        completion(error);
    }];
}

/**
 获取购物车商品
 */
- (void)requestCartGoodsCompletion:(void (^)(NSArray *cartData, NSError *error))completion {
    THNRequest *request = [THNAPI getWithUrlString:kURLCart requestDictionary:@{} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        THNLog(@"=========  购物车的商品 = \n%@", [NSString jsonStringWithObject:result.responseDict]);
        
        if (![result hasData] || !result.isSuccess) return;
        NSMutableArray *cartModelArr = [NSMutableArray array];
        for (NSDictionary *dict in result.data[kKeyItems]) {
            THNCartModelItem *model = [[THNCartModelItem alloc] initWithDictionary:dict];
            [cartModelArr addObject:model];
        }
        completion([cartModelArr copy], nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        completion(nil, error);
    }];
}

/**
 获取购物车商品数量
 */
- (void)requestCartGoodsCountCompletion:(void (^)(NSInteger goodsCount, NSError *error))completion {
    THNRequest *request = [THNAPI getWithUrlString:kURLCartCount requestDictionary:@{} delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (![result hasData] || !result.isSuccess) return;
        NSInteger count = [result.data[kKeyItemCount] integerValue];
        
        completion(count, nil);
        
    } failure:^(THNRequest *request, NSError *error) {
        completion(0, error);
    }];
}

/**
 删除购物车商品
 */
- (void)requestRemoveCartGoodsWithParams:(NSDictionary *)params completion:(void (^)(NSError *error))completion {
    THNRequest *request = [THNAPI postWithUrlString:kURLCartRemove requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (result.isSuccess) {
            completion(nil);
        }
        
    } failure:^(THNRequest *request, NSError *error) {
        completion(error);
    }];
}

/**
 更新购物车商品数量
 */
- (void)requestUpdateCartGoodsCountWithParams:(NSDictionary *)params completion:(void (^)(NSError *error))completion {
    THNRequest *request = [THNAPI putWithUrlString:kURLCart requestDictionary:params delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (result.isSuccess) {
            if (completion) {
                completion(nil);
            }
        }
        
    } failure:^(THNRequest *request, NSError *error) {
        if (completion) {
            completion(error);
        }
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
