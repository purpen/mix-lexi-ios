//
//  THNCenterProductTableViewCell.h
//  lexi
//
//  Created by HongpingRao on 2018/8/24.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THNCenterProductTableViewCell;

@protocol THNCenterProductTableViewCellDelegate<NSObject>

@optional
- (void)shelf:(THNCenterProductTableViewCell *)cell;
- (void)sell;

@end

@class THNProductModel;


@interface THNCenterProductTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (nonatomic, strong) THNProductModel *productModel;
@property (nonatomic, weak) id <THNCenterProductTableViewCellDelegate>delegate;

@end
