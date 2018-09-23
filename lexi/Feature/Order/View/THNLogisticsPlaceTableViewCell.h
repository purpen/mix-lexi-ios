//
//  THNLogisticsPlaceTableViewCell.h
//  lexi
//
//  Created by FLYang on 2018/9/11.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THNLogisticsPlaceTableViewCell : UITableViewCell

/**
 发货地
 */
@property (nonatomic, strong) NSString *place;

+ (instancetype)initPlaceCellWithTableView:(UITableView *)tableView;

@end
