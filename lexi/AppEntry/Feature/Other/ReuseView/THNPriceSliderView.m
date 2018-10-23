//
//  THNPriceSliderView.m
//  lexi
//
//  Created by FLYang on 2018/8/27.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNPriceSliderView.h"
#import "UIColor+Extension.h"
#import "THNConst.h"
#import "THNMarco.h"
#import <Masonry/Masonry.h>
#import <SVProgressHUD/SVProgressHUD.h>

#define kSliderWidth SCREEN_WIDTH - (40 + 25)
static CGFloat const kSliderImageW  = 25.0;
static CGFloat const kSliderHeight  = 4.0;
/// 默认标题文字
static NSString *const kTitlePrice = @"价格区间";
/// 价格标识
static NSInteger const kPriceLabelTag = 623;

@interface THNPriceSliderView ()

/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSMutableArray *labelArray;
/// 选中的最小价格
@property (nonatomic, strong) UILabel *minPriceLabel;
/// 选中的最大价格
@property (nonatomic, strong) UILabel *maxPriceLabel;
/// min 的中心位置
@property (nonatomic, assign) CGFloat minPonitX;
/// max 的中心位置
@property (nonatomic, assign) CGFloat maxPonitX;
/// 最小值
@property (nonatomic, assign) NSInteger minimumValue;
/// 最大值
@property (nonatomic, assign) NSInteger maximumValue;
/// 标题文字之间的宽度
@property (nonatomic, assign) CGFloat sectionWidth;
/// 标题文字数组
@property (nonatomic, strong) NSArray *titleArray;
/// 背景条
@property (nonatomic, strong) UIView *sliderBackgroundView;
/// 滑过的条
@property (nonatomic, strong) UIView *sliderSelectView;
/// 滑块图片
@property (nonatomic, strong) UIImage *sliderImage;
/// min 滑块的 ImageView
@property (nonatomic, strong) UIImageView *minImageView;
/// max 滑块的 ImageView
@property (nonatomic, strong) UIImageView *maxImageView;
/// min 滑动的x距离
@property (nonatomic, assign) CGFloat firstXFromCenter;
/// max 滑动的x距离
@property (nonatomic, assign) CGFloat lastXFromCenter;

@end

@implementation THNPriceSliderView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

#pragma mark - public methods
- (void)thn_resetSliderValue {
    [self thn_initProperty];
    [self thn_selectMinPriceTitleWithIndex:self.minimumValue];
    [self thn_selectMaxPriceTitleWithIndex:self.maximumValue];
    [self resetSliderView];
}

#pragma mark - private methods
/**
 获取选择的价格区间
 */
- (void)thn_getSelectPriceSection {
    NSInteger minPrice = [self.titleArray[self.minimumValue] integerValue];
    // 价格“无限”，值为：0
    BOOL isLastValue = self.maximumValue == self.titleArray.count - 1;
    NSInteger maxPrice = isLastValue ? 0 : [self.titleArray[self.maximumValue] integerValue];
    
    if ([self.delegate respondsToSelector:@selector(thn_selectedPriceSliderMinPrice:maxPrice:)]) {
        [self.delegate thn_selectedPriceSliderMinPrice:minPrice maxPrice:maxPrice];
    };
}

- (void)thn_selectMinPriceTitleWithIndex:(NSInteger)index {
    self.minPriceLabel.textColor = [UIColor colorWithHexString:@"#B2B2B2"];
    UILabel *label = (UILabel *)self.labelArray[index];
    label.textColor = [UIColor colorWithHexString:kColorMain];
    self.minPriceLabel = label;
    
    [self thn_getSelectPriceSection];
}

- (void)thn_selectMaxPriceTitleWithIndex:(NSInteger)index {
    self.maxPriceLabel.textColor = [UIColor colorWithHexString:@"#B2B2B2"];
    UILabel *label = (UILabel *)self.labelArray[index];
    label.textColor = [UIColor colorWithHexString:kColorMain];
    self.maxPriceLabel = label;
    
    [self thn_getSelectPriceSection];
}

- (void)changeMinImageViewPointX:(CGFloat)x {
    if (x <= 20 + kSliderImageW / 2) {
        self.minPonitX = 20 + kSliderImageW / 2;
        
    } else if (x >= self.maxPonitX - kSliderImageW) {
        self.minPonitX = self.maxPonitX - kSliderImageW;
    }
    
    self.minimumValue = (NSInteger)(self.minPonitX / self.sectionWidth);
    
    if (self.minimumValue == self.maximumValue && (self.maximumValue > 0 && self.maximumValue < self.titleArray.count)) {
        self.minimumValue -= 1;
    }
    
    [self thn_selectMinPriceTitleWithIndex:self.minimumValue];
}

