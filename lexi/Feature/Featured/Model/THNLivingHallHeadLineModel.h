//
//  THNLivingHallHeadLineModel.h
//  lexi
//
//  Created by HongpingRao on 2018/9/25.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 展示开馆头条类型
 
 - HeadlineShowTypeOpen: 开馆
 - HeadlineShowTypeFormal: 售出三单成为正式馆主
 - HeadlineShowTypeNumber: 售出单数
 */
typedef NS_ENUM(NSUInteger, HeadlineShowType) {
    HeadlineShowTypeOpen,
    HeadlineShowTypeFormal,
    HeadlineShowTypeNumber,
};


@interface THNLivingHallHeadLineModel : NSObject

// 事件类型 1: 开通生活馆; 2: 售出3单成为正式馆主; 3: 售出1个订单 4: 售出数量
@property (nonatomic, assign) HeadlineShowType event;
@property (nonatomic, strong) NSString *time;
// 时间后缀
@property (nonatomic, strong) NSString *time_info;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, assign) NSInteger quantity;

@end
