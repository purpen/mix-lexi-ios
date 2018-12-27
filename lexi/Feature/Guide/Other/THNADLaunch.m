//
//  THNADLaunch.m
//  lexi
//
//  Created by HongpingRao on 2018/12/25.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//
#import "THNADLaunch.h"
#import "THNAPI.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+SDWedImage.h"
#import "THNSaveTool.h"
#import "THNGuideCollectionViewController.h"

static NSString *const kUrlAD = @"/market/guide/ios";
static NSString *const kAdImage = @"adImage";
static NSString *const kLastAdUrl = @"lastAdUrl";

@interface THNADLaunch ()

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, assign) NSInteger downCount;
@property (nonatomic, weak) UIButton *downCountButton;
@property (nonatomic, strong) UIImage *adImage;
@property (nonatomic, strong) NSString *adUrl;

@end

@implementation THNADLaunch
///在load 方法中，启动监听，可以做到无注入
+ (void)load {
    [self shareInstance];
}

+ (instancetype)shareInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        ///应用启动, 首次开屏广告
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification
                                                          object:nil
                                                           queue:nil
                                                      usingBlock:^(NSNotification * _Nonnull note) {
                                                          
                                                          ///要等DidFinished方法结束后才能初始化UIWindow，不然会检测是否有rootViewController
                                                          // 先展示缓存图片，再去检查后台Url是否变化
                                                          [self checkAD];
                                                          [self loadAdData];
                                                          
        }];
    }
    
    return self;
}

- (void)loadAdData {
    THNRequest *request = [THNAPI getWithUrlString:kUrlAD requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        
        self.adUrl = result.data[@"small"];
        
        // 相同跳过缓存
        if ([self.adUrl isEqualToString:[THNSaveTool objectForKey:kLastAdUrl]]) {
            return;
        }
        
        // 无广告图清空缓存
        if (self.adUrl.length == 0) {
            [[SDImageCache sharedImageCache]removeImageForKey:kAdImage withCompletion:nil];
        }
        
        // 缓存上次广告Url和图片
        [THNSaveTool setObject:self.adUrl forKey:kLastAdUrl];
        [[SDImageCache sharedImageCache] storeImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.adUrl]]] forKey:kAdImage completion:nil];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

- (void)checkAD {
    
    UIImage *cacheImage = [[SDImageCache sharedImageCache]imageFromCacheForKey:kAdImage];

    // 没有缓存图片或者显示引导图不显示开屏广告
    if (cacheImage == nil || [[UIApplication sharedApplication].delegate.window.rootViewController isKindOfClass:[THNGuideCollectionViewController class]]){
        return;
    }
    
    self.adImage = cacheImage;
    [self showAdWindow];
}

- (void)showAdWindow {
    
    ///初始化一个Window， 做到对业务视图无干扰。
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.rootViewController = [UIViewController new];
    window.rootViewController.view.backgroundColor = [UIColor clearColor];
    window.rootViewController.view.userInteractionEnabled = NO;
    ///广告布局
    [self setupSubviews:window];
    
    ///设置为最顶层，防止 AlertView 等弹窗的覆盖
    window.windowLevel = UIWindowLevelStatusBar + 1;
    
    ///默认为YES，当你设置为NO时，这个Window就会显示了
    window.hidden = NO;
    window.alpha = 1;
    
    ///防止释放，显示完后  要手动设置为 nil
    self.window = window;
}

// 点击跳转
//- (void)letGo {
//    ///不直接取KeyWindow 是因为当有AlertView 或者有键盘弹出时， 取到的KeyWindow是错误的。
//    UIViewController* rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
//    [[rootVC imy_navigationController] pushViewController:[IMYWebViewController new] animated:YES];
//
//    [self hide];
//}

- (void)goOut {
    [self hide];
}

- (void)hide {
    ///来个渐显动画
    [UIView animateWithDuration:1.0 animations:^{
        self.window.alpha = 0;
    } completion:^(BOOL finished) {
        [self.window.subviews.copy enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        self.window.hidden = YES;
        self.window = nil;
    }];
}

///初始化显示的视图
- (void)setupSubviews:(UIWindow*)window {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:window.bounds];
    imageView.image = self.adImage;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    imageView.userInteractionEnabled = YES;
    
//    ///给非UIControl的子类，增加点击事件
//    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(letGo)];
//    [imageView addGestureRecognizer:tap];
    
    [window addSubview:imageView];
    
    ///增加一个倒计时跳过按钮
    self.downCount = 2;

// 跳过按钮,业务暂时不需要
//    UIButton * goout = [[UIButton alloc] initWithFrame:CGRectMake(window.bounds.size.width - 100 - 20, 20, 100, 60)];
//    [goout setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
//    [goout addTarget:self action:@selector(goOut) forControlEvents:UIControlEventTouchUpInside];
//    [window addSubview:goout];
//
//    self.downCountButton = goout;
    [self timer];
}

- (void)timer {
    [self.downCountButton setTitle:[NSString stringWithFormat:@"跳过：%ld",(long)self.downCount] forState:UIControlStateNormal];
    if (self.downCount <= 0) {
        [self hide];
    } else {
        self.downCount --;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self timer];
        });
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
