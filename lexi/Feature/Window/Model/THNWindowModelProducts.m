//
//	THNWindowModelProducts.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNWindowModelProducts.h"

NSString *const kTHNWindowModelProductsBgcover = @"bgcover";
NSString *const kTHNWindowModelProductsCategoryId = @"category_id";
NSString *const kTHNWindowModelProductsCity = @"city";
NSString *const kTHNWindowModelProductsCommissionPrice = @"commission_price";
NSString *const kTHNWindowModelProductsCommissionRate = @"commission_rate";
NSString *const kTHNWindowModelProductsCountry = @"country";
NSString *const kTHNWindowModelProductsCover = @"cover";
NSString *const kTHNWindowModelProductsCoverId = @"cover_id";
NSString *const kTHNWindowModelProductsCustomDetails = @"custom_details";
NSString *const kTHNWindowModelProductsDeliveryCity = @"delivery_city";
NSString *const kTHNWindowModelProductsDeliveryCountry = @"delivery_country";
NSString *const kTHNWindowModelProductsDeliveryCountryId = @"delivery_country_id";
NSString *const kTHNWindowModelProductsDeliveryProvince = @"delivery_province";
NSString *const kTHNWindowModelProductsDistributionType = @"distribution_type";
NSString *const kTHNWindowModelProductsFansCount = @"fans_count";
NSString *const kTHNWindowModelProductsFeatures = @"features";
NSString *const kTHNWindowModelProductsHaveDistributed = @"have_distributed";
NSString *const kTHNWindowModelProductsIdCode = @"id_code";
NSString *const kTHNWindowModelProductsIsCustomMade = @"is_custom_made";
NSString *const kTHNWindowModelProductsIsCustomService = @"is_custom_service";
NSString *const kTHNWindowModelProductsIsDistributed = @"is_distributed";
NSString *const kTHNWindowModelProductsIsFreePostage = @"is_free_postage";
NSString *const kTHNWindowModelProductsIsMadeHoliday = @"is_made_holiday";
NSString *const kTHNWindowModelProductsIsProprietary = @"is_proprietary";
NSString *const kTHNWindowModelProductsIsSoldOut = @"is_sold_out";
NSString *const kTHNWindowModelProductsLikeCount = @"like_count";
NSString *const kTHNWindowModelProductsMadeCycle = @"made_cycle";
NSString *const kTHNWindowModelProductsMaterialId = @"material_id";
NSString *const kTHNWindowModelProductsMaterialName = @"material_name";
NSString *const kTHNWindowModelProductsMaxPrice = @"max_price";
NSString *const kTHNWindowModelProductsMaxSalePrice = @"max_sale_price";
NSString *const kTHNWindowModelProductsMinPrice = @"min_price";
NSString *const kTHNWindowModelProductsMinSalePrice = @"min_sale_price";
NSString *const kTHNWindowModelProductsModes = @"modes";
NSString *const kTHNWindowModelProductsName = @"name";
NSString *const kTHNWindowModelProductsProvince = @"province";
NSString *const kTHNWindowModelProductsPublishedAt = @"published_at";
NSString *const kTHNWindowModelProductsRealPrice = @"real_price";
NSString *const kTHNWindowModelProductsRealSalePrice = @"real_sale_price";
NSString *const kTHNWindowModelProductsRid = @"rid";
NSString *const kTHNWindowModelProductsSecondCategoryId = @"second_category_id";
NSString *const kTHNWindowModelProductsStatus = @"status";
NSString *const kTHNWindowModelProductsSticked = @"sticked";
NSString *const kTHNWindowModelProductsStoreLogo = @"store_logo";
NSString *const kTHNWindowModelProductsStoreName = @"store_name";
NSString *const kTHNWindowModelProductsStoreRid = @"store_rid";
NSString *const kTHNWindowModelProductsStyleId = @"style_id";
NSString *const kTHNWindowModelProductsStyleName = @"style_name";
NSString *const kTHNWindowModelProductsTagLine = @"tag_line";
NSString *const kTHNWindowModelProductsTopCategoryId = @"top_category_id";
NSString *const kTHNWindowModelProductsTotalStock = @"total_stock";
NSString *const kTHNWindowModelProductsTown = @"town";

