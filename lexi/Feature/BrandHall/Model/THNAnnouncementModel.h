//
//  THNAnnouncementModel.h
//  lexi
//
//  Created by HongpingRao on 2018/8/29.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THNAnnouncementModel : NSObject

// 公告内容
@property (nonatomic, strong) NSString *announcement;
// 休馆开始时间
@property (nonatomic, strong) NSString *begin_date;
// 恢复发货时间
@property (nonatomic, strong) NSString *delivery_date;
// 休馆结束时间
@property (nonatomic, strong) NSString *end_date;
// 是否休馆
@property (nonatomic, assign) BOOL is_closed;

@end
