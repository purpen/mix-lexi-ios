//
//  THNAdvertCouponView.h
//  lexi
//
//  Created by FLYang on 2018/11/27.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol THNAdvertCouponViewDelegate <NSObject>

@required
- (void)thn_advertViewClose;
- (void)thn_advertGetCoupon;

@end

@interface THNAdvertCouponView : UIView

@property (nonatomic, weak) id <THNAdvertCouponViewDelegate> delegate;

@end
