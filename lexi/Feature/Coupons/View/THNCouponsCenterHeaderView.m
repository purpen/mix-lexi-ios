//
//  THNCouponsCenterHeaderView.m
//  lexi
//
//  Created by FLYang on 2018/10/31.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNCouponsCenterHeaderView.h"
#import <HMSegmentedControl/HMSegmentedControl.h>
#import "UIColor+Extension.h"
#import "THNMarco.h"
#import "THNConst.h"
#import "THNCategoriesModel.h"

static NSInteger const kMenuButtonTag = 1351;

@interface THNCouponsCenterHeaderView ()

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) HMSegmentedControl *segmentControl;
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) NSMutableArray *menuButtonArr;
@property (nonatomic, strong) NSMutableArray *categoryModelArr;

@end

@implementation THNCouponsCenterHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

#pragma mark - public methods
- (void)thn_setCategoryData:(NSArray *)category {
    if (self.categoryModelArr.count) return;
    
    NSMutableArray *titleArr = [NSMutableArray array];
    for (NSDictionary *dict in category) {
        THNCategoriesModel *model = [THNCategoriesModel mj_objectWithKeyValues:dict];
        [self.categoryModelArr addObject:model];
        [titleArr addObject:model.name];
    }
    
    [titleArr insertObject:@"推荐" atIndex:0];
    [self.segmentControl setSectionTitles:titleArr];
    self.segmentControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic;
    self.segmentControl.hidden = NO;
}

#pragma mark - event response
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    [UIView animateWithDuration:0.3 animations:^{
        self.menuView.alpha = segmentedControl.selectedSegmentIndex == 0 ? 0 : 1;
    }];
    
    if ([self.delegate respondsToSelector:@selector(thn_didSelectedCategoryWithIndex:)]) {
        [self.delegate thn_didSelectedCategoryWithIndex:segmentedControl.selectedSegmentIndex];
    }
}

- (void)menuButtonAction:(UIButton *)button {
    [self thn_setMenuButtonStyle:[self thn_selectedLastButton] selected:NO];
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
    [self thn_setMenuButtonStyle:button selected:YES];
    
    if ([self.delegate respondsToSelector:@selector(thn_didSelectedCouponType:)]) {
        [self.delegate thn_didSelectedCouponType:button.tag - kMenuButtonTag];
    }
}

#pragma mark - private methods
- (UIButton *)thn_selectedLastButton {
    NSInteger lastIndex = self.selectedButton.tag - kMenuButtonTag;
    
    return (UIButton *)self.menuButtonArr[lastIndex];
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#FFBD9F" alpha:0];
    
    [self addSubview:self.headerImageView];
    [self addSubview:self.segmentControl];
    [self thn_createMenuButtonWithTitles:@[@"同享券", @"单享券"]];
    [self addSubview:self.menuView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.headerImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 150);
}

- (void)thn_setMenuButtonStyle:(UIButton *)button selected:(BOOL)selected {
    UIColor *selectedColor =  [UIColor colorWithHexString:@"#5FE4B1" alpha:0.1];
    UIColor *normalColor =  [UIColor colorWithHexString:@"#F5F7F9" alpha:1];
    button.backgroundColor = selected ? selectedColor : normalColor;
    button.layer.borderColor = selected ? [UIColor colorWithHexString:@"#5FE4B1"].CGColor : normalColor.CGColor;
}

#pragma mark - getters and setters
- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coupon_header_image"]];
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headerImageView.layer.masksToBounds = YES;
    }
    return _headerImageView;
}

- (HMSegmentedControl *)segmentControl {
    if (!_segmentControl) {
        _segmentControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 150, SCREEN_WIDTH, 44)];
        _segmentControl.type = HMSegmentedControlTypeText;
        _segmentControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentControl.selectionIndicatorHeight = 3.0f;
        _segmentControl.selectionIndicatorColor = [UIColor colorWithHexString:kColorMain];
        _segmentControl.segmentEdgeInset = UIEdgeInsetsMake(0, 12, 0, 12);
        _segmentControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 24);
        [_segmentControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        _segmentControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#0F0F0F"],
                                                NSFontAttributeName: [UIFont systemFontOfSize:14]};
        _segmentControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithHexString:kColorMain],
                                                        NSFontAttributeName: [UIFont systemFontOfSize:14]};
        _segmentControl.hidden = YES;
    }
    return _segmentControl;
}

- (UIView *)menuView {
    if (!_menuView) {
        _menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 194, SCREEN_WIDTH, 46)];
        _menuView.backgroundColor = [UIColor whiteColor];
        _menuView.alpha = 0.0;
    }
    return _menuView;
}

- (void)thn_createMenuButtonWithTitles:(NSArray *)titles {
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    lineLabel.backgroundColor = [UIColor colorWithHexString:@"#E9E9E9"];
    [self.menuView addSubview:lineLabel];
    
    for (NSUInteger idx = 0; idx < titles.count; idx ++) {
        UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(20 + (76 * idx), 8, 66, 30)];
        [menuButton setTitle:titles[idx] forState:(UIControlStateNormal)];
        [menuButton setTitleColor:[UIColor colorWithHexString:@"#0F0F0F"] forState:(UIControlStateNormal)];
        [menuButton setTitleColor:[UIColor colorWithHexString:kColorMain] forState:(UIControlStateSelected)];
        menuButton.titleLabel.font = [UIFont systemFontOfSize:12];
        menuButton.layer.cornerRadius = 4;
        menuButton.layer.borderWidth = 0.5;
        [menuButton addTarget:self action:@selector(menuButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        menuButton.tag = kMenuButtonTag + idx;
        [self thn_setMenuButtonStyle:menuButton selected:idx == 0];
        
        if (idx == 0) {
            menuButton.selected = YES;
            self.selectedButton = menuButton;
        }
        
        [self.menuView addSubview:menuButton];
        [self.menuButtonArr addObject:menuButton];
    }
}

- (NSMutableArray *)menuButtonArr {
    if (!_menuButtonArr) {
        _menuButtonArr = [NSMutableArray array];
    }
    return _menuButtonArr;
}

- (NSMutableArray *)categoryModelArr {
    if (!_categoryModelArr) {
        _categoryModelArr = [NSMutableArray array];
    }
    return _categoryModelArr;
}

@end
