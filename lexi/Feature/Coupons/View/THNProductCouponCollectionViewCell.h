//
//  THNProductCouponCollectionViewCell.h
//  lexi
//
//  Created by FLYang on 2018/11/2.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNCouponSingleModel.h"

@interface THNProductCouponCollectionViewCell : UICollectionViewCell

/**
 单个商品的优惠券（单享券）
 */
- (void)thn_setProductCouponModel:(THNCouponSingleModel *)model;

@end
