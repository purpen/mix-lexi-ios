//
//  THNFollowStoreButton.h
//  lexi
//
//  Created by FLYang on 2018/8/22.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, THNFollowButtonType) {
    THNFollowButtonTypeExplore = 0,     // 探索页面
    THNFollowButtonTypeStoreInfo,       // 品牌馆详情页面
    THNFollowButtonTypeStoreList        // 个人中心关注设计馆列表
};

@interface THNFollowStoreButton : UIButton

/**
 店铺 id
 */
@property (nonatomic, assign) NSInteger storeId;

/**
 根据加载的页面创建
 */
- (instancetype)initWithType:(THNFollowButtonType)type;

/**
 设置关注的状态
 
 @param follow 是否关注
 */
- (void)setFollowStoreStatus:(BOOL)follow;

@end
