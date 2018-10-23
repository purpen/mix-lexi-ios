//
//  THNLifeOrderExpressTableViewCell.h
//  lexi
//
//  Created by FLYang on 2018/10/10.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THNLifeOrderActionTableViewCell : UITableViewCell

// 物流编号
- (void)thn_setLifeOrderExpressNumber:(NSString *)number;

// 发货状态
- (void)thn_setLifeOrderExpressStatus:(NSInteger)status;

@end
