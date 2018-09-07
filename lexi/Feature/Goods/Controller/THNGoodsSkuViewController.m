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

static NSString *const kTitleSure = @"确定";

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

@end

@implementation THNGoodsSkuViewController

- (instancetype)initWithSkuModel:(THNSkuModel *)model goodsModel:(THNGoodsModel *)goodsModel viewType:(THNGoodsSkuType)viewTpye {
    self = [super init];
    if (self) {
        self.skuModel = model;
        self.goodsModel = goodsModel;
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

#pragma mark - custom delegate
- (void)thn_openGoodsSkuWithType:(THNGoodsButtonType)type {
    [self thn_getGoodsButtonType:type];
}

#pragma mark - event response
- (void)sureButtonAction:(UIButton *)button {
    [self thn_getGoodsButtonType:self.skuView.handleType];
}

#pragma mark - private methods
- (void)thn_getGoodsButtonType:(THNGoodsButtonType)type {
    switch (type) {
        case THNGoodsButtonTypeSell: {
            [SVProgressHUD showInfoWithStatus:@"卖货"];
        }
            break;
            
        case THNGoodsButtonTypeBuy: {
            [SVProgressHUD showInfoWithStatus:@"立即购买"];
        }
            break;
            
        case THNGoodsButtonTypeCustom: {
            [SVProgressHUD showInfoWithStatus:@"接单订制"];
        }
            break;
            
        case THNGoodsButtonTypeAddCart: {
            [SVProgressHUD showInfoWithStatus:@"加入购物车"];
        }
            break;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (![[touches anyObject].view isKindOfClass:[THNGoodsSkuView class]]) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

#pragma mark - setup UI
- (void)setupUI {
    [self.view addSubview:self.skuView];
    [self.skuView thn_setGoodsSkuModel:self.skuModel];
    
    if (self.viewType == THNGoodsSkuTypeDirectSelect) {
        [self.view addSubview:self.functionView];
        [self.functionView thn_setGoodsModel:self.goodsModel];
        
    } else if (self.viewType == THNGoodsSkuTypeDefault) {
        [self.view addSubview:self.sureButton];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self thn_showSkuView:YES];
}

- (void)thn_showSkuView:(BOOL)show {
    CGFloat originY = show ? SCREEN_HEIGHT - 320 : SCREEN_HEIGHT;
    CGRect viewFrame = CGRectMake(0, originY, SCREEN_WIDTH, 320);
    
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:1.0
                        options:(UIViewAnimationOptionCurveEaseOut) animations:^{
                            self.skuView.frame = viewFrame;
                        } completion:nil];
}

#pragma mark - getters and setters
- (THNGoodsSkuView *)skuView {
    if (!_skuView) {
        _skuView = [[THNGoodsSkuView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 320)];
    }
    return _skuView;
}

- (THNGoodsFunctionView *)functionView {
    if (!_functionView) {
        CGFloat viewH = kDeviceiPhoneX ? 80 : 50;
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
        [_sureButton setTitle:kTitleSure forState:(UIControlStateNormal)];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightMedium)];
        [_sureButton drawCornerWithType:(UILayoutCornerRadiusAll) radius:4];
        [_sureButton addTarget:self action:@selector(sureButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _sureButton;
}

@end
