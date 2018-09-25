//
//  THNPreViewTableViewCell.h
//  lexi
//
//  Created by HongpingRao on 2018/9/14.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THNCouponModel;
@class THNFreightModelItem;

UIKIT_EXTERN const CGFloat kProductViewHeight;
UIKIT_EXTERN const CGFloat kLogisticsViewHeight;

typedef void(^PreViewCellBlock)(NSMutableArray *skuIds, NSString *fid, NSInteger storeIndex);

@interface THNPreViewTableViewCell : UITableViewCell


- (CGFloat)setPreViewCell:(NSArray *)skus
      initWithItmeSkus:(NSArray *)itemSkus
   initWithCouponModel:(THNCouponModel *)couponModel
          initWithFreight:(CGFloat)freight
          initWithCoupons:(NSArray *)coupons
   initWithLogisticsNames:(THNFreightModelItem *)freightModel;

@property (nonatomic, copy) PreViewCellBlock preViewCellBlock;

// 运费
@property (weak, nonatomic) IBOutlet UILabel *freightLabel;


@end
