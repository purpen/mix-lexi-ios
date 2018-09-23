//
//	THNCartModelProduct.m
//  on 15/9/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNCartModelProduct.h"

NSString *const kTHNCartModelProductBgcover = @"bgcover";
NSString *const kTHNCartModelProductCity = @"city";
NSString *const kTHNCartModelProductCountry = @"country";
NSString *const kTHNCartModelProductCover = @"cover";
NSString *const kTHNCartModelProductCoverId = @"cover_id";
NSString *const kTHNCartModelProductDeliveryCity = @"delivery_city";
NSString *const kTHNCartModelProductDeliveryCountry = @"delivery_country";
NSString *const kTHNCartModelProductDeliveryCountryId = @"delivery_country_id";
NSString *const kTHNCartModelProductDeliveryProvince = @"delivery_province";
NSString *const kTHNCartModelProductDistributionType = @"distribution_type";
NSString *const kTHNCartModelProductFansCount = @"fans_count";
NSString *const kTHNCartModelProductIsFreePostage = @"is_free_postage";
NSString *const kTHNCartModelProductMode = @"mode";
NSString *const kTHNCartModelProductPrice = @"price";
NSString *const kTHNCartModelProductProductName = @"product_name";
NSString *const kTHNCartModelProductProductRid = @"product_rid";
NSString *const kTHNCartModelProductProvince = @"province";
NSString *const kTHNCartModelProductRid = @"rid";
NSString *const kTHNCartModelProductSColor = @"s_color";
NSString *const kTHNCartModelProductSModel = @"s_model";
NSString *const kTHNCartModelProductSWeight = @"s_weight";
NSString *const kTHNCartModelProductSalePrice = @"sale_price";
NSString *const kTHNCartModelProductStatus = @"status";
NSString *const kTHNCartModelProductStockCount = @"stock_count";
NSString *const kTHNCartModelProductStockQuantity = @"stock_quantity";
NSString *const kTHNCartModelProductStoreLogo = @"store_logo";
NSString *const kTHNCartModelProductStoreName = @"store_name";
NSString *const kTHNCartModelProductStoreRid = @"store_rid";
NSString *const kTHNCartModelProductTagLine = @"tag_line";
NSString *const kTHNCartModelProductTown = @"town";

