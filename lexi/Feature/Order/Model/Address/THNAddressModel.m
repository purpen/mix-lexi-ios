//
//	THNAddressModel.m
//  on 10/9/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNAddressModel.h"

NSString *const kTHNAddressModelArea = @"area";
NSString *const kTHNAddressModelAreaId = @"area_id";
NSString *const kTHNAddressModelCity = @"city";
NSString *const kTHNAddressModelCityId = @"city_id";
NSString *const kTHNAddressModelCountryId = @"country_id";
NSString *const kTHNAddressModelFirstName = @"first_name";
NSString *const kTHNAddressModelFullAddress = @"full_address";
NSString *const kTHNAddressModelFullName = @"full_name";
NSString *const kTHNAddressModelIsDefault = @"is_default";
NSString *const kTHNAddressModelIsFromWx = @"is_from_wx";
NSString *const kTHNAddressModelLastName = @"last_name";
NSString *const kTHNAddressModelMobile = @"mobile";
NSString *const kTHNAddressModelPhone = @"phone";
NSString *const kTHNAddressModelProvince = @"province";
NSString *const kTHNAddressModelProvinceId = @"province_id";
NSString *const kTHNAddressModelRid = @"rid";
NSString *const kTHNAddressModelStreetAddress = @"street_address";
NSString *const kTHNAddressModelStreetAddressTwo = @"street_address_two";
NSString *const kTHNAddressModelTown = @"town";
NSString *const kTHNAddressModelTownId = @"town_id";
NSString *const kTHNAddressModelZipcode = @"zipcode";

