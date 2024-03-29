//
//  THNPreViewTableViewCell.h
//  lexi
//
//  Created by HongpingRao on 2018/9/14.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNCouponModel.h"

@class THNFreightModelItem;

UIKIT_EXTERN const CGFloat kProductViewHeight;
UIKIT_EXTERN const CGFloat kLogisticsViewHeight;

@protocol THNPreViewTableViewCellDelegate<NSObject>

@optional
- (void)selectLogistic:(NSMutableArray *)skuIds
               WithFid:(NSString *)fid
        withStoreIndex:(NSInteger)storeIndex;
- (void)updateTotalCouponAcount:(CGFloat)amount withCode:(NSString *)code withTag:(NSInteger)tag;
- (void)setRemarkWithGift:(NSString *)remarkStr withGift:(NSString *)giftStr withTag:(NSInteger)tag;

@end

@interface THNPreViewTableViewCell : UITableViewCell


- (CGFloat)setPreViewCell:(NSArray *)skus
      initWithItmeSkus:(NSArray *)itemSkus
   initWithCouponModel:(THNCouponModel *)fullReductionModel
          initWithFreight:(CGFloat)freight
          initWithStoreInformations:(NSArray *)storeInformations
        initWithproducts:(NSArray *)products
           initWithRemark:(NSString *)remarkStr
             initWithGift:(NSString *)giftStr;

@property (nonatomic,weak) id <THNPreViewTableViewCellDelegate> delagate;

// 运费
@property (weak, nonatomic) IBOutlet UILabel *freightLabel;
@property (nonatomic, assign) ShowCouponStyleType couponStyleType;
@property (nonatomic, assign) CGFloat selectStoreAmount;

@end
