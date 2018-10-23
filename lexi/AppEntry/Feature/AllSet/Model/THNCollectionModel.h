//
//  THNCollectionModel.h
//  lexi
//
//  Created by rhp on 2018/9/2.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THNProductModel;

@interface THNCollectionModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray <THNProductModel *> *products;
@property (nonatomic, assign) NSInteger count;

@end
