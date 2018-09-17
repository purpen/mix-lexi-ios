//
//  THNPreViewTableViewCell.h
//  lexi
//
//  Created by HongpingRao on 2018/9/14.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THNCouponModel;

@interface THNPreViewTableViewCell : UITableViewCell

- (CGFloat)setPreViewCell:(NSArray *)skus
      initWithItmeSkus:(NSArray *)itemSkus
   initWithCouponModel:(THNCouponModel *)couponModel
       initWithFreight:(CGFloat)freight;

@end
