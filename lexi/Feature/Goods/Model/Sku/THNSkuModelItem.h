//
//	THNSkuModelItem.h
//  on 31/8/2018
//	Copyright © 2018. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface THNSkuModelItem : NSObject

@property (nonatomic, strong) NSString * cover;
@property (nonatomic, strong) NSString * deliveryCountry;
@property (nonatomic, assign) NSInteger deliveryCountryId;
@property (nonatomic, strong) NSString * mode;
@property (nonatomic, strong) NSString * price;
@property (nonatomic, strong) NSString * productName;
@property (nonatomic, strong) NSString * productRid;
@property (nonatomic, strong) NSString * rid;
@property (nonatomic, strong) NSString * sColor;
@property (nonatomic, strong) NSString * sModel;
@property (nonatomic, strong) NSString * sWeight;
@property (nonatomic, strong) NSString * salePrice;
@property (nonatomic, assign) NSInteger stockCount;
@property (nonatomic, strong) NSString * storeLogo;
@property (nonatomic, strong) NSString * storeName;
@property (nonatomic, strong) NSString * storeRid;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
