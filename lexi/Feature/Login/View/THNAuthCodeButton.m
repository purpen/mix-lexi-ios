//
//  THNAuthCodeButton.m
//  lexi
//
//  Created by FLYang on 2018/7/23.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNAuthCodeButton.h"
#import "UIColor+Extension.h"
#import "UIView+Helper.h"

static NSString *const kTitleTextDefault    = @"获取动态码";
static NSString *const kTitleTextCircle     = @"获取验证码";
static NSString *const kAuthCodeRemainTime  = @" 重新获取";
static NSString *const kAuthCodeRegainTitle = @"重新获取";

@interface THNAuthCodeButton ()

@end

@implementation THNAuthCodeButton

- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0, 120, 46)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:kTitleTextDefault forState:(UIControlStateNormal)];
        [self setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateNormal)];
        self.titleLabel.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightRegular)];
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return self;
}

- (instancetype)initWithType:(THNAuthCodeButtonType)type {
    self = [super init];
    if (self) {
        if (type == THNAuthCodeButtonTypeDefault) {
            [self setupDefaultViewUI];
        } else {
            [self setupCircleViewUI];
        }
    }
    return self;
}

// 默认视图
- (void)setupDefaultViewUI {
    self.frame = CGRectMake(0, 0, 120, 46);
    [self setTitle:kTitleTextDefault forState:(UIControlStateNormal)];
    [self setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateNormal)];
    self.titleLabel.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightRegular)];
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
}

// 圆角视图
- (void)setupCircleViewUI {
    self.frame = CGRectMake(0, 9, 80, 26);
    [self setTitle:kTitleTextCircle forState:(UIControlStateNormal)];
    [self setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:(UIControlStateNormal)];
    self.titleLabel.font = [UIFont systemFontOfSize:11 weight:(UIFontWeightRegular)];
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    self.layer.borderWidth = 0.5;
    self.layer.cornerRadius = CGRectGetHeight(self.frame)/2;
}

// 倒计时器
- (void)thn_countdownStartTime:(NSTimeInterval)startTime completion:(void (^)(THNAuthCodeButton *))completion {
    __weak typeof(self) weakSelf = self;
    __block NSInteger remainTime = startTime;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    
    dispatch_source_set_event_handler(timer, ^{
        if (remainTime <= 0) {
            dispatch_source_cancel(timer);
            // 回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf setTitle:kAuthCodeRegainTitle forState:UIControlStateNormal];
                [weakSelf setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateNormal)];
                weakSelf.enabled = YES;
                
                if (completion) {
                    completion(weakSelf);
                }
            });
            
        } else {
            NSString *timeStr = [NSString stringWithFormat:@"%ld", remainTime];
            // 回到主线程更新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf setTitle:[NSString stringWithFormat:@"%@s%@", timeStr, kAuthCodeRemainTime] forState:UIControlStateDisabled];
                [weakSelf setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:(UIControlStateNormal)];
                weakSelf.enabled = NO;
            });
            remainTime--;
        }
    });
    
    dispatch_resume(timer);
}

@end
