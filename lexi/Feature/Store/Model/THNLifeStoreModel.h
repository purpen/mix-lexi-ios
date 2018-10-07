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
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, assign) NSInteger lifeStoreId;
@property (nonatomic, assign) NSInteger phases;
@property (nonatomic, assign) NSInteger created_at;

@end
