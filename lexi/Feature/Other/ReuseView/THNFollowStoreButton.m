//
//  THNFollowStoreButton.m
//  lexi
//
//  Created by FLYang on 2018/8/22.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNFollowStoreButton.h"
#import "UIColor+Extension.h"
#import "THNConst.h"

static NSString *const kTitleNormal     = @"关注";
static NSString *const kTitleSelected   = @"已关注";

@implementation THNFollowStoreButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

- (instancetype)initWithType:(THNFollowButtonType)type {
    self = [super init];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

#pragma mark - public methods
- (void)setFollowStoreStatus:(BOOL)follow {
    self.selected = follow;
    [self setTitleEdgeInsets:(UIEdgeInsetsMake(0, self.selected ? 0 : 5, 0, 0))];
    self.backgroundColor = [UIColor colorWithHexString:follow ? @"#EFF3F2" : kColorMain];
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.selected = NO;
    [self setTitle:kTitleNormal forState:(UIControlStateNormal)];
    [self setTitle:kTitleSelected forState:(UIControlStateSelected)];
    [self setTitleColor:[UIColor colorWithHexString:kColorWhite] forState:(UIControlStateNormal)];
    [self setTitleColor:[UIColor colorWithHexString:@"#949EA6"] forState:(UIControlStateSelected)];
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    [self setImage:[UIImage imageNamed:@"icon_store_feature"] forState:(UIControlStateNormal)];
    [self setImage:[UIImage new] forState:(UIControlStateSelected)];
    [self setImageEdgeInsets:(UIEdgeInsetsMake(8, -1, 8, 0))];
}

@end
