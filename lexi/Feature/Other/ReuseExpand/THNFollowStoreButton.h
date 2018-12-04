//
//  THNFollowStoreButton.h
//  lexi
//
//  Created by FLYang on 2018/8/22.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNStoreModel.h"
#import "THNFeaturedBrandModel.h"
#import "THNOffcialStoreModel.h"
#import "THNGrassListModel.h"

typedef NS_ENUM(NSUInteger, THNFollowButtonType) {
    THNFollowButtonTypeExplore = 0,     // 探索页面
    THNFollowButtonTypeStoreInfo,       // 品牌馆详情页面
    THNFollowButtonTypeStoreList,       // 个人中心关注设计馆列表
    THNFollowButtonTypeGoodsInfo,       // 商品详情
    THNFollowButtonTypeArticle,         // 文章中
    THNFollowButtonTypeSearch,          // 搜索列表
};

typedef void(^FollowStoreButtonBlock)(BOOL isFollow);

@interface THNFollowStoreButton : UIButton

/**
 店铺 id
 */
@property (nonatomic, strong) NSString *storeId;

/**
 店铺数据
 */
@property (nonatomic, strong) THNStoreModel *storeModel;
@property (nonatomic, strong) THNFeaturedBrandModel *brandModel;
@property (nonatomic, strong) THNOffcialStoreModel *offcialStoreModel;
@property (nonatomic, strong) THNGrassListModel *grassListModel;

/**
 颜色
 */
@property (nonatomic, strong) UIColor *normalTitleColor;
@property (nonatomic, strong) UIColor *selectedTitleColor;
@property (nonatomic, strong) UIColor *normalBgColor;
@property (nonatomic, strong) UIColor *selectedBgColor;

/**
 根据加载的页面创建
 */
- (instancetype)initWithType:(THNFollowButtonType)type;

/**
 设置关注的状态
 
 @param follow 是否关注
 */
- (void)setFollowStoreStatus:(BOOL)follow;

/**
 加载动画
 */
- (void)startLoading;
- (void)endLoading;

- (void)setupViewUI;

@property (nonatomic, copy) FollowStoreButtonBlock followStoreBlock;

/**
 是否需要通知外部界面刷新
 */
@property (nonatomic, assign) BOOL isNeedRefresh;

@end
