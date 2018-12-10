//
//  THNShareWxaViewController.m
//  lexi
//
//  Created by FLYang on 2018/11/29.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNShareWxaViewController.h"
#import "THNLoginManager.h"

/// url
static NSString *const kURLWxaPoster    = @"/market/wxa_poster";
static NSString *const kURLWxaGoods     = @"/market/share/product_card";
static NSString *const kURLWxaLifeStore = @"/market/share/life_store";
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
// 图片url
static NSString *const kKeyImageUrl  = @"image_url";

@interface THNShareWxaViewController () <THNShareWxaViewDelegate>

@property (nonatomic, strong) THNShareWxaView *shareView;
@property (nonatomic, assign) THNShareWxaViewType shareViewType;
@property (nonatomic, strong) NSString *requestId;

@end

@implementation THNShareWxaViewController

- (instancetype)initWithType:(THNShareWxaViewType)type requestId:(NSString *)requestId {
    self = [super init];
    if (self) {
        self.shareViewType = type;
        self.requestId = requestId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self thn_networkPosterImageData];
    [self thn_networkWxaCardImageData];
}

#pragma mark - custom delegate
- (void)thn_cancelShare {
    [self thn_showAnimation:NO];
}

- (void)thn_reviewSharePosterImage:(UIImage *)image {
//    [SVProgressHUD thn_showInfoWithStatus:@"预览图片"];
}

- (void)thn_shareToWechat {
    [SVProgressHUD thn_showInfoWithStatus:@"分享到微信"];
}

- (void)thn_savePosterImage:(UIImage *)image {
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [SVProgressHUD thn_showErrorWithStatus:@"保存失败"];
        
    } else {
        [SVProgressHUD thn_showSuccessWithStatus:@"已保存到相册"];
    }
}

#pragma mark - network
// 海报
- (void)thn_networkPosterImageData {
    WEAKSELF;

    THNRequest *request = [THNAPI postWithUrlString:kURLWxaPoster
                                  requestDictionary:[self thn_getRequestParams]
                                           delegate:nil];
    
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.isSuccess) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return ;
        }
        
        [weakSelf.shareView thn_setSharePosterImageUrl:result.data[kKeyImageUrl]];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
    }];
}

// 卡片海报
- (void)thn_networkWxaCardImageData {
    WEAKSELF;
    
    THNRequest *request = [THNAPI postWithUrlString:[self thn_requestUrl]
                                  requestDictionary:@{kKeyRid: self.requestId}
                                           delegate:nil];
    
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        if (!result.isSuccess) {
            [SVProgressHUD thn_showInfoWithStatus:result.statusMessage];
            return ;
        }
        
        [weakSelf.shareView thn_setShareCardImageUrl:result.data[kKeyImageUrl]];
        
    } failure:^(THNRequest *request, NSError *error) {
        [SVProgressHUD thn_showErrorWithStatus:[error localizedDescription]];
    }];
}

- (NSDictionary *)thn_getRequestParams {
    if (self.requestId.length) {
        NSDictionary *defaultParam = @{kKeyAuthAppId: kWxaAuthAppId,
                                       kKeyScene: [self thn_paramsScene],
                                       kKeyRid: self.requestId};
        
        NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithDictionary:defaultParam];
        
        switch (self.shareViewType) {
            case THNShareWxaViewTypeSellGoods: {
                [paramDict setObject:@(4) forKey:kKeyType];
                [paramDict setObject:kWxaProductPath forKey:kKeyPath];
            }
                break;
                
            case THNShareWxaViewTypeLifeStore: {
                [paramDict setObject:@(2) forKey:kKeyType];
                [paramDict setObject:kWxaHomePath forKey:kKeyPath];
            }
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
    if (self.shareViewType == THNShareWxaViewTypeSellGoods) {
        NSString *storeId = [THNLoginManager sharedManager].storeRid.length ? [THNLoginManager sharedManager].storeRid : @"";
        NSString *scene = [NSString stringWithFormat:@"%@-%@", self.requestId, storeId];
        
        return scene;
    }
    
    return self.requestId;
}

/**
 分享卡片的 url
 */
- (NSString *)thn_requestUrl {
    if (self.shareViewType == THNShareWxaViewTypeLifeStore) {
        return kURLWxaLifeStore;
    }
    
    return kURLWxaGoods;
}

#pragma mark - public methods
- (void)setSellMoney:(CGFloat)sellMoney {
    [self.shareView thn_setSellGoodsMoeny:sellMoney];
}

#pragma mark - setup UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.4];
    
    [self.view addSubview:self.shareView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self thn_showAnimation:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationBarView.hidden = YES;
}

- (void)thn_showAnimation:(BOOL)show {
    CGFloat frameH = [self shareViewHeigth];
    CGFloat originY = show ? SCREEN_HEIGHT - frameH : SCREEN_HEIGHT;
    CGFloat alpha = show ? 0.4 : 0;
    
    [UIView animateWithDuration:0.4
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.8
                        options:(UIViewAnimationOptionTransitionCrossDissolve)
                     animations:^{
                         self.shareView.frame = CGRectMake(0, originY, SCREEN_WIDTH, frameH);
                         self.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:alpha];
                         
                     } completion:^(BOOL finished) {
                         if (!show) {
                             [self dismissViewControllerAnimated:NO completion:nil];
                         }
                     }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    if (touch.view != self.shareView) {
        [self thn_showAnimation:NO];
    }
}

#pragma mark - getters and setters
- (CGFloat)shareViewHeigth {
    CGFloat containerH = (SCREEN_WIDTH - 30) / 2;
    CGFloat otherH = self.shareViewType == THNShareWxaViewTypeLifeStore ? 145 : 215;
    CGFloat bottomH = kDeviceiPhoneX ? 72 : 40;
    CGFloat viewH = containerH + otherH + bottomH;
    
    return viewH;
}

- (THNShareWxaView *)shareView {
    if (!_shareView) {
        _shareView = [[THNShareWxaView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, [self shareViewHeigth])
                                                       type:self.shareViewType];
        _shareView.delegate = self;
    }
    return _shareView;
}

@end
