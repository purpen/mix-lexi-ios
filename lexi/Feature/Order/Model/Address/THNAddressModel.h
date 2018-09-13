//
//	THNAddressModel.h
//  on 10/9/2018
//	Copyright © 2018. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface THNAddressModel : NSObject

@property (nonatomic, strong) NSString * area;
@property (nonatomic, assign) NSInteger areaId;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, assign) NSInteger cityId;
@property (nonatomic, assign) NSInteger countryId;
@property (nonatomic, strong) NSString * firstName;
@property (nonatomic, strong) NSString * fullAddress;
@property (nonatomic, strong) NSString * fullName;
@property (nonatomic, assign) BOOL isDefault;
@property (nonatomic, assign) BOOL isFromWx;
@property (nonatomic, strong) NSString * lastName;
@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * province;
@property (nonatomic, assign) NSInteger provinceId;
@property (nonatomic, strong) NSString * rid;
@property (nonatomic, strong) NSString * streetAddress;
@property (nonatomic, strong) NSString * streetAddressTwo;
@property (nonatomic, strong) NSString * town;
@property (nonatomic, assign) NSInteger townId;
@property (nonatomic, strong) NSString * zipcode;
@property (nonatomic, assign) BOOL selected;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
