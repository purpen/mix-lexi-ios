//
//  THNLifeOrderStoreModel.h
//  lexi
//
//  Created by FLYang on 2018/10/9.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THNLifeOrderStoreModel : NSObject

@property (nonatomic, strong) NSString *store_logo;
@property (nonatomic, strong) NSString *store_name;
@property (nonatomic, strong) NSString *store_rid;
@property (nonatomic, assign) NSInteger product_counts;
@property (nonatomic, assign) BOOL is_follow_store;

@end
