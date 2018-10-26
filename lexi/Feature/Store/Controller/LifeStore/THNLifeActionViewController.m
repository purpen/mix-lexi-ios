
//
//  THNLifeActionViewController.m
//  lexi
//
//  Created by FLYang on 2018/10/15.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNLifeActionViewController.h"
#import "UIView+Helper.h"
#import <YYKit/YYKit.h>
#import <Photos/Photos.h>
#import "THNLoginManager.h"
#import "THNLifeManager.h"

static NSString *const kTextHint        = @"待结算金额需用户确认签收订单后，7个工作日内未发生退款，则可入账并提现。如在7日内有退款行为，扣除相应收益。";
static NSString *const kTextSaveImage   = @"保存图片";
static NSString *const kTextCash        = @"提现到微信零钱包";

@interface THNLifeActionViewController ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, assign) THNLifeActionType actionType;
/// 提示文字
@property (nonatomic, strong) YYLabel *hintLabel;
/// 微信二维码图片
@property (nonatomic, strong) UIImageView *showImageView;
@property (nonatomic, strong) UIButton *saveImageButton;
/// 提现
@property (nonatomic, strong) UIButton *cashButton;
@property (nonatomic, strong) UILabel *cashMoneyLabel;
@property (nonatomic, strong) UILabel *cashServiceLabel;
@property (nonatomic, strong) UIImageView *cashIconImageView;

@end

@implementation THNLifeActionViewController

- (instancetype)initWithType:(THNLifeActionType)type {
    self = [super init];
    if (self) {
        self.actionType = type;
        [self thn_addSubViewWithType:type];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setHintText:(NSString *)hintText {
    self.hintLabel.text = hintText;
}

- (void)thn_setCashMoney:(CGFloat)cashMoney serviceMoney:(CGFloat)serviceMoney {
    self.cashMoneyLabel.text = [NSString stringWithFormat:@"%.2f", cashMoney];
     self.cashServiceLabel.text = [NSString stringWithFormat:@"技术服务费：%.2f", serviceMoney];
}

#pragma mark - event response
- (void)saveImageButtonAction:(UIButton *)button {
    if (self.showImageView.image == nil) {
        return;
    }
    
    UIImageWriteToSavedPhotosAlbum(self.showImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [SVProgressHUD thn_showErrorWithStatus:@"保存失败"];
        
    } else {
        [SVProgressHUD thn_showSuccessWithStatus:@"保存成功"];
    }
}

- (void)cashButtonAction:(UIButton *)button {
    [SVProgressHUD thn_showInfoWithStatus:@"提现到微信"];
//    [THNLifeManager getLifeCashWithStoreRid:[THNLoginManager sharedManager].storeRid
//                                     openId:@""
//                                 completion:^(NSError *) {
//
//    }];
}

#pragma mark - setup UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.4];

    [self.view addSubview:self.containerView];
}

- (void)thn_addSubViewWithType:(THNLifeActionType)type {
    switch (type) {
        case THNLifeActionTypeText: {
            [self.containerView addSubview:self.hintLabel];
        }
            break;
            
        case THNLifeActionTypeImage: {
            [self.containerView addSubview:self.showImageView];
            [self.view addSubview:self.saveImageButton];
        }
            break;
            
        case THNLifeActionTypeCash: {
            [self.containerView addSubview:self.cashIconImageView];
            [self.containerView addSubview:self.cashMoneyLabel];
            [self.containerView addSubview:self.cashServiceLabel];
            [self.containerView addSubview:self.cashButton];
        }
            break;
    }
}

- (CGRect)thn_setSubviewFrame {
    CGRect containerFrame = CGRectZero;
    
    switch (self.actionType) {
        case THNLifeActionTypeText: {
            containerFrame = CGRectMake((SCREEN_WIDTH - 280) / 2, (SCREEN_HEIGHT - 115) / 2, 280, 115);
            self.hintLabel.frame = CGRectMake(15, 0, 250, 115);
        }
            break;
            
        case THNLifeActionTypeImage: {
            containerFrame = CGRectMake((SCREEN_WIDTH - 230) / 2, (SCREEN_HEIGHT - 284) / 2, 230, 284);
            self.showImageView.frame = CGRectMake(0, 0, 230, 284);
            self.saveImageButton.frame = CGRectMake((SCREEN_WIDTH - 230) / 2, CGRectGetMaxY(containerFrame) + 20, 230, 40);
            [self.saveImageButton drawCornerWithType:(UILayoutCornerRadiusAll) radius:4];
        }
            break;
            
        case THNLifeActionTypeCash: {
            containerFrame = CGRectMake((SCREEN_WIDTH - 280) / 2, (SCREEN_HEIGHT - 260) / 2, 280, 260);
            self.cashIconImageView.frame = CGRectMake(111, 30, 57, 57);
            self.cashMoneyLabel.frame = CGRectMake(20, 100, 240, 26);
            self.cashServiceLabel.frame = CGRectMake(20, 135, 240, 13);
            self.cashButton.frame = CGRectMake(20, 200, 240, 40);
            [self.cashButton drawCornerWithType:(UILayoutCornerRadiusAll) radius:4];
        }
            break;
    }
    
    self.containerView.frame = containerFrame;
    [self.containerView drawCornerWithType:(UILayoutCornerRadiusAll) radius:4];
    
    return containerFrame;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self thn_setSubviewFrame];
    [self thn_showTransform];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationBarView.hidden = YES;
}

