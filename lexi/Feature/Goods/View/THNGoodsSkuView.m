//
//  THNGoodsSkuView.m
//  lexi
//
//  Created by FLYang on 2018/8/31.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsSkuView.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>
#import "YYLabel+Helper.h"
#import "THNMarco.h"
#import "UIColor+Extension.h"
#import "THNGoodsSkuCollecitonView.h"

static NSString *const kTitleColor = @"颜色";
static NSString *const kTitleSize  = @"尺寸";

@interface THNGoodsSkuView ()

/// 背景遮罩
@property (nonatomic, strong) UIView *backgroudMaskView;
/// 控件容器
@property (nonatomic, strong) UIView *containerView;
/// 商品标题
@property (nonatomic, strong) YYLabel *titleLabel;
@property (nonatomic, assign) CGFloat titleH;
/// 价格
@property (nonatomic, strong) YYLabel *priceLabel;
/// 颜色列表
@property (nonatomic, strong) THNGoodsSkuCollecitonView *colorCollectionView;
/// 尺寸列表
@property (nonatomic, strong) THNGoodsSkuCollecitonView *sizeCollectionView;

@end

@implementation THNGoodsSkuView

- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

- (void)thn_setTitleAttributedString:(NSAttributedString *)string {
    self.titleLabel.attributedText = string;
    
    self.titleH = [self.titleLabel thn_getLabelHeightWithMaxWidth:CGRectGetWidth(self.bounds) - 40];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.titleH);
    }];
}

- (void)thn_setGoodsSkuModel:(THNSkuModel *)model {
    [self thn_setPriceTextWithValue:189.2];
    [self.colorCollectionView thn_setSkuNameData:model.colors];
    [self.sizeCollectionView thn_setSkuNameData:model.modes];
}

- (void)thn_showGoodsSkuViewWithType:(THNGoodsFunctionViewType)viewType handleType:(THNGoodsButtonType)handleType {
    self.viewType = viewType;
    self.handleType = handleType;
    
    [self thn_showView:YES];
}

#pragma mark - event response
- (void)closeView:(UITapGestureRecognizer *)tap {
    [self thn_showView:NO];
}

#pragma mark - private methods
- (void)thn_setPriceTextWithValue:(CGFloat)value {
    NSString *salePriceStr = [NSString stringWithFormat:@"￥%.2f", value];
    NSMutableAttributedString *salePriceAtt = [[NSMutableAttributedString alloc] initWithString:salePriceStr];
    salePriceAtt.color = [UIColor colorWithHexString:@"#333333"];
    salePriceAtt.font = [UIFont systemFontOfSize:17 weight:(UIFontWeightBold)];
    
    self.priceLabel.attributedText = salePriceAtt;
}

- (void)thn_showView:(BOOL)show {
    CGFloat backgroudAlpha = show ? 1 : 0;
    CGRect selfRect = CGRectMake(0, show ? 0 : SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [UIView animateWithDuration:(NSTimeInterval)0.4 animations:^{
        self.backgroudMaskView.hidden = YES;
        self.frame = selfRect;
        self.backgroudMaskView.alpha = backgroudAlpha;
        
    } completion:^(BOOL finished) {
        self.backgroudMaskView.hidden = !show;
    }];
}

#pragma mark - setup UI
- (void)setupViewUI {
    [self addSubview:self.backgroudMaskView];
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.priceLabel];
    [self.containerView addSubview:self.colorCollectionView];
    [self.containerView addSubview:self.sizeCollectionView];
    [self addSubview:self.containerView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat viewH = CGRectGetHeight(self.bounds);
    CGFloat viewW = CGRectGetWidth(self.bounds);
    
    self.backgroudMaskView.frame = self.bounds;
    CGFloat containerViewH = 350;
    self.containerView.frame = CGRectMake(0, viewH - containerViewH, viewW, containerViewH);
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(self.titleH);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(10);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(20);
    }];
    
    [self.colorCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(self.priceLabel.mas_bottom).with.offset(30);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(24);
    }];
    
    [self.sizeCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(self.colorCollectionView.mas_bottom).with.offset(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(24);
    }];
}

#pragma mark - getters and setters
- (UIView *)backgroudMaskView {
    if (!_backgroudMaskView) {
        _backgroudMaskView = [[UIView alloc] init];
        _backgroudMaskView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView:)];
        [_backgroudMaskView addGestureRecognizer:tap];
    }
    return _backgroudMaskView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

- (YYLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[YYLabel alloc] init];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (YYLabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[YYLabel alloc] init];
    }
    return _priceLabel;
}

- (THNGoodsSkuCollecitonView *)colorCollectionView {
    if (!_colorCollectionView) {
        _colorCollectionView = [[THNGoodsSkuCollecitonView alloc] initWithFrame:CGRectZero title:kTitleColor];
    }
    return _colorCollectionView;
}

- (THNGoodsSkuCollecitonView *)sizeCollectionView {
    if (!_sizeCollectionView) {
        _sizeCollectionView = [[THNGoodsSkuCollecitonView alloc] initWithFrame:CGRectZero title:kTitleSize];
    }
    return _sizeCollectionView;
}

@end
