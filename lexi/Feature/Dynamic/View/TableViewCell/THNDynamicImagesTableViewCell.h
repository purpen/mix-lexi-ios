//
//  THNDynamicImagesTableViewCell.h
//  lexi
//
//  Created by FLYang on 2018/11/13.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNDynamicModelLines.h"

@interface THNDynamicImagesTableViewCell : UITableViewCell

@property (nonatomic, weak) UITableView *tableView;

- (void)thn_setDynamicImagesWithModel:(THNDynamicModelLines *)model;

+ (instancetype)initDynamicImagesCellWithTableView:(UITableView *)tableView;

@end
