//
//  THNGoodsListViewController.h
//  lexi
//
//  Created by FLYang on 2018/8/27.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNBaseViewController.h"
#import "NSObject+EnumManagement.h"

@interface THNGoodsListViewController : THNBaseViewController

/**
 根据类型创建商品列表视图

 @param type 列表类型
 @param title 页面名称
 @return self
 */
- (instancetype)initWithGoodsListType:(THNGoodsListViewType)type title:(NSString *)title;

/**
 根据分类 id 创建

 @param categoryId 分类 id
 @param name 分类名称
 @return self
 */
- (instancetype)initWithCategoryId:(NSString *)categoryId categoryName:(NSString *)name;

/**
 用户个人中心查看商品

 @param type 查看商品类型
 @param title 页面名称
 @param userId 用户id
 @return self
 */
- (instancetype)initWithUserCenterGoodsType:(THNUserCenterGoodsType)type title:(NSString *)title userId:(NSString *)userId;

@end
