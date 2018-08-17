//
//  THNTableViewSectionHeaderView.h
//  lexi
//
//  Created by FLYang on 2018/8/15.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THNTableViewSectionHeaderView : UIView

/**
 标题文字
 */
@property (nonatomic, strong) NSString *title;

/**
 查看更多按钮
 */
@property (nonatomic, strong) UIButton *moreButton;

/**
 是否显示‘更多’按钮
 */
- (void)showMoreButton:(BOOL)show;

@end
