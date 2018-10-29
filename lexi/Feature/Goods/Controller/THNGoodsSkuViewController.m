//
//  THNGoodsSkuViewController.m
//  lexi
//
//  Created by FLYang on 2018/9/7.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsSkuViewController.h"
#import "THNGoodsFunctionView.h"
#import "UIView+Helper.h"
#import "THNSelectAddressViewController.h"
#import "THNBaseNavigationController.h"
#import "THNSignInViewController.h"
#import "THNLoginManager.h"
#import "THNGoodsManager.h"

static NSString *const kTitleSure   = @"确定";
static NSString *const kTextNone    = @"已下架";
/// 自定义的 key
static NSString *const kKeyItems    = @"items";
static NSString *const kKeyRid      = @"rid";
static NSString *const kKeySkuItems = @"sku_items";
static NSString *const kKeySkuId    = @"sku";
static NSString *const kKeyQuantity = @"quantity";

@interface THNGoodsSkuViewController () <THNGoodsFunctionViewDelegate>

/// SKU 数据
@property (nonatomic, strong) THNSkuModel *skuModel;
/// 商品数据
@property (nonatomic, strong) THNGoodsModel *goodsModel;
/// 底部功能视图
@property (nonatomic, strong) THNGoodsFunctionView *functionView;
/// 视图类型
@property (nonatomic, assign) THNGoodsSkuType viewType;
/// 确认按钮
@property (nonatomic, strong) UIButton *sureButton;
/// 背景遮罩
@property (nonatomic, strong) UIView *maskView;
///
@property (nonatomic, strong) UIView *mainView;

@end

@implementation THNGoodsSkuViewController

- (instancetype)initWithGoodsModel:(THNGoodsModel *)goodsModel {
    self = [super init];
    if (self) {
        self.goodsModel = goodsModel;
        [self thn_getGoodsSkuDataWithGoodsId:goodsModel.rid];
        [self thn_setSureButtonTypeWithStatus:goodsModel.status];
        self.viewType = THNGoodsSkuTypeDefault;
    }
    return self;
}

- (instancetype)initWithSkuModel:(THNSkuModel *)model goodsModel:(THNGoodsModel *)goodsModel viewType:(THNGoodsSkuType)viewTpye {
    self = [super init];
    if (self) {
        self.skuModel = model;
        self.goodsModel = goodsModel;
        [self thn_setSureButtonTypeWithStatus:goodsModel.status];
        self.viewType = viewTpye;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationBarView.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.4];
}

#pragma mark - network
/**
 获取商品 SKU 数据
 */
- (void)thn_getGoodsSkuDataWithGoodsId:(NSString *)goodsId {
    [SVProgressHUD thn_show];
    
    WEAKSELF;
    
    [THNGoodsManager getProductSkusInfoWithId:goodsId
                                       params:@{}
                                   completion:^(THNSkuModel *model, NSError *error) {
                                       if (error) return;
        
                                       weakSelf.skuModel = model;
                                       weakSelf.skuView.skuModel = model;
                                       [SVProgressHUD dismiss];
                                   }];
}

#pragma mark - custom delegate
- (void)thn_openGoodsSkuWithType:(THNGoodsButtonType)type {
    [self thn_getGoodsButtonType:type];
}

#pragma mark - event response
- (void)sureButtonAction:(UIButton *)button {
    if ([THNLoginManager isLogin]) {
        [self thn_getGoodsButtonType:self.handleType];
        
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            THNSignInViewController *signInVC = [[THNSignInViewController alloc] init];
            THNBaseNavigationController *loginNavController = [[THNBaseNavigationController alloc] initWithRootViewController:signInVC];
            [self presentViewController:loginNavController animated:YES completion:nil];
        });
    }
}

#pragma mark - private methods
- (void)thn_getGoodsButtonType:(THNGoodsButtonType)type {
    switch (type) {
        case THNGoodsButtonTypeSell: {
            [SVProgressHUD thn_showInfoWithStatus:@"卖货"];
        }
            break;

        case THNGoodsButtonTypeBuy: {
            [self thn_openAddressSelectedController];
        }
            break;

        case THNGoodsButtonTypeCustom: {
            [self thn_openAddressSelectedController];
        }
            break;

        case THNGoodsButtonTypeAddCart: {
            [self thn_addCartWithSkuItem];
        }
            break;
    }
}

/**
 组合选择的 sku 信息
 */
- (NSArray *)thn_getSelectedGoodsSkuItems {
    NSMutableDictionary *skuItem = [@{kKeySkuId: self.skuView.selectSkuItem.rid,
                                      kKeyQuantity: @(1)} mutableCopy];
    NSArray *skuItems = @[skuItem];
    
    NSMutableDictionary *storeItem = [@{kKeyRid: self.skuView.selectSkuItem.storeRid,
                                        kKeySkuItems: skuItems} mutableCopy];
    
    return @[storeItem];
}

