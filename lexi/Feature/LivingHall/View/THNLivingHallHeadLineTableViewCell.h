//
//  THNLivingHallHeadLineTableViewCell.h
//  lexi
//
//  Created by HongpingRao on 2018/12/14.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THNLivingHallHeadLineModel;

UIKIT_EXTERN NSString *const livingHallHeadLineCellIdentifier;

@interface THNLivingHallHeadLineTableViewCell : UITableViewCell

@property (nonatomic, strong) THNLivingHallHeadLineModel *headLineModel;

@end
