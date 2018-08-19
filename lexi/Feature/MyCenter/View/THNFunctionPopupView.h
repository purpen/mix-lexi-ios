//
//  THNFunctionPopupView.h
//  lexi
//
//  Created by FLYang on 2018/8/17.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, THNFunctionPopupViewType) {
    THNFunctionPopupViewTypeScreen = 0, // 筛选
    THNFunctionPopupViewTypeSort        // 排序
};

@interface THNFunctionPopupView : UIView

@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, assign) THNFunctionPopupViewType type;

- (void)thn_showFunctionViewWithType:(THNFunctionPopupViewType)type;

/**
 根据视图类型初始化

 @param frame 尺寸
 @param type 类型
 @return 功能视图
 */
- (instancetype)initWithFrame:(CGRect)frame functionType:(THNFunctionPopupViewType)type;
+ (instancetype)initWithFunctionType:(THNFunctionPopupViewType)type;

@end
