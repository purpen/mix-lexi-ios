//
//  THNAdvertCouponTableViewCell.h
//  lexi
//
//  Created by FLYang on 2018/11/27.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THNAdvertCouponTableViewCell : UITableViewCell

/**
 新人1000元优惠券的信息

 @param amount 优惠券金额
 @param minAmount 满足金额
 @param typeText 可使用的分类类型
 */
- (void)thn_setAdvertCouponAmount:(CGFloat)amount minAmount:(CGFloat)minAmount typeText:(NSString *)typeText;

@end