/**
 添加到购物车
 */
- (void)thn_addCartWithSkuItem {
    if (!self.skuView.selectSkuItem) {
        [SVProgressHUD thn_showInfoWithStatus:@"请选择商品属性"];
        return;
    }
    
    NSDictionary *skuParam = @{kKeyRid: self.skuView.selectSkuItem.rid,
                               kKeyQuantity: @(1)};
    
//    [SVProgressHUD thn_show];
    
    WEAKSELF;
    
    [THNGoodsManager postAddGoodsToCartWithSkuParams:skuParam completion:^(NSError *error) {
        if (error) return;
        
        weakSelf.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0];
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            if (weakSelf.selectGoodsAddCartCompleted) {
                weakSelf.selectGoodsAddCartCompleted(weakSelf.skuView.selectSkuItem.rid);
            }
        }];
    }];
}

/**
 选择收货地址
 */
- (void)thn_openAddressSelectedController {
    if (!self.skuView.selectSkuItem) {
        [SVProgressHUD thn_showInfoWithStatus:@"请选择商品属性"];
        return;
    }
    
    THNSelectAddressViewController *selectAddressVC = [[THNSelectAddressViewController alloc] init];
    selectAddressVC.selectedSkuItems = [self thn_getSelectedGoodsSkuItems];
    selectAddressVC.deliveryCountrys = @[self.skuView.selectSkuItem.deliveryCountry];
    selectAddressVC.goodsTotalPrice = [self thn_getGoodsSkuPrice];
    THNBaseNavigationController *orderNav = [[THNBaseNavigationController alloc] initWithRootViewController:selectAddressVC];
    [self presentViewController:orderNav animated:YES completion:nil];
}

/**
 sku 的售价
 */
- (CGFloat)thn_getGoodsSkuPrice {
    CGFloat price = self.skuView.selectSkuItem.salePrice != 0 ? self.skuView.selectSkuItem.salePrice : self.skuView.selectSkuItem.price;
    
    return price;
}

/**
 根据有库存设置按钮状态
 */
- (void)thn_setSureButtonTypeWithStatus:(NSInteger)status {
    NSString *title = status == 1 ? kTitleSure : kTextNone;
    [self.sureButton setTitle:title forState:(UIControlStateNormal)];
    self.sureButton.backgroundColor = [UIColor colorWithHexString:kColorMain alpha:status == 1 ? 1 : 0.5];
    self.sureButton.userInteractionEnabled = status == 1;
}

#pragma mark - setup UI
- (void)setupUI {
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.mainView];
    [self.mainView addSubview:self.skuView];
    
    if (self.viewType == THNGoodsSkuTypeDirectSelect) {
        [self.mainView addSubview:self.functionView];
        [self.functionView thn_setGoodsModel:self.goodsModel];
        
    } else if (self.viewType == THNGoodsSkuTypeDefault) {
        [self.mainView addSubview:self.sureButton];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.skuView.frame = CGRectMake(0, SCREEN_HEIGHT - 300, SCREEN_WIDTH, 300);
    if (self.skuModel) {
        [self thn_showSkuView:YES];
    }
}

- (void)thn_showSkuView:(BOOL)show {
    CGFloat originY = show ? 0 : SCREEN_HEIGHT;
    CGRect viewFrame = CGRectMake(0, originY, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:1.0
                        options:(UIViewAnimationOptionCurveEaseOut) animations:^{
                            self.mainView.frame = viewFrame;
                        } completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([touches anyObject].view == self.mainView) {
        self.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - getters and setters
- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    }
    return _maskView;
}

- (UIView *)mainView {
    if (!_mainView) {
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _mainView;
}

- (THNGoodsSkuView *)skuView {
    if (!_skuView) {
        _skuView = [[THNGoodsSkuView alloc] initWithSkuModel:self.skuModel goodsModel:self.goodsModel];
    }
    return _skuView;
}

- (THNGoodsFunctionView *)functionView {
    if (!_functionView) {
        CGFloat viewH = kDeviceiPhoneX ? 80 : 60;
        _functionView = [[THNGoodsFunctionView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - viewH, SCREEN_WIDTH, viewH)
                                                               type:(THNGoodsFunctionViewTypeDefault)];
        [_functionView thn_showGoodsCart:NO];
        _functionView.drawLine = NO;
        _functionView.delegate = self;
    }
    return _functionView;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        CGFloat originBottom = kDeviceiPhoneX ? 35 : 15;
        _sureButton = [[UIButton alloc] initWithFrame:CGRectMake(15, SCREEN_HEIGHT - (40 + originBottom), SCREEN_WIDTH - 30, 40)];
        _sureButton.backgroundColor = [UIColor colorWithHexString:kColorMain];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightMedium)];
        [_sureButton drawCornerWithType:(UILayoutCornerRadiusAll) radius:4];
        [_sureButton addTarget:self action:@selector(sureButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _sureButton;
}

@end
