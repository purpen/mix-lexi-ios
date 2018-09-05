//
//  THNGoodsImagesViewController.m
//  lexi
//
//  Created by FLYang on 2018/8/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsImagesViewController.h"
#import "THNImagesView.h"
#import "THNGoodsActionButton.h"
#import "THNGoodsActionButton+SelfManager.h"
#import "UIView+Helper.h"

@interface THNGoodsImagesViewController () <THNNavigationBarViewDelegate>

/// 图片列表
@property (nonatomic, strong) THNImagesView *imagesView;
/// 喜欢按钮
@property (nonatomic, strong) THNGoodsActionButton *likeButton;
/// 购买按钮
@property (nonatomic, strong) THNGoodsActionButton *buyButton;
/// 分享按钮
@property (nonatomic, strong) UIButton *shareButton;
/// 商品数据
@property (nonatomic, strong) THNGoodsModel *model;
/// 图片数据
@property (nonatomic, strong) NSArray *imagesArr;
/// 喜欢状态
@property (nonatomic, assign) BOOL isLike;

@end

@implementation THNGoodsImagesViewController

- (instancetype)initWithGoodsModel:(THNGoodsModel *)model {
    self = [super init];
    if (self) {
        self.model = model;
        self.imagesArr = model.assets;
        self.isLike = model.isLike;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - event response
- (void)buyButtonAction:(id)sender {
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self dismissViewControllerAnimated:YES completion:^{
        self.buyGoodsCompleted();
    }];
}

- (void)shareButtonAction:(UIButton *)button {
    [SVProgressHUD showInfoWithStatus:@"分享商品"];
}

#pragma mark - private methods
- (void)thn_changeImagesViewFrame:(BOOL)change {
    CGFloat originY = change ? (SCREEN_HEIGHT - SCREEN_WIDTH) / 2 : 0;
    CGRect imageFrame = CGRectMake(0, originY, SCREEN_WIDTH, SCREEN_WIDTH);
    
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:1.0
                        options:(UIViewAnimationOptionCurveEaseOut) animations:^{
                            self.imagesView.frame = imageFrame;
                        } completion:nil];
}

#pragma mark - setup UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.imagesView];
    [self.view addSubview:self.likeButton];
    [self.view addSubview:self.buyButton];
    [self.view addSubview:self.shareButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
}

- (void)setNavigationBar {
    self.navigationBarView.delegate = self;
    [self.navigationBarView setNavigationTransparent:YES showShadow:NO];
    [self.navigationBarView setNavigationLeftButtonOfImageNamed:@"icon_back_white"];
    
    WEAKSELF;
    [self.navigationBarView didNavigationLeftButtonCompletion:^{
        weakSelf.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self thn_changeImagesViewFrame:YES];
    
    [self.likeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(66, 29));
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(kDeviceiPhoneX ? -52 : -20);
    }];
    
    [self.buyButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(66, 29));
        make.left.equalTo(self.likeButton.mas_right).with.offset(15);
        make.centerY.mas_equalTo(self.likeButton);
    }];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(29, 29));
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.likeButton);
    }];
    [self.shareButton drawCornerWithType:(UILayoutCornerRadiusAll) radius:29/2];
}

#pragma mark - getters and setters
- (THNImagesView *)imagesView {
    if (!_imagesView) {
        _imagesView = [[THNImagesView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)
                                                fullScreen:YES];
        [_imagesView thn_setImageAssets:self.imagesArr];
    }
    return _imagesView;
}

- (THNGoodsActionButton *)likeButton {
    if (!_likeButton) {
        _likeButton = [[THNGoodsActionButton alloc] initWithType:(THNGoodsActionButtonTypeLike)];
        [_likeButton selfManagerLikeGoodsStatus:self.isLike goodsId:self.model.rid];
    }
    return _likeButton;
}

- (THNGoodsActionButton *)buyButton {
    if (!_buyButton) {
        _buyButton = [[THNGoodsActionButton alloc] initWithType:(THNGoodsActionButtonTypeBuy)];
        [_buyButton setBuyGoodsButton];
        [_buyButton addTarget:self action:@selector(buyButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _buyButton;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [[UIButton alloc] init];
        _shareButton.backgroundColor = [UIColor colorWithHexString:@"#2D343A"];
        [_shareButton setImage:[UIImage imageNamed:@"icon_share_white"] forState:(UIControlStateNormal)];
        [_shareButton setImageEdgeInsets:(UIEdgeInsetsMake(8, 8, 8, 8))];
        [_shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _shareButton;
}

- (void)dealloc {
    
}

@end
