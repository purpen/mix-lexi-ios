//
//  THNObtainedView.m
//  lexi
//
//  Created by HongpingRao on 2018/8/8.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNObtainedView.h"
#import "UIView+Helper.h"

@interface THNObtainedView()

@property (weak, nonatomic) IBOutlet UIView *backGroundView;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@end

@implementation THNObtainedView

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.backGroundView drawCornerWithType:0 radius:4];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeFromSuperview];
}

- (instancetype)show:(NSString *)title
withRightButtonTitle:(NSString *)rightButtonTitle
 withLeftButtonTitle:(NSString *)leftButtonTitle {
    
    THNObtainedView *obtainedView = [THNObtainedView viewFromXib];
    self.titleLabel.text = title;
    [self.leftButton setTitle:leftButtonTitle forState:UIControlStateNormal];
    [self.rightButton setTitle:rightButtonTitle forState:UIControlStateNormal];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    obtainedView.frame = window.bounds;
    [window addSubview:obtainedView];
    return obtainedView;
}

- (IBAction)clickLeftButton:(id)sender {
    if (self.obtainedleftBlock) {
        self.obtainedleftBlock();
    }
    [self removeFromSuperview];
}

- (IBAction)clickRightButton:(id)sender {
    if (self.obtainedRightBlock) {
        self.obtainedRightBlock();
    }
    [self removeFromSuperview];
}



#pragma mark - shared
static id _instance = nil;

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_instance) {
            _instance = [[self alloc] init];
        }
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

@end