- (void)changeMaxImageViewPointX:(CGFloat)x {
    if (x <= self.minPonitX + kSliderImageW) {
        self.maxPonitX = self.minPonitX + kSliderImageW;
        
    } else if (x >= CGRectGetWidth(self.sliderBackgroundView.frame)) {
        self.maxPonitX = SCREEN_WIDTH - 20 - kSliderImageW / 2;
    }
    
    self.maximumValue = (NSInteger)(self.maxPonitX / self.sectionWidth);
    
    if (self.minimumValue == self.maximumValue && (self.maximumValue > 0 && self.maximumValue < self.titleArray.count)) {
        self.maximumValue += 1;
    }
    
    [self thn_selectMaxPriceTitleWithIndex:self.maximumValue];
}

- (void)resetSliderView {
    CGFloat originMinX = CGRectGetMinX(self.sliderBackgroundView.frame);
    CGFloat originMaxX = CGRectGetMaxX(self.sliderBackgroundView.frame);
    CGFloat originMinY = CGRectGetMinY(self.sliderBackgroundView.frame);
    CGFloat originWidth = CGRectGetWidth(self.sliderBackgroundView.frame);
    CGFloat sliderHeightY = kSliderImageW / 2 - kSliderHeight / 2;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.minImageView.frame = CGRectMake(20, originMinY - sliderHeightY, kSliderImageW, kSliderImageW);
        self.maxImageView.frame = CGRectMake(originMaxX - kSliderImageW / 2, originMinY - sliderHeightY, kSliderImageW, kSliderImageW);
        self.sliderSelectView.frame = CGRectMake(originMinX, originMinY, originWidth, kSliderHeight);
    }];
}

#pragma mark - event response
- (void)minSliderAction:(UIPanGestureRecognizer *)pan {
    CGFloat minCenterX = [pan translationInView:self.minImageView].x;
    CGFloat minPointY = self.sliderBackgroundView.center.y;
    CGFloat sliderOriginY = CGRectGetMinY(self.sliderBackgroundView.frame);

    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            self.minImageView.center = CGPointMake(self.minPonitX, minPointY);
        }
            break;
            
        case UIGestureRecognizerStateChanged: {
            if (self.minPonitX + minCenterX <= 20 + kSliderImageW / 2) {
                break;
            }
            
            if (self.minPonitX + minCenterX >= self.maxImageView.center.x - kSliderImageW) {
                break;
            }
            
            CGFloat sliderWidth = self.maxImageView.center.x - (self.minPonitX + minCenterX) - kSliderImageW / 2;
            self.minImageView.center = CGPointMake(self.minPonitX + minCenterX, minPointY);
            self.sliderSelectView.frame = CGRectMake(self.minPonitX + minCenterX, sliderOriginY, sliderWidth, kSliderHeight);
        }
            break;
            
        case UIGestureRecognizerStateEnded: {
            self.minPonitX += minCenterX;
            
            [self changeMinImageViewPointX:self.minPonitX];
            
            CGFloat selectWidth = self.minimumValue * self.sectionWidth;
            CGFloat sliderOriginX = CGRectGetMinX(self.sliderBackgroundView.frame) + selectWidth;
            CGFloat sliderWidth = self.maxImageView.center.x - selectWidth - (20 + kSliderImageW / 2);
            [UIView animateWithDuration:0.3 animations:^{
                self.minImageView.center = CGPointMake(20 + kSliderImageW / 2 + selectWidth, minPointY);
                self.sliderSelectView.frame = CGRectMake(sliderOriginX, sliderOriginY, sliderWidth, kSliderHeight);
            }];
        }
            break;
            
        default:
            break;
    }
}

- (void)maxSliderAction:(UIPanGestureRecognizer *)pan {
    CGFloat maxCenterX = [pan translationInView:self.maxImageView].x;
    CGFloat maxPointY = self.sliderBackgroundView.center.y;
    CGFloat sliderOriginY = CGRectGetMinY(self.sliderBackgroundView.frame);
    CGFloat sliderOriginX = self.minImageView.center.x;
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            self.maxImageView.center = CGPointMake(self.maxPonitX, maxPointY);
        }
            break;
            
        case UIGestureRecognizerStateChanged: {
            if (self.maxPonitX + maxCenterX >= kSliderWidth) {
                break;
            }
            
            if (self.maxPonitX + maxCenterX <= sliderOriginX + kSliderImageW) {
                break;
            }
            
            CGFloat sliderWidth = (self.maxPonitX + maxCenterX) - sliderOriginX;
            self.maxImageView.center = CGPointMake(self.maxPonitX + maxCenterX, maxPointY);
            self.sliderSelectView.frame = CGRectMake(sliderOriginX, sliderOriginY, sliderWidth, kSliderHeight);
        }
            break;
            
        case UIGestureRecognizerStateEnded: {
            self.maxPonitX += maxCenterX;
            
            [self changeMaxImageViewPointX:self.maxPonitX];
            
            CGFloat selectWidth = self.maximumValue * self.sectionWidth;
            CGFloat sliderViewW = selectWidth - sliderOriginX + 20 + kSliderImageW / 2;
            [UIView animateWithDuration:0.3 animations:^{
                self.maxImageView.center = CGPointMake(20 + kSliderImageW / 2 + selectWidth, maxPointY);
                self.sliderSelectView.frame = CGRectMake(sliderOriginX, sliderOriginY, sliderViewW, kSliderHeight);
            }];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - setup UI
- (void)setupViewUI {
    // 设置属性
    [self thn_initProperty];
    
    // 添加视图
    [self createPriceTitles:self.titleArray];
    [self thn_selectMinPriceTitleWithIndex:self.minimumValue];
    [self thn_selectMaxPriceTitleWithIndex:self.maximumValue];
    [self addSubview:self.titleLabel];
    [self addSubview:self.sliderBackgroundView];
    [self addSubview:self.sliderSelectView];
    [self addSubview:self.minImageView];
    [self addSubview:self.maxImageView];
}

/**
 初始化属性值
 */
- (void)thn_initProperty {
    self.titleArray = @[@(0), @(150), @(300), @(400), @(500), @(800), @"不限"];
    self.sectionWidth = (SCREEN_WIDTH - 12) / self.titleArray.count;
    self.minimumValue = 0;
    self.maximumValue = self.titleArray.count - 1;
    self.minPonitX = 20 + kSliderImageW / 2;
    self.maxPonitX = SCREEN_WIDTH - 20 - kSliderImageW / 2;
}

#pragma mark - getters and setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:17 weight:(UIFontWeightMedium)];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.text = kTitlePrice;
    }
    return _titleLabel;
}

