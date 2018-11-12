//
//  THNCommentModel.h
//  lexi
//
//  Created by HongpingRao on 2018/10/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface THNCommentModel : NSObject

@property (nonatomic, assign) NSInteger comment_id;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *created_at;
// 是否点赞
@property (nonatomic, assign) BOOL is_praise;
@property (nonatomic, strong) NSArray *sub_comments;
// 子评论数
@property (nonatomic, assign) NSInteger sub_comment_count;
@property (nonatomic, assign) NSInteger praise_count;
@property (nonatomic, strong) NSString *user_avatar;
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, assign) CGFloat height;
// 剩余子评论数量
@property (nonatomic, assign) NSInteger remain_count;

@end
