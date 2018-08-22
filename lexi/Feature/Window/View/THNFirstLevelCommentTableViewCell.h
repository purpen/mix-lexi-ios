//
//  THNFirstLevelCommentTableViewCell.h
//  lexi
//
//  Created by HongpingRao on 2018/8/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THNFirstLevelCommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentlabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewConstraint;
@property (nonatomic, strong) NSArray *array;

@end
