//
//  THNOrderDetailProductView.h
//  mixcash
//
//  Created by HongpingRao on 2018/9/6.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNOrdersModel.h"

@class THNOrderDetailModel;

@interface THNOrderDetailProductView : UIView

- (CGFloat)setOrderDetailPayView:(THNOrderDetailModel *)detailModel;

@end
