//
//  THNCommentTableViewCell.h
//  lexi
//
//  Created by HongpingRao on 2018/8/23.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LookCommentBlock)(void);

@interface THNCommentTableViewCell : UITableViewCell

- (void)setComments:(NSArray *)comments
initWithSubComments:(NSMutableArray *)subComments
        initWithRid:(NSString *)rid;

@end
