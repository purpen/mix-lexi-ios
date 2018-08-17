//
//  THNMyCenterHeaderView.h
//  lexi
//
//  Created by FLYang on 2018/8/15.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNUserModel.h"

typedef NS_ENUM(NSUInteger, THNHeaderViewSelectedType) {
    THNHeaderViewSelectedTypeLiked = 0,
    THNHeaderViewSelectedTypeCollect,
    THNHeaderViewSelectedTypeStore,
    THNHeaderViewSelectedTypeDynamic,
    THNHeaderViewSelectedTypeActivity,
    THNHeaderViewSelectedTypeOrder,
    THNHeaderViewSelectedTypeCoupon,
    THNHeaderViewSelectedTypeService
};

@protocol THNMyCenterHeaderViewDelegate <NSObject>

@required
- (void)thn_selectedButtonType:(THNHeaderViewSelectedType)type;

@end

@interface THNMyCenterHeaderView : UIView

@property (nonatomic, weak) id <THNMyCenterHeaderViewDelegate> delegate;

- (void)thn_setUserInfoModel:(THNUserModel *)model;

@end
