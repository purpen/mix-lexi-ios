//
//  THNSecondLevelCommentTableViewCell.h
//  lexi
//
//  Created by HongpingRao on 2018/8/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THNSecondLevelCommentTableViewCell;

@class THNCommentModel;

extern CGFloat const loadViewHeight;
extern CGFloat const allSubCommentHeight;

typedef void(^SecondLevelBlock)(THNSecondLevelCommentTableViewCell *cell);
typedef void(^SecondLevelLookUserBlock)(NSString *uid);

@interface THNSecondLevelCommentTableViewCell : UITableViewCell

@property (nonatomic, strong) THNCommentModel *subCommentModel;
@property (nonatomic, assign) BOOL isHiddenLoadMoreDataView;
@property (nonatomic, strong) THNCommentModel *commentModel;
@property (nonatomic, copy) SecondLevelBlock secondLevelBlock;
@property (nonatomic, copy) SecondLevelLookUserBlock secondLevelLookUserBlock;
@property (nonatomic, assign) BOOL isShopWindow;
@property (nonatomic, assign) NSInteger page;


@end
