//
//  THNOrderDetailLogisticsView.h
//  lexi
//
//  Created by HongpingRao on 2018/9/6.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THNOrderDetailModel;
@class THNAddressModel;

@interface THNOrderDetailLogisticsView : UIView

@property (nonatomic, strong) THNOrderDetailModel *detailModel;
@property (nonatomic, strong) THNAddressModel *addressModel;

@end
