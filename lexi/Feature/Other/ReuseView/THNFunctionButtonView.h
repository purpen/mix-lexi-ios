//
//  THNFunctionButtonView.h
//  lexi
//
//  Created by FLYang on 2018/8/17.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class THNFunctionButtonView;

typedef NS_ENUM(NSUInteger, THNFunctionButtonViewType) {
    THNFunctionButtonViewTypeDefault = 0,   //  默认商品
    THNFunctionButtonViewTypeUserGoods,     //  用户商品
    THNFunctionButtonViewTypeStore,         //  品牌馆
};

@protocol THNFunctionButtonViewDelegate <NSObject>

- (void)thn_functionViewSelectedWithIndex:(NSInteger)index;

@end

@interface THNFunctionButtonView : UIView

@property (nonatomic, assign) THNFunctionButtonViewType type;
@property (nonatomic, weak) id <THNFunctionButtonViewDelegate> delegate;

/**
 创建功能按钮的类型
 */
- (void)thn_createFunctionButtonWithType:(THNFunctionButtonViewType)type;

/**
 根据按钮名称初始化

 @param titles 按钮名称
 @return 功能按钮视图
 */
- (instancetype)initWithFrame:(CGRect)frame buttonTitles:(NSArray *)titles;
- (instancetype)initWithFrame:(CGRect)frame type:(THNFunctionButtonViewType)type;

@end
