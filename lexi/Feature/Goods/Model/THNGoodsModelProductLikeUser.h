//
//	THNGoodsModelProductLikeUser.h
//  on 1/9/2018
//	Copyright © 2018. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface THNGoodsModelProductLikeUser : NSObject

@property (nonatomic, strong) NSObject * aboutMe;
@property (nonatomic, strong) NSString * area;
@property (nonatomic, assign) NSInteger areaId;
@property (nonatomic, strong) NSString * areacode;
@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, assign) NSInteger avatarId;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, assign) NSInteger cityId;
@property (nonatomic, strong) NSString * country;
@property (nonatomic, assign) NSInteger countryId;
@property (nonatomic, assign) NSInteger createdAt;
@property (nonatomic, strong) NSString * date;
@property (nonatomic, strong) NSObject * descriptionField;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, assign) BOOL isDistributor;
@property (nonatomic, assign) NSInteger lastSeen;
@property (nonatomic, strong) NSObject * lastStoreRid;
@property (nonatomic, strong) NSString * mail;
@property (nonatomic, assign) NSInteger masterUid;
@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * province;
@property (nonatomic, assign) NSInteger provinceId;
@property (nonatomic, strong) NSString * streetAddress;
@property (nonatomic, strong) NSString * town;
@property (nonatomic, strong) NSObject * townId;
@property (nonatomic, strong) NSString * uid;
@property (nonatomic, strong) NSArray * userAreacode;
@property (nonatomic, strong) NSString * username;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
