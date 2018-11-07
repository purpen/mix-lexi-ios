//
//  THNStoreCouponCollectionViewCell.h
//  lexi
//
//  Created by FLYang on 2018/11/2.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNCouponSharedModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface THNStoreCouponCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) UIViewController *currentVC;

/**
 设置品牌馆（同享券）优惠券
 
 @param model 数据模型
 */
- (void)thn_setStoreCouponModel:(THNCouponSharedModel *)model;

@end

NS_ASSUME_NONNULL_END
