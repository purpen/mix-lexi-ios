//
//  THNOrderProductTableViewCell.h
//  lexi
//
//  Created by HongpingRao on 2018/9/6.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THNOrdersItemsModel;

@interface THNOrderProductTableViewCell : UITableViewCell

@property (nonatomic, strong) THNOrdersItemsModel *itemModel;
@property (weak, nonatomic) IBOutlet UIButton *borderButton;

@end
