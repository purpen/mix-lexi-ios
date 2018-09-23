//
//  THNTableViewFooterView.h
//  lexi
//
//  Created by FLYang on 2018/8/22.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMyCenterHeaderView.h"

@interface THNTableViewFooterView : UIView

/**
 初始化table底部视图

 @param frame 尺寸
 @param imageName 图标名称
 @param hintText 提示文字
 @return view
 */
- (instancetype)initWithFrame:(CGRect)frame
                iconImageName:(NSString *)imageName
                     hintText:(NSString *)hintText;

/**
 设置提示文字
 
 @param text 文字内容
 @param iconName 图标名称
 */
- (void)setHintLabelText:(NSString *)text iconImageName:(NSString *)iconName;

/**
 设置提示文字副标题

 @param text 文字内容
 */
- (void)setSubHintLabelText:(NSString *)text;

/**
 设置提示文字副标题

 @param text 文字内容
 @param iconName 图标名称
 @param location 插入图标的位置
 */
- (void)setSubHintLabelText:(NSString *)text
              iconImageName:(NSString *)iconName
               iconLocation:(NSInteger)location;

/**
 根据个人中心选择查看的类型设置文字
 */
- (void)setSubHintLabelTextWithType:(THNHeaderViewSelectedType)type;

@end
