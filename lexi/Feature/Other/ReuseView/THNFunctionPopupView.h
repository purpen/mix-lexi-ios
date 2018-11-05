//
//  THNFunctionPopupView.h
//  lexi
//
//  Created by FLYang on 2018/8/17.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+EnumManagement.h"

typedef NS_ENUM(NSUInteger, THNFunctionPopupViewType) {
    THNFunctionPopupViewTypeSort = 0,   // 排序
    THNFunctionPopupViewTypeScreen,     // 筛选
    THNFunctionPopupViewTypeProfitSort  // 利润排序
};

@protocol THNFunctionPopupViewDelegate <NSObject>

/// 关闭功能视图
- (void)thn_functionPopupViewClose;
/// “完成”按钮，回调筛选商品条件
- (void)thn_functionPopupViewScreenParams:(NSDictionary *)screenParams count:(NSInteger)count;
/// 选中排序条件
- (void)thn_functionPopupViewType:(THNFunctionPopupViewType)viewType sortType:(NSInteger)type title:(NSString *)title;

@end

@interface THNFunctionPopupView : UIView

@property (nonatomic, weak) id <THNFunctionPopupViewDelegate> delegate;

/**
店铺编号
 */
@property (nonatomic, strong) NSString *sid;

/**
 标题文字
 */
@property (nonatomic, copy) NSString *titleText;

/**
 显示分类时：父类 id
 */
@property (nonatomic, strong) NSString *categoryId;

/**
 视图类型
 */
@property (nonatomic, assign) THNFunctionPopupViewType popupViewType;

/**
 搜索关键词
 */
- (void)thn_setKeyword:(NSString *)keyword;

/**
 设置分类id 获取子分类
 */
- (void)thn_setCategoryId:(NSString *)cid;

/**
 设置子分类数据

 @param data 分类数据
 */
- (void)thn_setCategoryData:(NSArray *)data;

/**
 个人中心商品类型
 */
@property (nonatomic, assign) THNUserCenterGoodsType userGoodsType;

/**
 所在控制器来源类型
 */
- (void)thn_setViewStyleWithGoodsListType:(THNGoodsListViewType)type;

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
