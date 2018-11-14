//
//  THNDynamicActionTableViewCell+Action.h
//  lexi
//
//  Created by FLYang on 2018/11/14.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNDynamicActionTableViewCell.h"

@interface THNDynamicActionTableViewCell (Action)

/**
 喜欢动态橱窗
 */
- (void)thn_likeDynamicWithStatusWithModel:(THNDynamicModelLines *)model;

/**
 查看橱窗评论
 */
- (void)thn_checkDynamicComment;

@end
