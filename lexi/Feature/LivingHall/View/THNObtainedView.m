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
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation THNObtainedView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.backGroundView drawCornerWithType:0 radius:4];
}

- (instancetype)show {
    THNObtainedView *obtainedView = [THNObtainedView viewFromXib];
    if (self.title.length > 0) {
         self.titleLabel.text = self.title;
    }
   
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    obtainedView.frame = window.bounds;
    [window addSubview:obtainedView];
    return obtainedView;
}

- (IBAction)delete:(id)sender {
    if (self.obtainedBlock) {
        self.obtainedBlock();
    }
    [self removeFromSuperview];
}

- (IBAction)cancel:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)close:(id)sender {
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
