//
//  THNCouponsCenterHeaderView.m
//  lexi
//
//  Created by FLYang on 2018/10/31.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNCouponsCenterHeaderView.h"
#import "UIColor+Extension.h"
#import "THNMarco.h"

@interface THNCouponsCenterHeaderView ()

@property (nonatomic, strong) UIImageView *headerImageView;

@end

@implementation THNCouponsCenterHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#FFBD9F"];
    
    [self addSubview:self.headerImageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.frame = CGRectMake(-15, 0, SCREEN_WIDTH, 150);
    
    self.headerImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 150);
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

@end
