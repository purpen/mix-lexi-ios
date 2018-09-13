//
//  THNLogisticsTableViewCell.h
//  lexi
//
//  Created by rhp on 2018/9/9.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THNLogisticsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *informationLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logisticsImageView;
@property (weak, nonatomic) IBOutlet UIView *topLineView;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@end