@interface THNCartModelProduct ()
@end
@implementation THNCartModelProduct




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNCartModelProductBgcover] isKindOfClass:[NSNull class]]){
		self.bgcover = dictionary[kTHNCartModelProductBgcover];
	}	
	if(![dictionary[kTHNCartModelProductCity] isKindOfClass:[NSNull class]]){
		self.city = dictionary[kTHNCartModelProductCity];
	}	
	if(![dictionary[kTHNCartModelProductCountry] isKindOfClass:[NSNull class]]){
		self.country = dictionary[kTHNCartModelProductCountry];
	}	
	if(![dictionary[kTHNCartModelProductCover] isKindOfClass:[NSNull class]]){
		self.cover = dictionary[kTHNCartModelProductCover];
	}	
	if(![dictionary[kTHNCartModelProductCoverId] isKindOfClass:[NSNull class]]){
		self.coverId = [dictionary[kTHNCartModelProductCoverId] integerValue];
	}

	if(![dictionary[kTHNCartModelProductDeliveryCity] isKindOfClass:[NSNull class]]){
		self.deliveryCity = dictionary[kTHNCartModelProductDeliveryCity];
	}	
	if(![dictionary[kTHNCartModelProductDeliveryCountry] isKindOfClass:[NSNull class]]){
		self.deliveryCountry = dictionary[kTHNCartModelProductDeliveryCountry];
	}	
	if(![dictionary[kTHNCartModelProductDeliveryCountryId] isKindOfClass:[NSNull class]]){
		self.deliveryCountryId = [dictionary[kTHNCartModelProductDeliveryCountryId] integerValue];
	}

	if(![dictionary[kTHNCartModelProductDeliveryProvince] isKindOfClass:[NSNull class]]){
		self.deliveryProvince = dictionary[kTHNCartModelProductDeliveryProvince];
	}	
	if(![dictionary[kTHNCartModelProductDistributionType] isKindOfClass:[NSNull class]]){
		self.distributionType = [dictionary[kTHNCartModelProductDistributionType] integerValue];
	}

	if(![dictionary[kTHNCartModelProductFansCount] isKindOfClass:[NSNull class]]){
		self.fansCount = [dictionary[kTHNCartModelProductFansCount] integerValue];
	}

	if(![dictionary[kTHNCartModelProductIsFreePostage] isKindOfClass:[NSNull class]]){
		self.isFreePostage = [dictionary[kTHNCartModelProductIsFreePostage] boolValue];
	}

	if(![dictionary[kTHNCartModelProductMode] isKindOfClass:[NSNull class]]){
		self.mode = dictionary[kTHNCartModelProductMode];
	}	
	if(![dictionary[kTHNCartModelProductPrice] isKindOfClass:[NSNull class]]){
		self.price = [dictionary[kTHNCartModelProductPrice] floatValue];
	}

	if(![dictionary[kTHNCartModelProductProductName] isKindOfClass:[NSNull class]]){
		self.productName = dictionary[kTHNCartModelProductProductName];
	}	
	if(![dictionary[kTHNCartModelProductProductRid] isKindOfClass:[NSNull class]]){
		self.productRid = dictionary[kTHNCartModelProductProductRid];
	}	
	if(![dictionary[kTHNCartModelProductProvince] isKindOfClass:[NSNull class]]){
		self.province = dictionary[kTHNCartModelProductProvince];
	}	
	if(![dictionary[kTHNCartModelProductRid] isKindOfClass:[NSNull class]]){
		self.rid = dictionary[kTHNCartModelProductRid];
	}	
	if(![dictionary[kTHNCartModelProductSColor] isKindOfClass:[NSNull class]]){
		self.sColor = dictionary[kTHNCartModelProductSColor];
	}	
	if(![dictionary[kTHNCartModelProductSModel] isKindOfClass:[NSNull class]]){
		self.sModel = dictionary[kTHNCartModelProductSModel];
	}	
	if(![dictionary[kTHNCartModelProductSWeight] isKindOfClass:[NSNull class]]){
		self.sWeight = [dictionary[kTHNCartModelProductSWeight] floatValue];
	}

	if(![dictionary[kTHNCartModelProductSalePrice] isKindOfClass:[NSNull class]]){
		self.salePrice = [dictionary[kTHNCartModelProductSalePrice] floatValue];
	}

	if(![dictionary[kTHNCartModelProductStatus] isKindOfClass:[NSNull class]]){
		self.status = [dictionary[kTHNCartModelProductStatus] integerValue];
	}

	if(![dictionary[kTHNCartModelProductStockCount] isKindOfClass:[NSNull class]]){
		self.stockCount = [dictionary[kTHNCartModelProductStockCount] integerValue];
	}

	if(![dictionary[kTHNCartModelProductStockQuantity] isKindOfClass:[NSNull class]]){
		self.stockQuantity = [dictionary[kTHNCartModelProductStockQuantity] integerValue];
	}

	if(![dictionary[kTHNCartModelProductStoreLogo] isKindOfClass:[NSNull class]]){
		self.storeLogo = dictionary[kTHNCartModelProductStoreLogo];
	}	
	if(![dictionary[kTHNCartModelProductStoreName] isKindOfClass:[NSNull class]]){
		self.storeName = dictionary[kTHNCartModelProductStoreName];
	}	
	if(![dictionary[kTHNCartModelProductStoreRid] isKindOfClass:[NSNull class]]){
		self.storeRid = dictionary[kTHNCartModelProductStoreRid];
	}	
	if(![dictionary[kTHNCartModelProductTagLine] isKindOfClass:[NSNull class]]){
		self.tagLine = dictionary[kTHNCartModelProductTagLine];
	}	
	if(![dictionary[kTHNCartModelProductTown] isKindOfClass:[NSNull class]]){
		self.town = dictionary[kTHNCartModelProductTown];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.bgcover != nil){
		dictionary[kTHNCartModelProductBgcover] = self.bgcover;
	}
	if(self.city != nil){
		dictionary[kTHNCartModelProductCity] = self.city;
	}
	if(self.country != nil){
		dictionary[kTHNCartModelProductCountry] = self.country;
	}
	if(self.cover != nil){
		dictionary[kTHNCartModelProductCover] = self.cover;
	}
	dictionary[kTHNCartModelProductCoverId] = @(self.coverId);
	if(self.deliveryCity != nil){
		dictionary[kTHNCartModelProductDeliveryCity] = self.deliveryCity;
	}
	if(self.deliveryCountry != nil){
		dictionary[kTHNCartModelProductDeliveryCountry] = self.deliveryCountry;
	}
	dictionary[kTHNCartModelProductDeliveryCountryId] = @(self.deliveryCountryId);
	if(self.deliveryProvince != nil){
		dictionary[kTHNCartModelProductDeliveryProvince] = self.deliveryProvince;
	}
	dictionary[kTHNCartModelProductDistributionType] = @(self.distributionType);
	dictionary[kTHNCartModelProductFansCount] = @(self.fansCount);
	dictionary[kTHNCartModelProductIsFreePostage] = @(self.isFreePostage);
	if(self.mode != nil){
		dictionary[kTHNCartModelProductMode] = self.mode;
	}
	dictionary[kTHNCartModelProductPrice] = @(self.price);
	if(self.productName != nil){
		dictionary[kTHNCartModelProductProductName] = self.productName;
	}
	if(self.productRid != nil){
		dictionary[kTHNCartModelProductProductRid] = self.productRid;
	}
	if(self.province != nil){
		dictionary[kTHNCartModelProductProvince] = self.province;
	}
	if(self.rid != nil){
		dictionary[kTHNCartModelProductRid] = self.rid;
	}
	if(self.sColor != nil){
		dictionary[kTHNCartModelProductSColor] = self.sColor;
	}
	if(self.sModel != nil){
		dictionary[kTHNCartModelProductSModel] = self.sModel;
	}
	dictionary[kTHNCartModelProductSWeight] = @(self.sWeight);
	dictionary[kTHNCartModelProductSalePrice] = @(self.salePrice);
	dictionary[kTHNCartModelProductStatus] = @(self.status);
	dictionary[kTHNCartModelProductStockCount] = @(self.stockCount);
	dictionary[kTHNCartModelProductStockQuantity] = @(self.stockQuantity);
	if(self.storeLogo != nil){
		dictionary[kTHNCartModelProductStoreLogo] = self.storeLogo;
	}
	if(self.storeName != nil){
		dictionary[kTHNCartModelProductStoreName] = self.storeName;
	}
	if(self.storeRid != nil){
		dictionary[kTHNCartModelProductStoreRid] = self.storeRid;
	}
	if(self.tagLine != nil){
		dictionary[kTHNCartModelProductTagLine] = self.tagLine;
	}
	if(self.town != nil){
		dictionary[kTHNCartModelProductTown] = self.town;
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
	if(self.bgcover != nil){
		[aCoder encodeObject:self.bgcover forKey:kTHNCartModelProductBgcover];
	}
	if(self.city != nil){
		[aCoder encodeObject:self.city forKey:kTHNCartModelProductCity];
	}
	if(self.country != nil){
		[aCoder encodeObject:self.country forKey:kTHNCartModelProductCountry];
	}
	if(self.cover != nil){
		[aCoder encodeObject:self.cover forKey:kTHNCartModelProductCover];
	}
	[aCoder encodeObject:@(self.coverId) forKey:kTHNCartModelProductCoverId];	if(self.deliveryCity != nil){
		[aCoder encodeObject:self.deliveryCity forKey:kTHNCartModelProductDeliveryCity];
	}
	if(self.deliveryCountry != nil){
		[aCoder encodeObject:self.deliveryCountry forKey:kTHNCartModelProductDeliveryCountry];
	}
	[aCoder encodeObject:@(self.deliveryCountryId) forKey:kTHNCartModelProductDeliveryCountryId];	if(self.deliveryProvince != nil){
		[aCoder encodeObject:self.deliveryProvince forKey:kTHNCartModelProductDeliveryProvince];
	}
	[aCoder encodeObject:@(self.distributionType) forKey:kTHNCartModelProductDistributionType];	[aCoder encodeObject:@(self.fansCount) forKey:kTHNCartModelProductFansCount];	[aCoder encodeObject:@(self.isFreePostage) forKey:kTHNCartModelProductIsFreePostage];	if(self.mode != nil){
		[aCoder encodeObject:self.mode forKey:kTHNCartModelProductMode];
	}
	[aCoder encodeObject:@(self.price) forKey:kTHNCartModelProductPrice];	if(self.productName != nil){
		[aCoder encodeObject:self.productName forKey:kTHNCartModelProductProductName];
	}
	if(self.productRid != nil){
		[aCoder encodeObject:self.productRid forKey:kTHNCartModelProductProductRid];
	}
	if(self.province != nil){
		[aCoder encodeObject:self.province forKey:kTHNCartModelProductProvince];
	}
	if(self.rid != nil){
		[aCoder encodeObject:self.rid forKey:kTHNCartModelProductRid];
	}
	if(self.sColor != nil){
		[aCoder encodeObject:self.sColor forKey:kTHNCartModelProductSColor];
	}
	if(self.sModel != nil){
		[aCoder encodeObject:self.sModel forKey:kTHNCartModelProductSModel];
	}
	[aCoder encodeObject:@(self.sWeight) forKey:kTHNCartModelProductSWeight];	[aCoder encodeObject:@(self.salePrice) forKey:kTHNCartModelProductSalePrice];	[aCoder encodeObject:@(self.status) forKey:kTHNCartModelProductStatus];	[aCoder encodeObject:@(self.stockCount) forKey:kTHNCartModelProductStockCount];	[aCoder encodeObject:@(self.stockQuantity) forKey:kTHNCartModelProductStockQuantity];	if(self.storeLogo != nil){
		[aCoder encodeObject:self.storeLogo forKey:kTHNCartModelProductStoreLogo];
	}
	if(self.storeName != nil){
		[aCoder encodeObject:self.storeName forKey:kTHNCartModelProductStoreName];
	}
	if(self.storeRid != nil){
		[aCoder encodeObject:self.storeRid forKey:kTHNCartModelProductStoreRid];
	}
	if(self.tagLine != nil){
		[aCoder encodeObject:self.tagLine forKey:kTHNCartModelProductTagLine];
	}
	if(self.town != nil){
		[aCoder encodeObject:self.town forKey:kTHNCartModelProductTown];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.bgcover = [aDecoder decodeObjectForKey:kTHNCartModelProductBgcover];
	self.city = [aDecoder decodeObjectForKey:kTHNCartModelProductCity];
	self.country = [aDecoder decodeObjectForKey:kTHNCartModelProductCountry];
	self.cover = [aDecoder decodeObjectForKey:kTHNCartModelProductCover];
	self.coverId = [[aDecoder decodeObjectForKey:kTHNCartModelProductCoverId] integerValue];
	self.deliveryCity = [aDecoder decodeObjectForKey:kTHNCartModelProductDeliveryCity];
	self.deliveryCountry = [aDecoder decodeObjectForKey:kTHNCartModelProductDeliveryCountry];
	self.deliveryCountryId = [[aDecoder decodeObjectForKey:kTHNCartModelProductDeliveryCountryId] integerValue];
	self.deliveryProvince = [aDecoder decodeObjectForKey:kTHNCartModelProductDeliveryProvince];
	self.distributionType = [[aDecoder decodeObjectForKey:kTHNCartModelProductDistributionType] integerValue];
	self.fansCount = [[aDecoder decodeObjectForKey:kTHNCartModelProductFansCount] integerValue];
	self.isFreePostage = [[aDecoder decodeObjectForKey:kTHNCartModelProductIsFreePostage] boolValue];
	self.mode = [aDecoder decodeObjectForKey:kTHNCartModelProductMode];
	self.price = [[aDecoder decodeObjectForKey:kTHNCartModelProductPrice] integerValue];
	self.productName = [aDecoder decodeObjectForKey:kTHNCartModelProductProductName];
	self.productRid = [aDecoder decodeObjectForKey:kTHNCartModelProductProductRid];
	self.province = [aDecoder decodeObjectForKey:kTHNCartModelProductProvince];
	self.rid = [aDecoder decodeObjectForKey:kTHNCartModelProductRid];
	self.sColor = [aDecoder decodeObjectForKey:kTHNCartModelProductSColor];
	self.sModel = [aDecoder decodeObjectForKey:kTHNCartModelProductSModel];
	self.sWeight = [[aDecoder decodeObjectForKey:kTHNCartModelProductSWeight] floatValue];
	self.salePrice = [[aDecoder decodeObjectForKey:kTHNCartModelProductSalePrice] integerValue];
	self.status = [[aDecoder decodeObjectForKey:kTHNCartModelProductStatus] integerValue];
	self.stockCount = [[aDecoder decodeObjectForKey:kTHNCartModelProductStockCount] integerValue];
	self.stockQuantity = [[aDecoder decodeObjectForKey:kTHNCartModelProductStockQuantity] integerValue];
	self.storeLogo = [aDecoder decodeObjectForKey:kTHNCartModelProductStoreLogo];
	self.storeName = [aDecoder decodeObjectForKey:kTHNCartModelProductStoreName];
	self.storeRid = [aDecoder decodeObjectForKey:kTHNCartModelProductStoreRid];
	self.tagLine = [aDecoder decodeObjectForKey:kTHNCartModelProductTagLine];
	self.town = [aDecoder decodeObjectForKey:kTHNCartModelProductTown];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	THNCartModelProduct *copy = [THNCartModelProduct new];

	copy.bgcover = [self.bgcover copy];
	copy.city = [self.city copy];
	copy.country = [self.country copy];
	copy.cover = [self.cover copy];
	copy.coverId = self.coverId;
	copy.deliveryCity = [self.deliveryCity copy];
	copy.deliveryCountry = [self.deliveryCountry copy];
	copy.deliveryCountryId = self.deliveryCountryId;
	copy.deliveryProvince = [self.deliveryProvince copy];
	copy.distributionType = self.distributionType;
	copy.fansCount = self.fansCount;
	copy.isFreePostage = self.isFreePostage;
	copy.mode = [self.mode copy];
	copy.price = self.price;
	copy.productName = [self.productName copy];
	copy.productRid = [self.productRid copy];
	copy.province = [self.province copy];
	copy.rid = [self.rid copy];
	copy.sColor = [self.sColor copy];
	copy.sModel = [self.sModel copy];
	copy.sWeight = self.sWeight;
	copy.salePrice = self.salePrice;
	copy.status = self.status;
	copy.stockCount = self.stockCount;
	copy.stockQuantity = self.stockQuantity;
	copy.storeLogo = [self.storeLogo copy];
	copy.storeName = [self.storeName copy];
	copy.storeRid = [self.storeRid copy];
	copy.tagLine = [self.tagLine copy];
	copy.town = [self.town copy];

	return copy;
}
@end
