//
//	THNStoreModel.h
//  on 1/9/2018
//	Copyright © 2018. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "THNStoreModelProduct.h"
#import "THNGoodsModel.h"

@interface THNStoreModel : NSObject

@property (nonatomic, strong) NSString * bgcover;
@property (nonatomic, strong) NSArray * categories;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * country;
@property (nonatomic, assign) NSInteger createdAt;
@property (nonatomic, strong) NSString * deliveryCity;
@property (nonatomic, strong) NSString * deliveryCountry;
@property (nonatomic, strong) NSString * deliveryProvince;
@property (nonatomic, assign) NSInteger fansCount;
@property (nonatomic, assign) BOOL isFollowed;
@property (nonatomic, assign) NSInteger lifeRecordCount;
@property (nonatomic, strong) NSString * logo;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) NSInteger productCount;
@property (nonatomic, strong) NSArray * products;
@property (nonatomic, strong) NSString * province;
@property (nonatomic, strong) NSString * rid;
@property (nonatomic, strong) NSString * tagLine;
@property (nonatomic, strong) NSString * town;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