@interface THNAddressModel ()
@end
@implementation THNAddressModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNAddressModelArea] isKindOfClass:[NSNull class]]){
		self.area = dictionary[kTHNAddressModelArea];
	}	
	if(![dictionary[kTHNAddressModelAreaId] isKindOfClass:[NSNull class]]){
		self.areaId = [dictionary[kTHNAddressModelAreaId] integerValue];
	}

	if(![dictionary[kTHNAddressModelCity] isKindOfClass:[NSNull class]]){
		self.city = dictionary[kTHNAddressModelCity];
	}	
	if(![dictionary[kTHNAddressModelCityId] isKindOfClass:[NSNull class]]){
		self.cityId = [dictionary[kTHNAddressModelCityId] integerValue];
	}

	if(![dictionary[kTHNAddressModelCountryId] isKindOfClass:[NSNull class]]){
		self.countryId = [dictionary[kTHNAddressModelCountryId] integerValue];
	}

	if(![dictionary[kTHNAddressModelFirstName] isKindOfClass:[NSNull class]]){
		self.firstName = dictionary[kTHNAddressModelFirstName];
	}	
	if(![dictionary[kTHNAddressModelFullAddress] isKindOfClass:[NSNull class]]){
		self.fullAddress = dictionary[kTHNAddressModelFullAddress];
	}	
	if(![dictionary[kTHNAddressModelFullName] isKindOfClass:[NSNull class]]){
		self.fullName = dictionary[kTHNAddressModelFullName];
	}	
	if(![dictionary[kTHNAddressModelIsDefault] isKindOfClass:[NSNull class]]){
		self.isDefault = [dictionary[kTHNAddressModelIsDefault] boolValue];
	}

	if(![dictionary[kTHNAddressModelIsFromWx] isKindOfClass:[NSNull class]]){
		self.isFromWx = [dictionary[kTHNAddressModelIsFromWx] boolValue];
	}

	if(![dictionary[kTHNAddressModelLastName] isKindOfClass:[NSNull class]]){
		self.lastName = dictionary[kTHNAddressModelLastName];
	}	
	if(![dictionary[kTHNAddressModelMobile] isKindOfClass:[NSNull class]]){
		self.mobile = dictionary[kTHNAddressModelMobile];
	}	
	if(![dictionary[kTHNAddressModelPhone] isKindOfClass:[NSNull class]]){
		self.phone = dictionary[kTHNAddressModelPhone];
	}	
	if(![dictionary[kTHNAddressModelProvince] isKindOfClass:[NSNull class]]){
		self.province = dictionary[kTHNAddressModelProvince];
	}	
	if(![dictionary[kTHNAddressModelProvinceId] isKindOfClass:[NSNull class]]){
		self.provinceId = [dictionary[kTHNAddressModelProvinceId] integerValue];
	}

	if(![dictionary[kTHNAddressModelRid] isKindOfClass:[NSNull class]]){
		self.rid = dictionary[kTHNAddressModelRid];
	}	
	if(![dictionary[kTHNAddressModelStreetAddress] isKindOfClass:[NSNull class]]){
		self.streetAddress = dictionary[kTHNAddressModelStreetAddress];
	}	
	if(![dictionary[kTHNAddressModelStreetAddressTwo] isKindOfClass:[NSNull class]]){
		self.streetAddressTwo = dictionary[kTHNAddressModelStreetAddressTwo];
	}	
	if(![dictionary[kTHNAddressModelTown] isKindOfClass:[NSNull class]]){
		self.town = dictionary[kTHNAddressModelTown];
	}	
	if(![dictionary[kTHNAddressModelTownId] isKindOfClass:[NSNull class]]){
		self.townId = [dictionary[kTHNAddressModelTownId] integerValue];
	}

	if(![dictionary[kTHNAddressModelZipcode] isKindOfClass:[NSNull class]]){
		self.zipcode = dictionary[kTHNAddressModelZipcode];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.area != nil){
		dictionary[kTHNAddressModelArea] = self.area;
	}
	dictionary[kTHNAddressModelAreaId] = @(self.areaId);
	if(self.city != nil){
		dictionary[kTHNAddressModelCity] = self.city;
	}
	dictionary[kTHNAddressModelCityId] = @(self.cityId);
	dictionary[kTHNAddressModelCountryId] = @(self.countryId);
	if(self.firstName != nil){
		dictionary[kTHNAddressModelFirstName] = self.firstName;
	}
	if(self.fullAddress != nil){
		dictionary[kTHNAddressModelFullAddress] = self.fullAddress;
	}
	if(self.fullName != nil){
		dictionary[kTHNAddressModelFullName] = self.fullName;
	}
	dictionary[kTHNAddressModelIsDefault] = @(self.isDefault);
	dictionary[kTHNAddressModelIsFromWx] = @(self.isFromWx);
	if(self.lastName != nil){
		dictionary[kTHNAddressModelLastName] = self.lastName;
	}
	if(self.mobile != nil){
		dictionary[kTHNAddressModelMobile] = self.mobile;
	}
	if(self.phone != nil){
		dictionary[kTHNAddressModelPhone] = self.phone;
	}
	if(self.province != nil){
		dictionary[kTHNAddressModelProvince] = self.province;
	}
	dictionary[kTHNAddressModelProvinceId] = @(self.provinceId);
	if(self.rid != nil){
		dictionary[kTHNAddressModelRid] = self.rid;
	}
	if(self.streetAddress != nil){
		dictionary[kTHNAddressModelStreetAddress] = self.streetAddress;
	}
	if(self.streetAddressTwo != nil){
		dictionary[kTHNAddressModelStreetAddressTwo] = self.streetAddressTwo;
	}
	if(self.town != nil){
		dictionary[kTHNAddressModelTown] = self.town;
	}
	dictionary[kTHNAddressModelTownId] = @(self.townId);
	if(self.zipcode != nil){
		dictionary[kTHNAddressModelZipcode] = self.zipcode;
	}
	return dictionary;

}

/**
 * Implementation of NSCoding encoding method
 */