@interface THNWindowModelProducts ()
@end
@implementation THNWindowModelProducts




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNWindowModelProductsBgcover] isKindOfClass:[NSNull class]]){
		self.bgcover = dictionary[kTHNWindowModelProductsBgcover];
	}	
	if(![dictionary[kTHNWindowModelProductsCategoryId] isKindOfClass:[NSNull class]]){
		self.categoryId = [dictionary[kTHNWindowModelProductsCategoryId] integerValue];
	}

	if(![dictionary[kTHNWindowModelProductsCity] isKindOfClass:[NSNull class]]){
		self.city = dictionary[kTHNWindowModelProductsCity];
	}	
	if(![dictionary[kTHNWindowModelProductsCommissionPrice] isKindOfClass:[NSNull class]]){
		self.commissionPrice = [dictionary[kTHNWindowModelProductsCommissionPrice] floatValue];
	}

	if(![dictionary[kTHNWindowModelProductsCommissionRate] isKindOfClass:[NSNull class]]){
		self.commissionRate = [dictionary[kTHNWindowModelProductsCommissionRate] integerValue];
	}

	if(![dictionary[kTHNWindowModelProductsCountry] isKindOfClass:[NSNull class]]){
		self.country = dictionary[kTHNWindowModelProductsCountry];
	}	
	if(![dictionary[kTHNWindowModelProductsCover] isKindOfClass:[NSNull class]]){
		self.cover = dictionary[kTHNWindowModelProductsCover];
	}	
	if(![dictionary[kTHNWindowModelProductsCoverId] isKindOfClass:[NSNull class]]){
		self.coverId = [dictionary[kTHNWindowModelProductsCoverId] integerValue];
	}

	if(![dictionary[kTHNWindowModelProductsCustomDetails] isKindOfClass:[NSNull class]]){
		self.customDetails = dictionary[kTHNWindowModelProductsCustomDetails];
	}	
	if(![dictionary[kTHNWindowModelProductsDeliveryCity] isKindOfClass:[NSNull class]]){
		self.deliveryCity = dictionary[kTHNWindowModelProductsDeliveryCity];
	}	
	if(![dictionary[kTHNWindowModelProductsDeliveryCountry] isKindOfClass:[NSNull class]]){
		self.deliveryCountry = dictionary[kTHNWindowModelProductsDeliveryCountry];
	}	
	if(![dictionary[kTHNWindowModelProductsDeliveryCountryId] isKindOfClass:[NSNull class]]){
		self.deliveryCountryId = [dictionary[kTHNWindowModelProductsDeliveryCountryId] integerValue];
	}

	if(![dictionary[kTHNWindowModelProductsDeliveryProvince] isKindOfClass:[NSNull class]]){
		self.deliveryProvince = dictionary[kTHNWindowModelProductsDeliveryProvince];
	}	
	if(![dictionary[kTHNWindowModelProductsDistributionType] isKindOfClass:[NSNull class]]){
		self.distributionType = [dictionary[kTHNWindowModelProductsDistributionType] integerValue];
	}

	if(![dictionary[kTHNWindowModelProductsFansCount] isKindOfClass:[NSNull class]]){
		self.fansCount = [dictionary[kTHNWindowModelProductsFansCount] integerValue];
	}

	if(![dictionary[kTHNWindowModelProductsFeatures] isKindOfClass:[NSNull class]]){
		self.features = dictionary[kTHNWindowModelProductsFeatures];
	}	
	if(![dictionary[kTHNWindowModelProductsHaveDistributed] isKindOfClass:[NSNull class]]){
		self.haveDistributed = [dictionary[kTHNWindowModelProductsHaveDistributed] boolValue];
	}

	if(![dictionary[kTHNWindowModelProductsIdCode] isKindOfClass:[NSNull class]]){
		self.idCode = dictionary[kTHNWindowModelProductsIdCode];
	}	
	if(![dictionary[kTHNWindowModelProductsIsCustomMade] isKindOfClass:[NSNull class]]){
		self.isCustomMade = [dictionary[kTHNWindowModelProductsIsCustomMade] boolValue];
	}

	if(![dictionary[kTHNWindowModelProductsIsCustomService] isKindOfClass:[NSNull class]]){
		self.isCustomService = [dictionary[kTHNWindowModelProductsIsCustomService] boolValue];
	}

	if(![dictionary[kTHNWindowModelProductsIsDistributed] isKindOfClass:[NSNull class]]){
		self.isDistributed = [dictionary[kTHNWindowModelProductsIsDistributed] boolValue];
	}

	if(![dictionary[kTHNWindowModelProductsIsFreePostage] isKindOfClass:[NSNull class]]){
		self.isFreePostage = [dictionary[kTHNWindowModelProductsIsFreePostage] boolValue];
	}

	if(![dictionary[kTHNWindowModelProductsIsMadeHoliday] isKindOfClass:[NSNull class]]){
		self.isMadeHoliday = [dictionary[kTHNWindowModelProductsIsMadeHoliday] boolValue];
	}

	if(![dictionary[kTHNWindowModelProductsIsProprietary] isKindOfClass:[NSNull class]]){
		self.isProprietary = [dictionary[kTHNWindowModelProductsIsProprietary] boolValue];
	}

	if(![dictionary[kTHNWindowModelProductsIsSoldOut] isKindOfClass:[NSNull class]]){
		self.isSoldOut = [dictionary[kTHNWindowModelProductsIsSoldOut] boolValue];
	}

	if(![dictionary[kTHNWindowModelProductsLikeCount] isKindOfClass:[NSNull class]]){
		self.likeCount = [dictionary[kTHNWindowModelProductsLikeCount] integerValue];
	}

	if(![dictionary[kTHNWindowModelProductsMadeCycle] isKindOfClass:[NSNull class]]){
		self.madeCycle = [dictionary[kTHNWindowModelProductsMadeCycle] integerValue];
	}

	if(![dictionary[kTHNWindowModelProductsMaterialId] isKindOfClass:[NSNull class]]){
		self.materialId = [dictionary[kTHNWindowModelProductsMaterialId] integerValue];
	}

	if(![dictionary[kTHNWindowModelProductsMaterialName] isKindOfClass:[NSNull class]]){
		self.materialName = dictionary[kTHNWindowModelProductsMaterialName];
	}	
	if(![dictionary[kTHNWindowModelProductsMaxPrice] isKindOfClass:[NSNull class]]){
		self.maxPrice = [dictionary[kTHNWindowModelProductsMaxPrice] integerValue];
	}

	if(![dictionary[kTHNWindowModelProductsMaxSalePrice] isKindOfClass:[NSNull class]]){
		self.maxSalePrice = [dictionary[kTHNWindowModelProductsMaxSalePrice] integerValue];
	}

	if(![dictionary[kTHNWindowModelProductsMinPrice] isKindOfClass:[NSNull class]]){
		self.minPrice = [dictionary[kTHNWindowModelProductsMinPrice] integerValue];
	}

	if(![dictionary[kTHNWindowModelProductsMinSalePrice] isKindOfClass:[NSNull class]]){
		self.minSalePrice = [dictionary[kTHNWindowModelProductsMinSalePrice] integerValue];
	}

	if(![dictionary[kTHNWindowModelProductsModes] isKindOfClass:[NSNull class]]){
		self.modes = dictionary[kTHNWindowModelProductsModes];
	}	
	if(![dictionary[kTHNWindowModelProductsName] isKindOfClass:[NSNull class]]){
		self.name = dictionary[kTHNWindowModelProductsName];
	}	
	if(![dictionary[kTHNWindowModelProductsProvince] isKindOfClass:[NSNull class]]){
		self.province = dictionary[kTHNWindowModelProductsProvince];
	}	
	if(![dictionary[kTHNWindowModelProductsPublishedAt] isKindOfClass:[NSNull class]]){
		self.publishedAt = [dictionary[kTHNWindowModelProductsPublishedAt] integerValue];
	}

	if(![dictionary[kTHNWindowModelProductsRealPrice] isKindOfClass:[NSNull class]]){
		self.realPrice = [dictionary[kTHNWindowModelProductsRealPrice] integerValue];
	}

	if(![dictionary[kTHNWindowModelProductsRealSalePrice] isKindOfClass:[NSNull class]]){
		self.realSalePrice = [dictionary[kTHNWindowModelProductsRealSalePrice] integerValue];
	}

	if(![dictionary[kTHNWindowModelProductsRid] isKindOfClass:[NSNull class]]){
		self.rid = dictionary[kTHNWindowModelProductsRid];
	}	
	if(![dictionary[kTHNWindowModelProductsSecondCategoryId] isKindOfClass:[NSNull class]]){
		self.secondCategoryId = [dictionary[kTHNWindowModelProductsSecondCategoryId] integerValue];
	}

	if(![dictionary[kTHNWindowModelProductsStatus] isKindOfClass:[NSNull class]]){
		self.status = [dictionary[kTHNWindowModelProductsStatus] integerValue];
	}

	if(![dictionary[kTHNWindowModelProductsSticked] isKindOfClass:[NSNull class]]){
		self.sticked = [dictionary[kTHNWindowModelProductsSticked] boolValue];
	}

	if(![dictionary[kTHNWindowModelProductsStoreLogo] isKindOfClass:[NSNull class]]){
		self.storeLogo = dictionary[kTHNWindowModelProductsStoreLogo];
	}	
	if(![dictionary[kTHNWindowModelProductsStoreName] isKindOfClass:[NSNull class]]){
		self.storeName = dictionary[kTHNWindowModelProductsStoreName];
	}	
	if(![dictionary[kTHNWindowModelProductsStoreRid] isKindOfClass:[NSNull class]]){
		self.storeRid = dictionary[kTHNWindowModelProductsStoreRid];
	}	
	if(![dictionary[kTHNWindowModelProductsStyleId] isKindOfClass:[NSNull class]]){
		self.styleId = [dictionary[kTHNWindowModelProductsStyleId] integerValue];
	}

	if(![dictionary[kTHNWindowModelProductsStyleName] isKindOfClass:[NSNull class]]){
		self.styleName = dictionary[kTHNWindowModelProductsStyleName];
	}	
	if(![dictionary[kTHNWindowModelProductsTagLine] isKindOfClass:[NSNull class]]){
		self.tagLine = dictionary[kTHNWindowModelProductsTagLine];
	}	
	if(![dictionary[kTHNWindowModelProductsTopCategoryId] isKindOfClass:[NSNull class]]){
		self.topCategoryId = [dictionary[kTHNWindowModelProductsTopCategoryId] integerValue];
	}

	if(![dictionary[kTHNWindowModelProductsTotalStock] isKindOfClass:[NSNull class]]){
		self.totalStock = [dictionary[kTHNWindowModelProductsTotalStock] integerValue];
	}

	if(![dictionary[kTHNWindowModelProductsTown] isKindOfClass:[NSNull class]]){
		self.town = dictionary[kTHNWindowModelProductsTown];
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
		dictionary[kTHNWindowModelProductsBgcover] = self.bgcover;
	}
	dictionary[kTHNWindowModelProductsCategoryId] = @(self.categoryId);
	if(self.city != nil){
		dictionary[kTHNWindowModelProductsCity] = self.city;
	}
	dictionary[kTHNWindowModelProductsCommissionPrice] = @(self.commissionPrice);
	dictionary[kTHNWindowModelProductsCommissionRate] = @(self.commissionRate);
	if(self.country != nil){
		dictionary[kTHNWindowModelProductsCountry] = self.country;
	}
	if(self.cover != nil){
		dictionary[kTHNWindowModelProductsCover] = self.cover;
	}
	dictionary[kTHNWindowModelProductsCoverId] = @(self.coverId);
	if(self.customDetails != nil){
		dictionary[kTHNWindowModelProductsCustomDetails] = self.customDetails;
	}
	if(self.deliveryCity != nil){
		dictionary[kTHNWindowModelProductsDeliveryCity] = self.deliveryCity;
	}
	if(self.deliveryCountry != nil){
		dictionary[kTHNWindowModelProductsDeliveryCountry] = self.deliveryCountry;
	}
	dictionary[kTHNWindowModelProductsDeliveryCountryId] = @(self.deliveryCountryId);
	if(self.deliveryProvince != nil){
		dictionary[kTHNWindowModelProductsDeliveryProvince] = self.deliveryProvince;
	}
	dictionary[kTHNWindowModelProductsDistributionType] = @(self.distributionType);
	dictionary[kTHNWindowModelProductsFansCount] = @(self.fansCount);
	if(self.features != nil){
		dictionary[kTHNWindowModelProductsFeatures] = self.features;
	}
	dictionary[kTHNWindowModelProductsHaveDistributed] = @(self.haveDistributed);
	if(self.idCode != nil){
		dictionary[kTHNWindowModelProductsIdCode] = self.idCode;
	}
	dictionary[kTHNWindowModelProductsIsCustomMade] = @(self.isCustomMade);
	dictionary[kTHNWindowModelProductsIsCustomService] = @(self.isCustomService);
	dictionary[kTHNWindowModelProductsIsDistributed] = @(self.isDistributed);
	dictionary[kTHNWindowModelProductsIsFreePostage] = @(self.isFreePostage);
	dictionary[kTHNWindowModelProductsIsMadeHoliday] = @(self.isMadeHoliday);
	dictionary[kTHNWindowModelProductsIsProprietary] = @(self.isProprietary);
	dictionary[kTHNWindowModelProductsIsSoldOut] = @(self.isSoldOut);
	dictionary[kTHNWindowModelProductsLikeCount] = @(self.likeCount);
	dictionary[kTHNWindowModelProductsMadeCycle] = @(self.madeCycle);
	dictionary[kTHNWindowModelProductsMaterialId] = @(self.materialId);
	if(self.materialName != nil){
		dictionary[kTHNWindowModelProductsMaterialName] = self.materialName;
	}
	dictionary[kTHNWindowModelProductsMaxPrice] = @(self.maxPrice);
	dictionary[kTHNWindowModelProductsMaxSalePrice] = @(self.maxSalePrice);
	dictionary[kTHNWindowModelProductsMinPrice] = @(self.minPrice);
	dictionary[kTHNWindowModelProductsMinSalePrice] = @(self.minSalePrice);
	if(self.modes != nil){
		dictionary[kTHNWindowModelProductsModes] = self.modes;
	}
	if(self.name != nil){
		dictionary[kTHNWindowModelProductsName] = self.name;
	}
	if(self.province != nil){
		dictionary[kTHNWindowModelProductsProvince] = self.province;
	}
	dictionary[kTHNWindowModelProductsPublishedAt] = @(self.publishedAt);
	dictionary[kTHNWindowModelProductsRealPrice] = @(self.realPrice);
	dictionary[kTHNWindowModelProductsRealSalePrice] = @(self.realSalePrice);
	if(self.rid != nil){
		dictionary[kTHNWindowModelProductsRid] = self.rid;
	}
	dictionary[kTHNWindowModelProductsSecondCategoryId] = @(self.secondCategoryId);
	dictionary[kTHNWindowModelProductsStatus] = @(self.status);
	dictionary[kTHNWindowModelProductsSticked] = @(self.sticked);
	if(self.storeLogo != nil){
		dictionary[kTHNWindowModelProductsStoreLogo] = self.storeLogo;
	}
	if(self.storeName != nil){
		dictionary[kTHNWindowModelProductsStoreName] = self.storeName;
	}
	if(self.storeRid != nil){
		dictionary[kTHNWindowModelProductsStoreRid] = self.storeRid;
	}
	dictionary[kTHNWindowModelProductsStyleId] = @(self.styleId);
	if(self.styleName != nil){
		dictionary[kTHNWindowModelProductsStyleName] = self.styleName;
	}
	if(self.tagLine != nil){
		dictionary[kTHNWindowModelProductsTagLine] = self.tagLine;
	}
	dictionary[kTHNWindowModelProductsTopCategoryId] = @(self.topCategoryId);
	dictionary[kTHNWindowModelProductsTotalStock] = @(self.totalStock);
	if(self.town != nil){
		dictionary[kTHNWindowModelProductsTown] = self.town;
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
		[aCoder encodeObject:self.bgcover forKey:kTHNWindowModelProductsBgcover];
	}
	[aCoder encodeObject:@(self.categoryId) forKey:kTHNWindowModelProductsCategoryId];	if(self.city != nil){
		[aCoder encodeObject:self.city forKey:kTHNWindowModelProductsCity];
	}
	[aCoder encodeObject:@(self.commissionPrice) forKey:kTHNWindowModelProductsCommissionPrice];	[aCoder encodeObject:@(self.commissionRate) forKey:kTHNWindowModelProductsCommissionRate];	if(self.country != nil){
		[aCoder encodeObject:self.country forKey:kTHNWindowModelProductsCountry];
	}
	if(self.cover != nil){
		[aCoder encodeObject:self.cover forKey:kTHNWindowModelProductsCover];
	}
	[aCoder encodeObject:@(self.coverId) forKey:kTHNWindowModelProductsCoverId];	if(self.customDetails != nil){
		[aCoder encodeObject:self.customDetails forKey:kTHNWindowModelProductsCustomDetails];
	}
	if(self.deliveryCity != nil){
		[aCoder encodeObject:self.deliveryCity forKey:kTHNWindowModelProductsDeliveryCity];
	}
	if(self.deliveryCountry != nil){
		[aCoder encodeObject:self.deliveryCountry forKey:kTHNWindowModelProductsDeliveryCountry];
	}
	[aCoder encodeObject:@(self.deliveryCountryId) forKey:kTHNWindowModelProductsDeliveryCountryId];	if(self.deliveryProvince != nil){
		[aCoder encodeObject:self.deliveryProvince forKey:kTHNWindowModelProductsDeliveryProvince];
	}
	[aCoder encodeObject:@(self.distributionType) forKey:kTHNWindowModelProductsDistributionType];	[aCoder encodeObject:@(self.fansCount) forKey:kTHNWindowModelProductsFansCount];	if(self.features != nil){
		[aCoder encodeObject:self.features forKey:kTHNWindowModelProductsFeatures];
	}
	[aCoder encodeObject:@(self.haveDistributed) forKey:kTHNWindowModelProductsHaveDistributed];	if(self.idCode != nil){
		[aCoder encodeObject:self.idCode forKey:kTHNWindowModelProductsIdCode];
	}
	[aCoder encodeObject:@(self.isCustomMade) forKey:kTHNWindowModelProductsIsCustomMade];	[aCoder encodeObject:@(self.isCustomService) forKey:kTHNWindowModelProductsIsCustomService];	[aCoder encodeObject:@(self.isDistributed) forKey:kTHNWindowModelProductsIsDistributed];	[aCoder encodeObject:@(self.isFreePostage) forKey:kTHNWindowModelProductsIsFreePostage];	[aCoder encodeObject:@(self.isMadeHoliday) forKey:kTHNWindowModelProductsIsMadeHoliday];	[aCoder encodeObject:@(self.isProprietary) forKey:kTHNWindowModelProductsIsProprietary];	[aCoder encodeObject:@(self.isSoldOut) forKey:kTHNWindowModelProductsIsSoldOut];	[aCoder encodeObject:@(self.likeCount) forKey:kTHNWindowModelProductsLikeCount];	[aCoder encodeObject:@(self.madeCycle) forKey:kTHNWindowModelProductsMadeCycle];	[aCoder encodeObject:@(self.materialId) forKey:kTHNWindowModelProductsMaterialId];	if(self.materialName != nil){
		[aCoder encodeObject:self.materialName forKey:kTHNWindowModelProductsMaterialName];
	}
	[aCoder encodeObject:@(self.maxPrice) forKey:kTHNWindowModelProductsMaxPrice];	[aCoder encodeObject:@(self.maxSalePrice) forKey:kTHNWindowModelProductsMaxSalePrice];	[aCoder encodeObject:@(self.minPrice) forKey:kTHNWindowModelProductsMinPrice];	[aCoder encodeObject:@(self.minSalePrice) forKey:kTHNWindowModelProductsMinSalePrice];	if(self.modes != nil){
		[aCoder encodeObject:self.modes forKey:kTHNWindowModelProductsModes];
	}
	if(self.name != nil){
		[aCoder encodeObject:self.name forKey:kTHNWindowModelProductsName];
	}
	if(self.province != nil){
		[aCoder encodeObject:self.province forKey:kTHNWindowModelProductsProvince];
	}
	[aCoder encodeObject:@(self.publishedAt) forKey:kTHNWindowModelProductsPublishedAt];	[aCoder encodeObject:@(self.realPrice) forKey:kTHNWindowModelProductsRealPrice];	[aCoder encodeObject:@(self.realSalePrice) forKey:kTHNWindowModelProductsRealSalePrice];	if(self.rid != nil){
		[aCoder encodeObject:self.rid forKey:kTHNWindowModelProductsRid];
	}
	[aCoder encodeObject:@(self.secondCategoryId) forKey:kTHNWindowModelProductsSecondCategoryId];	[aCoder encodeObject:@(self.status) forKey:kTHNWindowModelProductsStatus];	[aCoder encodeObject:@(self.sticked) forKey:kTHNWindowModelProductsSticked];	if(self.storeLogo != nil){
		[aCoder encodeObject:self.storeLogo forKey:kTHNWindowModelProductsStoreLogo];
	}
	if(self.storeName != nil){
		[aCoder encodeObject:self.storeName forKey:kTHNWindowModelProductsStoreName];
	}
	if(self.storeRid != nil){
		[aCoder encodeObject:self.storeRid forKey:kTHNWindowModelProductsStoreRid];
	}
	[aCoder encodeObject:@(self.styleId) forKey:kTHNWindowModelProductsStyleId];	if(self.styleName != nil){
		[aCoder encodeObject:self.styleName forKey:kTHNWindowModelProductsStyleName];
	}
	if(self.tagLine != nil){
		[aCoder encodeObject:self.tagLine forKey:kTHNWindowModelProductsTagLine];
	}
	[aCoder encodeObject:@(self.topCategoryId) forKey:kTHNWindowModelProductsTopCategoryId];	[aCoder encodeObject:@(self.totalStock) forKey:kTHNWindowModelProductsTotalStock];	if(self.town != nil){
		[aCoder encodeObject:self.town forKey:kTHNWindowModelProductsTown];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.bgcover = [aDecoder decodeObjectForKey:kTHNWindowModelProductsBgcover];
	self.categoryId = [[aDecoder decodeObjectForKey:kTHNWindowModelProductsCategoryId] integerValue];
	self.city = [aDecoder decodeObjectForKey:kTHNWindowModelProductsCity];
	self.commissionPrice = [[aDecoder decodeObjectForKey:kTHNWindowModelProductsCommissionPrice] floatValue];
	self.commissionRate = [[aDecoder decodeObjectForKey:kTHNWindowModelProductsCommissionRate] integerValue];
	self.country = [aDecoder decodeObjectForKey:kTHNWindowModelProductsCountry];
	self.cover = [aDecoder decodeObjectForKey:kTHNWindowModelProductsCover];
	self.coverId = [[aDecoder decodeObjectForKey:kTHNWindowModelProductsCoverId] integerValue];
	self.customDetails = [aDecoder decodeObjectForKey:kTHNWindowModelProductsCustomDetails];
	self.deliveryCity = [aDecoder decodeObjectForKey:kTHNWindowModelProductsDeliveryCity];
	self.deliveryCountry = [aDecoder decodeObjectForKey:kTHNWindowModelProductsDeliveryCountry];
	self.deliveryCountryId = [[aDecoder decodeObjectForKey:kTHNWindowModelProductsDeliveryCountryId] integerValue];
	self.deliveryProvince = [aDecoder decodeObjectForKey:kTHNWindowModelProductsDeliveryProvince];
	self.distributionType = [[aDecoder decodeObjectForKey:kTHNWindowModelProductsDistributionType] integerValue];
	self.fansCount = [[aDecoder decodeObjectForKey:kTHNWindowModelProductsFansCount] integerValue];
	self.features = [aDecoder decodeObjectForKey:kTHNWindowModelProductsFeatures];
	self.haveDistributed = [[aDecoder decodeObjectForKey:kTHNWindowModelProductsHaveDistributed] boolValue];
	self.idCode = [aDecoder decodeObjectForKey:kTHNWindowModelProductsIdCode];
	self.isCustomMade = [[aDecoder decodeObjectForKey:kTHNWindowModelProductsIsCustomMade] boolValue];
	self.isCustomService = [[aDecoder decodeObjectForKey:kTHNWindowModelProductsIsCustomService] boolValue];
	self.isDistributed = [[aDecoder decodeObjectForKey:kTHNWindowModelProductsIsDistributed] boolValue];
	self.isFreePostage = [[aDecoder decodeObjectForKey:kTHNWindowModelProductsIsFreePostage] boolValue];
	self.isMadeHoliday = [[aDecoder decodeObjectForKey:kTHNWindowModelProductsIsMadeHoliday] boolValue];
	self.isProprietary = [[aDecoder decodeObjectForKey:kTHNWindowModelProductsIsProprietary] boolValue];
	self.isSoldOut = [[aDecoder decodeObjectForKey:kTHNWindowModelProductsIsSoldOut] boolValue];
	self.likeCount = [[aDecoder decodeObjectForKey:kTHNWindowModelProductsLikeCount] integerValue];
	self.madeCycle = [[aDecoder decodeObjectForKey:kTHNWindowModelProductsMadeCycle] integerValue];
	self.materialId = [[aDecoder decodeObjectForKey:kTHNWindowModelProductsMaterialId] integerValue];
	self.materialName = [aDecoder decodeObjectForKey:kTHNWindowModelProductsMaterialName];
	self.maxPrice = [[aDecoder decodeObjectForKey:kTHNWindowModelProductsMaxPrice] integerValue];
	self.maxSalePrice = [[aDecoder decodeObjectForKey:kTHNWindowModelProductsMaxSalePrice] integerValue];
	self.minPrice = [[aDecoder decodeObjectForKey:kTHNWindowModelProductsMinPrice] integerValue];
	self.minSalePrice = [[aDecoder decodeObjectForKey:kTHNWindowModelProductsMinSalePrice] integerValue];
	self.modes = [aDecoder decodeObjectForKey:kTHNWindowModelProductsModes];
	self.name = [aDecoder decodeObjectForKey:kTHNWindowModelProductsName];
	self.province = [aDecoder decodeObjectForKey:kTHNWindowModelProductsProvince];
	self.publishedAt = [[aDecoder decodeObjectForKey:kTHNWindowModelProductsPublishedAt] integerValue];
	self.realPrice = [[aDecoder decodeObjectForKey:kTHNWindowModelProductsRealPrice] integerValue];
	self.realSalePrice = [[aDecoder decodeObjectForKey:kTHNWindowModelProductsRealSalePrice] integerValue];
	self.rid = [aDecoder decodeObjectForKey:kTHNWindowModelProductsRid];
	self.secondCategoryId = [[aDecoder decodeObjectForKey:kTHNWindowModelProductsSecondCategoryId] integerValue];
	self.status = [[aDecoder decodeObjectForKey:kTHNWindowModelProductsStatus] integerValue];
	self.sticked = [[aDecoder decodeObjectForKey:kTHNWindowModelProductsSticked] boolValue];
	self.storeLogo = [aDecoder decodeObjectForKey:kTHNWindowModelProductsStoreLogo];
	self.storeName = [aDecoder decodeObjectForKey:kTHNWindowModelProductsStoreName];
	self.storeRid = [aDecoder decodeObjectForKey:kTHNWindowModelProductsStoreRid];
	self.styleId = [[aDecoder decodeObjectForKey:kTHNWindowModelProductsStyleId] integerValue];
	self.styleName = [aDecoder decodeObjectForKey:kTHNWindowModelProductsStyleName];
	self.tagLine = [aDecoder decodeObjectForKey:kTHNWindowModelProductsTagLine];
	self.topCategoryId = [[aDecoder decodeObjectForKey:kTHNWindowModelProductsTopCategoryId] integerValue];
	self.totalStock = [[aDecoder decodeObjectForKey:kTHNWindowModelProductsTotalStock] integerValue];
	self.town = [aDecoder decodeObjectForKey:kTHNWindowModelProductsTown];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	THNWindowModelProducts *copy = [THNWindowModelProducts new];

	copy.bgcover = [self.bgcover copy];
	copy.categoryId = self.categoryId;
	copy.city = [self.city copy];
	copy.commissionPrice = self.commissionPrice;
	copy.commissionRate = self.commissionRate;
	copy.country = [self.country copy];
	copy.cover = [self.cover copy];
	copy.coverId = self.coverId;
	copy.customDetails = [self.customDetails copy];
	copy.deliveryCity = [self.deliveryCity copy];
	copy.deliveryCountry = [self.deliveryCountry copy];
	copy.deliveryCountryId = self.deliveryCountryId;
	copy.deliveryProvince = [self.deliveryProvince copy];
	copy.distributionType = self.distributionType;
	copy.fansCount = self.fansCount;
	copy.features = [self.features copy];
	copy.haveDistributed = self.haveDistributed;
	copy.idCode = [self.idCode copy];
	copy.isCustomMade = self.isCustomMade;
	copy.isCustomService = self.isCustomService;
	copy.isDistributed = self.isDistributed;
	copy.isFreePostage = self.isFreePostage;
	copy.isMadeHoliday = self.isMadeHoliday;
	copy.isProprietary = self.isProprietary;
	copy.isSoldOut = self.isSoldOut;
	copy.likeCount = self.likeCount;
	copy.madeCycle = self.madeCycle;
	copy.materialId = self.materialId;
	copy.materialName = [self.materialName copy];
	copy.maxPrice = self.maxPrice;
	copy.maxSalePrice = self.maxSalePrice;
	copy.minPrice = self.minPrice;
	copy.minSalePrice = self.minSalePrice;
	copy.modes = [self.modes copy];
	copy.name = [self.name copy];
	copy.province = [self.province copy];
	copy.publishedAt = self.publishedAt;
	copy.realPrice = self.realPrice;
	copy.realSalePrice = self.realSalePrice;
	copy.rid = [self.rid copy];
	copy.secondCategoryId = self.secondCategoryId;
	copy.status = self.status;
	copy.sticked = self.sticked;
	copy.storeLogo = [self.storeLogo copy];
	copy.storeName = [self.storeName copy];
	copy.storeRid = [self.storeRid copy];
	copy.styleId = self.styleId;
	copy.styleName = [self.styleName copy];
	copy.tagLine = [self.tagLine copy];
	copy.topCategoryId = self.topCategoryId;
	copy.totalStock = self.totalStock;
	copy.town = [self.town copy];

	return copy;
}
@end