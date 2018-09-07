//
//  THNOrderTableViewCell.h
//  lexi
//
//  Created by HongpingRao on 2018/9/6.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THNOrdersModel;
@class THNOrderTableViewCell;

typedef void(^CountDownBlock)(THNOrderTableViewCell *cell);

UIKIT_EXTERN CGFloat orderProductCellHeight;
UIKIT_EXTERN CGFloat orderCellLineSpacing;

@interface THNOrderTableViewCell : UITableViewCell

@property (nonatomic, strong) THNOrdersModel *ordersModel;

@property (nonatomic, copy) CountDownBlock countDownBlock;

@end
