//
//  THNCouponsCenterHeaderView.h
//  lexi
//
//  Created by FLYang on 2018/10/31.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol THNCouponsCenterHeaderViewDelegate <NSObject>

/// 选择主分类
- (void)thn_didSelectedCategoryWithIndex:(NSInteger)index categoryId:(NSString *)categoryId;
/// 选择优惠券的类型：0:同享券；1:单品券
- (void)thn_didSelectedCouponType:(NSInteger)type categoryId:(NSString *)categoryId;

@end

@interface THNCouponsCenterHeaderView : UIView

@property (nonatomic, weak) id <THNCouponsCenterHeaderViewDelegate> delegate;

- (void)thn_setCategoryData:(NSArray *)category;

@end