- (void)thn_showTransform {
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    if (touch.view != self.containerView) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

#pragma mark - getters and setters
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 320) / 2, (SCREEN_HEIGHT - 400) / 2, 320, 400)];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.transform = CGAffineTransformMakeScale(0.0, 0.0);
    }
    return _containerView;
}

- (YYLabel *)hintLabel {
    if (!_hintLabel) {
        _hintLabel = [[YYLabel alloc] init];
        _hintLabel.numberOfLines = 0;
        
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:kTextHint];
        att.font = [UIFont systemFontOfSize:12];
        att.color = [UIColor colorWithHexString:@"#333333"];
        att.lineSpacing = 5;
        
        _hintLabel.attributedText = att;
    }
    return _hintLabel;
}

- (UIImageView *)showImageView {
    if (!_showImageView) {
        _showImageView = [[UIImageView alloc] init];
        _showImageView.image = [UIImage imageWithContentsOfFile: \
                                [[NSBundle mainBundle] pathForResource:@"image_life_wechat" ofType:@".png"]];
        _showImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _showImageView;
}

- (UIButton *)saveImageButton {
    if (!_saveImageButton) {
        _saveImageButton = [[UIButton alloc] init];
        _saveImageButton.backgroundColor = [UIColor colorWithHexString:kColorMain];
        [_saveImageButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_saveImageButton setTitle:kTextSaveImage forState:(UIControlStateNormal)];
        _saveImageButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_saveImageButton addTarget:self action:@selector(saveImageButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _saveImageButton;
}

- (UIButton *)cashButton {
    if (!_cashButton) {
        _cashButton = [[UIButton alloc] init];
        _cashButton.backgroundColor = [UIColor colorWithHexString:kColorMain];
        [_cashButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_cashButton setTitle:kTextCash forState:(UIControlStateNormal)];
        _cashButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cashButton addTarget:self action:@selector(cashButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _cashButton;
}

- (UILabel *)cashMoneyLabel {
    if (!_cashMoneyLabel) {
        _cashMoneyLabel = [[UILabel alloc] init];
        _cashMoneyLabel.font = [UIFont systemFontOfSize:24 weight:(UIFontWeightMedium)];
        _cashMoneyLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _cashMoneyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _cashMoneyLabel;
}

- (UILabel *)cashServiceLabel {
    if (!_cashServiceLabel) {
        _cashServiceLabel = [[UILabel alloc] init];
        _cashServiceLabel.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
        _cashServiceLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _cashServiceLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _cashServiceLabel;
}

- (UIImageView *)cashIconImageView {
    if (!_cashIconImageView) {
        _cashIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_cash_gold"]];
    }
    return _cashIconImageView;
}

@end
