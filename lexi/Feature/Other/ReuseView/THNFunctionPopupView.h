//
//  THNFunctionPopupView.h
//  lexi
//
//  Created by FLYang on 2018/8/17.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, THNFunctionPopupViewType) {
    THNFunctionPopupViewTypeSort = 0,   // 排序
    THNFunctionPopupViewTypeScreen,     // 筛选
};

typedef NS_ENUM(NSUInteger, THNScreenRecommandType) {
    THNScreenRecommandTypeDefault = 0,   // 默认
    THNScreenRecommandTypeUserGoods,     // 个人中心
};

@interface THNFunctionPopupView : UIView

@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, assign) THNFunctionPopupViewType type;

/**
 设置分类id 获取子分类
 */
- (void)thn_setCategoryId:(NSInteger)cid;

/**
 设置子分类数据

 @param data 分类数据
 */
- (void)thn_setCategoryData:(NSArray *)data;

/**
 设置推荐类型
 */
- (void)thn_setRecommandType:(THNScreenRecommandType)type;

/**
 显示视图的类型
 */
- (void)thn_showFunctionViewWithType:(THNFunctionPopupViewType)type;

/**
 设置“查看商品”的文字内容
 
 @param count 商品数量
 @param show 是否显示
 */
- (void)thn_setDoneButtonTitleWithGoodsCount:(NSInteger)count show:(BOOL)show;

/**
 根据视图类型初始化

 @param frame 尺寸
 @param type 类型
 @return 功能视图
 */
- (instancetype)initWithFrame:(CGRect)frame functionType:(THNFunctionPopupViewType)type;
- (instancetype)initWithFunctionType:(THNFunctionPopupViewType)type;

@end
