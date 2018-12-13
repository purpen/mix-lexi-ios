//
//  THNCashHintView.h
//  lexi
//
//  Created by FLYang on 2018/12/11.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, THNCashHintViewType) {
    THNCashHintViewTypeNotes = 0,   // 注意事项
    THNCashHintViewTypeQuery,       // 到账查询
};

@interface THNCashHintView : UIView

/**
 改变提现的到账时间
 */
- (void)thn_changeCashMoneyTime:(BOOL)change;

- (instancetype)initWithType:(THNCashHintViewType)type;

@end
