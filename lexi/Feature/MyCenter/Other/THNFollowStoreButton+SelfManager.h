//
//  THNFollowStoreButton+SelfManager.h
//  lexi
//
//  Created by FLYang on 2018/8/22.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNFollowStoreButton.h"

@interface THNFollowStoreButton (SelfManager)

/**
 管理店铺关注状态

 @param follow 是否关注
 @param model 店铺数据
 */
- (void)selfManagerFollowStoreStatus:(BOOL)follow storeModel:(THNStoreModel *)model;

/**
 管理品牌馆关注状态
 
 @param follow 是否关注
 @param model 品牌馆数据
 */
- (void)selfManagerFollowBrandStatus:(BOOL)follow brandModel:(THNFeaturedBrandModel *)model;

- (void)selfManagerFollowBrandStatus:(BOOL)follow OffcialStoreModel:(THNOffcialStoreModel *)model;

@end
