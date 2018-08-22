//
//  THNStoreModel.h
//  lexi
//
//  Created by FLYang on 2018/8/20.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>
@class THNProductModel;

@interface THNStoreModel : NSObject

@property (nonatomic, assign) NSInteger rid;
@property (nonatomic, assign) NSInteger logo_id;
@property (nonatomic, assign) NSInteger bgcover_id;
@property (nonatomic, assign) NSInteger province_id;
@property (nonatomic, assign) NSInteger delivery_city_id;
@property (nonatomic, assign) NSInteger distribution_type;
@property (nonatomic, assign) NSInteger country_id;
@property (nonatomic, assign) NSInteger area_id;
@property (nonatomic, assign) NSInteger city_id;
@property (nonatomic, assign) NSInteger delivery_country_id;
@property (nonatomic, assign) NSInteger delivery_province_id;
@property (nonatomic, assign) NSInteger followed_status;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger pattern;
@property (nonatomic, assign) NSInteger fans_count;
@property (nonatomic, assign) NSInteger browse_number;
@property (nonatomic, assign) NSInteger mobile;
@property (nonatomic, assign) NSInteger phone;
@property (nonatomic, assign) NSInteger kind;
@property (nonatomic, assign) NSInteger store_products_counts;
@property (nonatomic, copy) NSString *delivery_province;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *delivery_country;
@property (nonatomic, copy) NSString *delivery_city;
@property (nonatomic, copy) NSString *areacode;
@property (nonatomic, copy) NSString *describe;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *bgcover;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *announcement;
@property (nonatomic, copy) NSString *tag_line;
@property (nonatomic, copy) NSString *begin_date;
@property (nonatomic, copy) NSString *end_date;
@property (nonatomic, copy) NSString *delivery_date;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, strong) NSArray *products;

@end
