//
//  THNShareActionView.m
//  lexi
//
//  Created by FLYang on 2018/10/16.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNShareActionView.h"
#import "UIColor+Extension.h"
#import "THNMarco.h"
#import "UIView+Helper.h"

static NSInteger const kActionButtonTag = 2352;

@interface THNShareActionView ()

@property (nonatomic, strong) NSMutableArray *actionButtonArr;
@property (nonatomic, strong) NSArray *titlesArr;
@property (nonatomic, strong) NSArray *imagesArr;

@end

@implementation THNShareActionView

- (instancetype)initWithFrame:(CGRect)frame type:(THNShareActionViewType)type {
    self = [super initWithFrame:frame];
    if (self) {
        self.titlesArr = [self thn_getTitlesWithType:type];
        self.imagesArr = [self thn_getImagesWithType:type];
        [self setupViewUI];
    }
    return self;
}

#pragma mark - event response
- (void)actionButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_shareView:didSelectedShareActionIndex:)]) {
        [self.delegate thn_shareView:self didSelectedShareActionIndex:button.tag - kActionButtonTag];
    }
}

#pragma mark - private methods
- (NSArray *)thn_getTitlesWithType:(THNShareActionViewType)type {
    NSArray *titles = @[@[@"微信", @"朋友圈", @"微博", @"QQ", @"QQ空间"],
                        @[@"更多分享"],
                        @[@"保存海报", @"更多分享"]];
    
    return titles[(NSUInteger)type];
}

- (NSArray *)thn_getImagesWithType:(THNShareActionViewType)type {
    NSArray *images = @[@[@"icon_share_wechat", @"icon_share_timeline", @"icon_share_weibo", @"icon_share_qq", @"icon_share_qq_space"],
                        @[@"icon_share_more"],
                        @[@"icon_share_image", @"icon_share_more"]];
    
    return images[(NSUInteger)type];
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self thn_creatActionButtonWithTitles:self.titlesArr iconImages:self.imagesArr];
}

- (void)drawRect:(CGRect)rect {
    [UIView drawRectLineStart:CGPointMake(0, CGRectGetHeight(self.frame))
                          end:CGPointMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))
                        width:1
                        color:[UIColor colorWithHexString:@"#E9E9E9"]];
}

#pragma mark - getters and setters
- (void)thn_creatActionButtonWithTitles:(NSArray *)titles iconImages:(NSArray *)iconImages {
    CGFloat originX = (CGRectGetWidth(self.frame) - 30) / 5;
    originX += (originX - 50) / 4;
    CGFloat itemH = CGRectGetHeight(self.frame);
    
    for (NSUInteger idx = 0; idx < titles.count; idx ++) {
        UIButton *actionButton = [[UIButton alloc] initWithFrame:CGRectMake(15 + originX * idx, 0, 50, itemH)];
        [actionButton setTitle:titles[idx] forState:(UIControlStateNormal)];
        [actionButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateNormal)];
        [actionButton setTitleEdgeInsets:(UIEdgeInsetsMake(70, -50, 0, 0))];
        actionButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [actionButton setImage:[UIImage imageNamed:iconImages[idx]] forState:(UIControlStateNormal)];
        [actionButton setImage:[UIImage imageNamed:iconImages[idx]] forState:(UIControlStateHighlighted)];
        actionButton.imageView.contentMode = UIViewContentModeCenter;
        [actionButton setImageEdgeInsets:(UIEdgeInsetsMake(-25, 0, 0, 0))];
        actionButton.tag = kActionButtonTag + idx;
        [actionButton addTarget:self action:@selector(actionButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self addSubview:actionButton];
        [self.actionButtonArr addObject:actionButton];
    }
}

- (NSMutableArray *)actionButtonArr {
    if (!_actionButtonArr) {
        _actionButtonArr = [NSMutableArray array];
    }
    return _actionButtonArr;
}

@end
