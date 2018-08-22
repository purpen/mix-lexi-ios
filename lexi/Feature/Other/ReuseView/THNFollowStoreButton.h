//
//  THNFollowStoreButton.h
//  lexi
//
//  Created by FLYang on 2018/8/22.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, THNFollowStoreButtonType) {
    THNFollowStoreButtonTypeExplore = 0,    // 探索页面
    THNFollowStoreButtonTypeInfo,           // 品牌馆详情页面
    THNFollowStoreButtonTypeList            // 个人中心关注列表
};

@interface THNFollowStoreButton : UIButton

/**
 店铺 id
 */
@property (nonatomic, assign) NSInteger storeId;

/**
 根据加载的页面创建
 */
- (instancetype)initWithType:(THNFollowStoreButtonType)type;

/**
 设置关注的状态
 
 @param follow 是否关注
 */
- (void)setFollowStoreStatus:(BOOL)follow;

@end