- (UIView *)sliderBackgroundView {
    if (!_sliderBackgroundView) {
        _sliderBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(20 + kSliderImageW / 2, 60, kSliderWidth, kSliderHeight)];
        _sliderBackgroundView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        _sliderBackgroundView.layer.cornerRadius = kSliderHeight / 2;
        _sliderBackgroundView.userInteractionEnabled = NO;
    }
    return _sliderBackgroundView;
}

- (UIView *)sliderSelectView {
    if (!_sliderSelectView) {
        _sliderSelectView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.sliderBackgroundView.frame), \
                                                                     CGRectGetMinY(self.sliderBackgroundView.frame), \
                                                                     CGRectGetWidth(self.sliderBackgroundView.frame), kSliderHeight)];
        _sliderSelectView.backgroundColor = [UIColor colorWithHexString:kColorMain];
        _sliderSelectView.layer.cornerRadius = kSliderHeight / 2;
        _sliderSelectView.userInteractionEnabled = NO;
    }
    return _sliderSelectView;
}

- (UIImageView *)minImageView {
    if (!_minImageView) {
        _minImageView = [[UIImageView alloc] initWithFrame:\
                         CGRectMake(20, CGRectGetMinY(self.sliderBackgroundView.frame) - kSliderImageW / 2 + kSliderHeight / 2, \
                                    kSliderImageW, kSliderImageW)];
        _minImageView.image = [UIImage imageNamed:@"icon_price_section"];
        _minImageView.userInteractionEnabled = YES;
        
        UIPanGestureRecognizer *minPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(minSliderAction:)];
        [_minImageView addGestureRecognizer:minPan];
    }
    return _minImageView;
}

- (UIImageView *)maxImageView {
    if (!_maxImageView) {
        _maxImageView = [[UIImageView alloc] initWithFrame:\
                         CGRectMake(CGRectGetMaxX(self.sliderBackgroundView.frame) - kSliderImageW / 2, \
                                    CGRectGetMinY(self.sliderBackgroundView.frame) - kSliderImageW / 2 + kSliderHeight / 2, \
                                    kSliderImageW, kSliderImageW)];
        _maxImageView.image = [UIImage imageNamed:@"icon_price_section"];
        _maxImageView.userInteractionEnabled = YES;
        
        UIPanGestureRecognizer *maxPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(maxSliderAction:)];
        [_maxImageView addGestureRecognizer:maxPan];
    }
    return _maxImageView;
}

- (void)createPriceTitles:(NSArray *)titleArray {
    for (NSUInteger idx = 0; idx < titleArray.count; idx ++) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(6 + self.sectionWidth * idx, 87, self.sectionWidth, 13)];
        titleLabel.font = [UIFont systemFontOfSize:12];
        
        if (idx == titleArray.count - 1) {
            titleLabel.text = titleArray[idx];
        } else {
            titleLabel.text = [NSString stringWithFormat:@"￥%zi", [titleArray[idx] integerValue]];
        }
        
        titleLabel.textColor = [UIColor colorWithHexString:@"#B2B2B2"];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.tag = kPriceLabelTag + idx;
        
        if (idx == 0) {
            self.minPriceLabel = titleLabel;
            
        } else if (idx == titleArray.count - 1) {
            self.maxPriceLabel = titleLabel;
        }
        
        [self.labelArray addObject:titleLabel];
        [self addSubview:titleLabel];
    }
}

- (NSMutableArray *)labelArray {
    if (!_labelArray) {
        _labelArray = [NSMutableArray array];
    }
    return _labelArray;
}

@end
