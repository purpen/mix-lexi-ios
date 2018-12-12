//
//  THNPosterManager.m
//  lexi
//
//  Created by FLYang on 2018/12/5.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNPosterManager.h"
#import "SVProgressHUD+Helper.h"
#import "THNAPI.h"
#import "THNConst.h"
#import "THNLoginManager.h"

/// url
static NSString *const kURLWxaPoster   = @"/market/wxa_poster";
static NSString *const kURLShopWindow  = @"/market/share/shop_window_poster";
static NSString *const kURLInvite      = @"/market/share/invite_poster";
static NSString *const kURLBrand       = @"/market/share/store_poster";

/// key
static NSString *const kKeyRid       = @"rid";
// 平台类型 1=品牌馆, 2=生活馆, 3=独立小程序分享商品, 4=核心平台分享商品
static NSString *const kKeyType      = @"type";
// 场景参数： 商品编号-生活馆编号 例：8945120367-94395210
static NSString *const kKeyScene     = @"scene";
// 访问路径
static NSString *const kKeyPath      = @"path";
// 小程序id
static NSString *const kKeyAuthAppId = @"auth_app_id";

@interface THNPosterManager ()

@property (nonatomic, assign) THNSharePosterType posterType;
@property (nonatomic, strong) NSString *requestId;

@end

@implementation THNPosterManager

+ (void)getSharePosterImageDataWithType:(THNSharePosterType)type
                              requestId:(NSString *)requestId
                             completion:(void (^)(NSString *))completion {
    
    [THNPosterManager sharedManager].posterType = type;
    [THNPosterManager sharedManager].requestId = requestId;
    [[THNPosterManager sharedManager] thn_networkPosterImageDataCompletion:completion];
}

#pragma mark - network
- (void)thn_networkPosterImageDataCompletion:(void (^)(NSString *imageUrl))completion {
    THNRequest *request = [THNAPI postWithUrlString:[self thn_getRequestUrl]
                                  requestDictionary:[self thn_getRequestParams]
                                           delegate:nil];
    
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.isSuccess) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return ;
        }
        
        completion(result.data[@"image_url"]);
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
    }];
}

- (NSString *)thn_getRequestUrl {
    NSDictionary *urlDict = @{@(THNSharePosterTypeNone)      : kURLInvite,
                              @(THNSharePosterTypeGoods)     : kURLWxaPoster,
                              @(THNSharePosterTypeWindow)    : kURLShopWindow,
                              @(THNSharePosterTypeInvitation): kURLInvite,
                              @(THNSharePosterTypeLifeStore) : kURLWxaPoster,
                              @(THNSharePosterTypeBrandStore): kURLBrand,};
    
    return urlDict[@(self.posterType)];
}

- (NSDictionary *)thn_getRequestParams {
    if (self.requestId.length) {
        NSDictionary *defaultParam = @{kKeyAuthAppId: kWxaAuthAppId,
                                       kKeyScene    : [self thn_paramsScene],
                                       kKeyRid      : self.requestId};
        
        NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithDictionary:defaultParam];
        
        switch (self.posterType) {
            case THNSharePosterTypeGoods: {
                [paramDict setObject:@(4) forKey:kKeyType];
                [paramDict setObject:kWxaProductPath forKey:kKeyPath];
            }
                break;
                
            case THNSharePosterTypeWindow: {
                [paramDict setObject:kWxaWindowPath forKey:kKeyPath];
            }
                break;
            
            case THNSharePosterTypeNone:
            case THNSharePosterTypeInvitation: {
                [paramDict setObject:kWxaStoreGuidePath forKey:kKeyPath];
            }
                break;
                
            case THNSharePosterTypeLifeStore: {
                [paramDict setObject:@(2) forKey:kKeyType];
                [paramDict setObject:kWxaHomePath forKey:kKeyPath];
            }
                break;
                
            default:
                break;
        }
        
        return [paramDict copy];
    }
    
    return [NSDictionary dictionary];
}

/**
 场景编号
 */
- (NSString *)thn_paramsScene {
    if (self.posterType == THNSharePosterTypeGoods) {
        NSString *storeId = [THNLoginManager sharedManager].storeRid.length ? [THNLoginManager sharedManager].storeRid : @"";
        NSString *scene = [NSString stringWithFormat:@"%@-%@", self.requestId, storeId];
        
        return scene;
    }
    
    return self.requestId;
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
