//
//  THNFunctionButtonView.h
//  lexi
//
//  Created by FLYang on 2018/8/17.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol THNFunctionButtonViewDelegate <NSObject>

@required
- (void)thn_functionButtonSelectedWithIndex:(NSInteger)index;

@end

@interface THNFunctionButtonView : UIView

@property (nonatomic, weak) id <THNFunctionButtonViewDelegate> delegate;

/**
 根据按钮名称初始化

 @param titles 按钮名称
 @return 功能按钮视图
 */
- (instancetype)initWithFrame:(CGRect)frame buttonTitles:(NSArray *)titles;

@end