/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
	if(self.area != nil){
		[aCoder encodeObject:self.area forKey:kTHNAddressModelArea];
	}
	[aCoder encodeObject:@(self.areaId) forKey:kTHNAddressModelAreaId];	if(self.city != nil){
		[aCoder encodeObject:self.city forKey:kTHNAddressModelCity];
	}
	[aCoder encodeObject:@(self.cityId) forKey:kTHNAddressModelCityId];	[aCoder encodeObject:@(self.countryId) forKey:kTHNAddressModelCountryId];	if(self.firstName != nil){
		[aCoder encodeObject:self.firstName forKey:kTHNAddressModelFirstName];
	}
	if(self.fullAddress != nil){
		[aCoder encodeObject:self.fullAddress forKey:kTHNAddressModelFullAddress];
	}
	if(self.fullName != nil){
		[aCoder encodeObject:self.fullName forKey:kTHNAddressModelFullName];
	}
	[aCoder encodeObject:@(self.isDefault) forKey:kTHNAddressModelIsDefault];	[aCoder encodeObject:@(self.isFromWx) forKey:kTHNAddressModelIsFromWx];	if(self.lastName != nil){
		[aCoder encodeObject:self.lastName forKey:kTHNAddressModelLastName];
	}
	if(self.mobile != nil){
		[aCoder encodeObject:self.mobile forKey:kTHNAddressModelMobile];
	}
	if(self.phone != nil){
		[aCoder encodeObject:self.phone forKey:kTHNAddressModelPhone];
	}
	if(self.province != nil){
		[aCoder encodeObject:self.province forKey:kTHNAddressModelProvince];
	}
	[aCoder encodeObject:@(self.provinceId) forKey:kTHNAddressModelProvinceId];	if(self.rid != nil){
		[aCoder encodeObject:self.rid forKey:kTHNAddressModelRid];
	}
	if(self.streetAddress != nil){
		[aCoder encodeObject:self.streetAddress forKey:kTHNAddressModelStreetAddress];
	}
	if(self.streetAddressTwo != nil){
		[aCoder encodeObject:self.streetAddressTwo forKey:kTHNAddressModelStreetAddressTwo];
	}
	if(self.town != nil){
		[aCoder encodeObject:self.town forKey:kTHNAddressModelTown];
	}
	[aCoder encodeObject:@(self.townId) forKey:kTHNAddressModelTownId];	if(self.zipcode != nil){
		[aCoder encodeObject:self.zipcode forKey:kTHNAddressModelZipcode];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.area = [aDecoder decodeObjectForKey:kTHNAddressModelArea];
	self.areaId = [[aDecoder decodeObjectForKey:kTHNAddressModelAreaId] integerValue];
	self.city = [aDecoder decodeObjectForKey:kTHNAddressModelCity];
	self.cityId = [[aDecoder decodeObjectForKey:kTHNAddressModelCityId] integerValue];
	self.countryId = [[aDecoder decodeObjectForKey:kTHNAddressModelCountryId] integerValue];
	self.firstName = [aDecoder decodeObjectForKey:kTHNAddressModelFirstName];
	self.fullAddress = [aDecoder decodeObjectForKey:kTHNAddressModelFullAddress];
	self.fullName = [aDecoder decodeObjectForKey:kTHNAddressModelFullName];
	self.isDefault = [[aDecoder decodeObjectForKey:kTHNAddressModelIsDefault] boolValue];
	self.isFromWx = [[aDecoder decodeObjectForKey:kTHNAddressModelIsFromWx] boolValue];
	self.lastName = [aDecoder decodeObjectForKey:kTHNAddressModelLastName];
	self.mobile = [aDecoder decodeObjectForKey:kTHNAddressModelMobile];
	self.phone = [aDecoder decodeObjectForKey:kTHNAddressModelPhone];
	self.province = [aDecoder decodeObjectForKey:kTHNAddressModelProvince];
	self.provinceId = [[aDecoder decodeObjectForKey:kTHNAddressModelProvinceId] integerValue];
	self.rid = [aDecoder decodeObjectForKey:kTHNAddressModelRid];
	self.streetAddress = [aDecoder decodeObjectForKey:kTHNAddressModelStreetAddress];
	self.streetAddressTwo = [aDecoder decodeObjectForKey:kTHNAddressModelStreetAddressTwo];
	self.town = [aDecoder decodeObjectForKey:kTHNAddressModelTown];
	self.townId = [[aDecoder decodeObjectForKey:kTHNAddressModelTownId] integerValue];
	self.zipcode = [aDecoder decodeObjectForKey:kTHNAddressModelZipcode];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	THNAddressModel *copy = [THNAddressModel new];

	copy.area = [self.area copy];
	copy.areaId = self.areaId;
	copy.city = [self.city copy];
	copy.cityId = self.cityId;
	copy.countryId = self.countryId;
	copy.firstName = [self.firstName copy];
	copy.fullAddress = [self.fullAddress copy];
	copy.fullName = [self.fullName copy];
	copy.isDefault = self.isDefault;
	copy.isFromWx = self.isFromWx;
	copy.lastName = [self.lastName copy];
	copy.mobile = [self.mobile copy];
	copy.phone = [self.phone copy];
	copy.province = [self.province copy];
	copy.provinceId = self.provinceId;
	copy.rid = [self.rid copy];
	copy.streetAddress = [self.streetAddress copy];
	copy.streetAddressTwo = [self.streetAddressTwo copy];
	copy.town = [self.town copy];
	copy.townId = self.townId;
	copy.zipcode = [self.zipcode copy];

	return copy;
}
@end
