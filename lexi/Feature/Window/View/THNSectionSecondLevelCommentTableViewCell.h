//
//  THNSectionSecondLevelCommentTableViewCell.h
//  lexi
//
//  Created by HongpingRao on 2018/11/7.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THNCommentModel;

@interface THNSectionSecondLevelCommentTableViewCell : UITableViewCell

@property (nonatomic, strong) THNCommentModel *subCommentModel;
@property (nonatomic, assign) NSInteger subCommentCount;

@end
