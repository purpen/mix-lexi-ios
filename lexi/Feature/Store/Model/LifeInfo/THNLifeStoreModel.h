//
//  THNLifeStoreModel.h
//  lexi
//
//  Created by FLYang on 2018/10/7.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>

@interface THNLifeStoreModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phases_description;
@property (nonatomic, strong) NSString *des;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, assign) NSInteger lifeStoreId;
// phases = 1: 实习馆主、2: 达人馆主
@property (nonatomic, assign) NSInteger phases;
@property (nonatomic, copy) NSString *created_at;
// 是否有推荐商品
@property (nonatomic, assign) BOOL has_product;
@property (nonatomic, strong) NSString *bgcover;

@end
