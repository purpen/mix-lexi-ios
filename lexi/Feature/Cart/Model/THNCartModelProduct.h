//
//	THNCartModelProduct.h
//  on 15/9/2018
//	Copyright © 2018. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface THNCartModelProduct : NSObject

@property (nonatomic, strong) NSString * bgcover;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * country;
@property (nonatomic, strong) NSString * cover;
@property (nonatomic, assign) NSInteger coverId;
@property (nonatomic, strong) NSString * deliveryCity;
@property (nonatomic, strong) NSString * deliveryCountry;
@property (nonatomic, assign) NSInteger deliveryCountryId;
@property (nonatomic, strong) NSString * deliveryProvince;
@property (nonatomic, assign) NSInteger distributionType;
@property (nonatomic, assign) NSInteger fansCount;
@property (nonatomic, assign) BOOL isFreePostage;
@property (nonatomic, strong) NSString * mode;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, strong) NSString * productName;
@property (nonatomic, strong) NSString * productRid;
@property (nonatomic, strong) NSString * province;
@property (nonatomic, strong) NSString * rid;
@property (nonatomic, strong) NSString * sColor;
@property (nonatomic, strong) NSString * sModel;
@property (nonatomic, assign) CGFloat sWeight;
@property (nonatomic, assign) CGFloat salePrice;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger stockCount;
@property (nonatomic, assign) NSInteger stockQuantity;
@property (nonatomic, assign) NSInteger productTotalCount;
@property (nonatomic, strong) NSString * storeLogo;
@property (nonatomic, strong) NSString * storeName;
@property (nonatomic, strong) NSString * storeRid;
@property (nonatomic, strong) NSString * tagLine;
@property (nonatomic, strong) NSString * town;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
