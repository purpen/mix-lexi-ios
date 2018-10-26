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
    THNHeaderViewSelectedTypeLiked = 0, // 喜欢
    THNHeaderViewSelectedTypeCollect,
    THNHeaderViewSelectedTypeStore,
    THNHeaderViewSelectedTypeDynamic,
    THNHeaderViewSelectedTypeActivity,
    THNHeaderViewSelectedTypeOrder,
    THNHeaderViewSelectedTypeCoupon,
    THNHeaderViewSelectedTypeService,
    THNHeaderViewSelectedTypeFans,
    THNHeaderViewSelectedTypeFollow,
};

typedef NS_ENUM(NSUInteger, THNMyCenterHeaderViewType) {
    THNMyCenterHeaderViewTypeDefault = 0,   // 自己的个人中心
    THNMyCenterHeaderViewTypeOther,         // 别人的个人中心
};

@protocol THNMyCenterHeaderViewDelegate <NSObject>

@required
- (void)thn_selectedButtonType:(THNHeaderViewSelectedType)type;
@optional
- (void)thn_selectedUserHeadImage;

@end

@interface THNMyCenterHeaderView : UIView

@property (nonatomic, weak) id <THNMyCenterHeaderViewDelegate> delegate;

- (void)thn_setUserInfoModel:(THNUserModel *)model;

- (instancetype)initWithType:(THNMyCenterHeaderViewType)type;

@end
