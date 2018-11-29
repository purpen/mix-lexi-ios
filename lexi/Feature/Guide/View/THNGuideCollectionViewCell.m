//
//  THNGuideCollectionViewCell.m
//  lexi
//
//  Created by rhp on 2018/11/29.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGuideCollectionViewCell.h"
#import "THNBaseTabBarController.h"

@interface THNGuideCollectionViewCell ()

@property (nonatomic, strong) UIImageView *guideImageView;
@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation THNGuideCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        self.frame = frame;
        [self.contentView addSubview:self.guideImageView];
    }

    return self;
}

- (void)setGuideCellWithImage:(NSString *)imageStr withShowCloseButton:(BOOL)isShow {
    self.guideImageView.image = [UIImage imageNamed:imageStr];
    self.closeButton.hidden = isShow;
}

- (void)click {
    [UIApplication sharedApplication].keyWindow.rootViewController = [[THNBaseTabBarController alloc] init];
    CATransition *animal = [CATransition animation];
    animal.duration = 0.5;
    animal.type = @"fade";
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:animal forKey:nil];
}

#pragma mark -lazy

- (UIImageView *)guideImageView {
    if (!_guideImageView) {
        _guideImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    }
    return _guideImageView;
}

-(UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton  buttonWithType:UIButtonTypeCustom];
        [_closeButton addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

@end
