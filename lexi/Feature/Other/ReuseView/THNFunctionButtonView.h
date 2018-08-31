//
//  THNFunctionButtonView.h
//  lexi
//
//  Created by FLYang on 2018/8/17.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+EnumManagement.h"

@protocol THNFunctionButtonViewDelegate <NSObject>

- (void)thn_functionViewSelectedWithIndex:(NSInteger)index;

@end

@interface THNFunctionButtonView : UIView

@property (nonatomic, assign) THNGoodsListViewType goodsListType;
@property (nonatomic, weak) id <THNFunctionButtonViewDelegate> delegate;

/**
 重置指定按钮的标题

 @param index 下标
 */
- (void)thn_resetButtonTitltWithIndex:(NSInteger)index;

/**
 创建功能按钮的类型
 */
- (void)thn_createFunctionButtonWithType:(THNGoodsListViewType)type;

/**
 设置选中按钮的标题

 @param title 标题文本
 */
- (void)thn_setSelectedButtonTitle:(NSString *)title;

/**
 设置选中按钮的状态

 @param selected 是否选中
 */
- (void)thn_setFunctionButtonSelected:(BOOL)selected;

/**
 根据按钮名称初始化

 @param titles 按钮名称
 @return 功能按钮视图
 */
- (instancetype)initWithFrame:(CGRect)frame buttonTitles:(NSArray *)titles;
- (instancetype)initWithFrame:(CGRect)frame type:(THNGoodsListViewType)type;

@end
