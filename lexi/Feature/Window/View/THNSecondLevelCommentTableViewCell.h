//
//  THNSecondLevelCommentTableViewCell.h
//  lexi
//
//  Created by HongpingRao on 2018/8/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THNCommentModel;

@interface THNSecondLevelCommentTableViewCell : UITableViewCell

@property (nonatomic, strong) THNCommentModel *subCommentModel;

@end
