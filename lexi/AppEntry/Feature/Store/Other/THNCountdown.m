//
//  THNCountdown.m
//  lexi
//
//  Created by FLYang on 2018/10/9.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNCountdown.h"

@interface THNCountdown ()

@property (nonatomic, retain) dispatch_source_t timer;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;

@end

@implementation THNCountdown

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        
        NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
        [self.dateFormatter setTimeZone:localTimeZone];
    }
    return self;
}

- (void)thn_countDownWithStratTimeStamp:(long long)starTimeStamp
                        finishTimeStamp:(long long)finishTimeStamp
                          completeBlock:(void (^)(NSInteger day,NSInteger hour,NSInteger minute,NSInteger second))completeBlock {
    
    if (!self.timer) {
        NSDate *finishDate = [self thn_dateWithLong:finishTimeStamp];
        NSDate *startDate = [self thn_dateWithLong:starTimeStamp];
        NSTimeInterval timeInterval =[finishDate timeIntervalSinceDate:startDate];
        __block int timeout = timeInterval; // 倒计时时间
        
        if (timeout != 0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            
            dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(self.timer, ^{
                if(timeout <= 0) { // 倒计时结束，关闭
                    dispatch_source_cancel(self.timer);
                    self.timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completeBlock(0, 0, 0, 0);
                    });
                    
                } else {
                    int days = (int)(timeout / (3600 * 24));
                    int hours = (int)((timeout - days * 24 * 3600) / 3600);
                    int minute = (int)(timeout - days * 24 * 3600 - hours * 3600) / 60;
                    int second = timeout - days * 24 * 3600 - hours * 3600 - minute * 60;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completeBlock(days, hours, minute, second);
                    });
                    
                    timeout --;
                }
            });
            
            dispatch_resume(self.timer);
        }
    }
}

- (void)destoryTimer {
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

#pragma mark - private methods
- (NSDate *)thn_dateWithLong:(long long)longValue {
    long long value = longValue / 1000;
    
    NSNumber *time = [NSNumber numberWithLongLong:value];
    NSTimeInterval nsTimeInterval = [time longLongValue];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:nsTimeInterval];
    
    return date;
}

@end
