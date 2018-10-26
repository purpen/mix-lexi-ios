//
//	THNStoreModelProduct.m
//  on 1/9/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNStoreModelProduct.h"

NSString *const kTHNStoreModelProductBgcover = @"bgcover";
NSString *const kTHNStoreModelProductCategoryId = @"category_id";
NSString *const kTHNStoreModelProductCity = @"city";
NSString *const kTHNStoreModelProductCommissionPrice = @"commission_price";
NSString *const kTHNStoreModelProductCommissionRate = @"commission_rate";
NSString *const kTHNStoreModelProductCountry = @"country";
NSString *const kTHNStoreModelProductCover = @"cover";
NSString *const kTHNStoreModelProductCoverId = @"cover_id";
NSString *const kTHNStoreModelProductCustomDetails = @"custom_details";
NSString *const kTHNStoreModelProductDeliveryCity = @"delivery_city";
NSString *const kTHNStoreModelProductDeliveryCountry = @"delivery_country";
NSString *const kTHNStoreModelProductDeliveryCountryId = @"delivery_country_id";
NSString *const kTHNStoreModelProductDeliveryProvince = @"delivery_province";
NSString *const kTHNStoreModelProductDistributionType = @"distribution_type";
NSString *const kTHNStoreModelProductFansCount = @"fans_count";
NSString *const kTHNStoreModelProductFeatures = @"features";
NSString *const kTHNStoreModelProductHaveDistributed = @"have_distributed";
NSString *const kTHNStoreModelProductIdCode = @"id_code";
NSString *const kTHNStoreModelProductIsCustomMade = @"is_custom_made";
NSString *const kTHNStoreModelProductIsCustomService = @"is_custom_service";
NSString *const kTHNStoreModelProductIsDistributed = @"is_distributed";
NSString *const kTHNStoreModelProductIsFreePostage = @"is_free_postage";
NSString *const kTHNStoreModelProductIsMadeHoliday = @"is_made_holiday";
NSString *const kTHNStoreModelProductIsProprietary = @"is_proprietary";
NSString *const kTHNStoreModelProductIsSoldOut = @"is_sold_out";
NSString *const kTHNStoreModelProductLikeCount = @"like_count";
NSString *const kTHNStoreModelProductMadeCycle = @"made_cycle";
NSString *const kTHNStoreModelProductMaterialId = @"material_id";
NSString *const kTHNStoreModelProductMaterialName = @"material_name";
NSString *const kTHNStoreModelProductMaxPrice = @"max_price";
NSString *const kTHNStoreModelProductMaxSalePrice = @"max_sale_price";
NSString *const kTHNStoreModelProductMinPrice = @"min_price";
NSString *const kTHNStoreModelProductMinSalePrice = @"min_sale_price";
NSString *const kTHNStoreModelProductModes = @"modes";
NSString *const kTHNStoreModelProductName = @"name";
NSString *const kTHNStoreModelProductProvince = @"province";
NSString *const kTHNStoreModelProductPublishedAt = @"published_at";
NSString *const kTHNStoreModelProductRealPrice = @"real_price";
NSString *const kTHNStoreModelProductRealSalePrice = @"real_sale_price";
NSString *const kTHNStoreModelProductRid = @"rid";
NSString *const kTHNStoreModelProductSecondCategoryId = @"second_category_id";
NSString *const kTHNStoreModelProductStatus = @"status";
NSString *const kTHNStoreModelProductSticked = @"sticked";
NSString *const kTHNStoreModelProductStoreLogo = @"store_logo";
NSString *const kTHNStoreModelProductStoreName = @"store_name";
NSString *const kTHNStoreModelProductStoreRid = @"store_rid";
NSString *const kTHNStoreModelProductStyleId = @"style_id";
NSString *const kTHNStoreModelProductStyleName = @"style_name";
NSString *const kTHNStoreModelProductTagLine = @"tag_line";
NSString *const kTHNStoreModelProductTopCategoryId = @"top_category_id";
NSString *const kTHNStoreModelProductTotalStock = @"total_stock";
NSString *const kTHNStoreModelProductTown = @"town";

@interface THNStoreModelProduct ()
@end
@implementation THNStoreModelProduct




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNStoreModelProductBgcover] isKindOfClass:[NSNull class]]){
		self.bgcover = dictionary[kTHNStoreModelProductBgcover];
	}	
	if(![dictionary[kTHNStoreModelProductCategoryId] isKindOfClass:[NSNull class]]){
		self.categoryId = [dictionary[kTHNStoreModelProductCategoryId] integerValue];
	}

	if(![dictionary[kTHNStoreModelProductCity] isKindOfClass:[NSNull class]]){
		self.city = dictionary[kTHNStoreModelProductCity];
	}	
	if(![dictionary[kTHNStoreModelProductCommissionPrice] isKindOfClass:[NSNull class]]){
		self.commissionPrice = [dictionary[kTHNStoreModelProductCommissionPrice] floatValue];
	}

	if(![dictionary[kTHNStoreModelProductCommissionRate] isKindOfClass:[NSNull class]]){
		self.commissionRate = [dictionary[kTHNStoreModelProductCommissionRate] integerValue];
	}

	if(![dictionary[kTHNStoreModelProductCountry] isKindOfClass:[NSNull class]]){
		self.country = dictionary[kTHNStoreModelProductCountry];
	}	
	if(![dictionary[kTHNStoreModelProductCover] isKindOfClass:[NSNull class]]){
		self.cover = dictionary[kTHNStoreModelProductCover];
	}	
	if(![dictionary[kTHNStoreModelProductCoverId] isKindOfClass:[NSNull class]]){
		self.coverId = [dictionary[kTHNStoreModelProductCoverId] integerValue];
	}

	if(![dictionary[kTHNStoreModelProductCustomDetails] isKindOfClass:[NSNull class]]){
		self.customDetails = dictionary[kTHNStoreModelProductCustomDetails];
	}	
	if(![dictionary[kTHNStoreModelProductDeliveryCity] isKindOfClass:[NSNull class]]){
		self.deliveryCity = dictionary[kTHNStoreModelProductDeliveryCity];
	}	
	if(![dictionary[kTHNStoreModelProductDeliveryCountry] isKindOfClass:[NSNull class]]){
		self.deliveryCountry = dictionary[kTHNStoreModelProductDeliveryCountry];
	}	
	if(![dictionary[kTHNStoreModelProductDeliveryCountryId] isKindOfClass:[NSNull class]]){
		self.deliveryCountryId = [dictionary[kTHNStoreModelProductDeliveryCountryId] integerValue];
	}

	if(![dictionary[kTHNStoreModelProductDeliveryProvince] isKindOfClass:[NSNull class]]){
		self.deliveryProvince = dictionary[kTHNStoreModelProductDeliveryProvince];
	}	
	if(![dictionary[kTHNStoreModelProductDistributionType] isKindOfClass:[NSNull class]]){
		self.distributionType = [dictionary[kTHNStoreModelProductDistributionType] integerValue];
	}

	if(![dictionary[kTHNStoreModelProductFansCount] isKindOfClass:[NSNull class]]){
		self.fansCount = [dictionary[kTHNStoreModelProductFansCount] integerValue];
	}

	if(![dictionary[kTHNStoreModelProductFeatures] isKindOfClass:[NSNull class]]){
		self.features = dictionary[kTHNStoreModelProductFeatures];
	}	
	if(![dictionary[kTHNStoreModelProductHaveDistributed] isKindOfClass:[NSNull class]]){
		self.haveDistributed = [dictionary[kTHNStoreModelProductHaveDistributed] boolValue];
	}

	if(![dictionary[kTHNStoreModelProductIdCode] isKindOfClass:[NSNull class]]){
		self.idCode = dictionary[kTHNStoreModelProductIdCode];
	}	
	if(![dictionary[kTHNStoreModelProductIsCustomMade] isKindOfClass:[NSNull class]]){
		self.isCustomMade = [dictionary[kTHNStoreModelProductIsCustomMade] boolValue];
	}

	if(![dictionary[kTHNStoreModelProductIsCustomService] isKindOfClass:[NSNull class]]){
		self.isCustomService = [dictionary[kTHNStoreModelProductIsCustomService] boolValue];
	}

	if(![dictionary[kTHNStoreModelProductIsDistributed] isKindOfClass:[NSNull class]]){
		self.isDistributed = [dictionary[kTHNStoreModelProductIsDistributed] boolValue];
	}

	if(![dictionary[kTHNStoreModelProductIsFreePostage] isKindOfClass:[NSNull class]]){
		self.isFreePostage = [dictionary[kTHNStoreModelProductIsFreePostage] boolValue];
	}

	if(![dictionary[kTHNStoreModelProductIsMadeHoliday] isKindOfClass:[NSNull class]]){
		self.isMadeHoliday = [dictionary[kTHNStoreModelProductIsMadeHoliday] boolValue];
	}

	if(![dictionary[kTHNStoreModelProductIsProprietary] isKindOfClass:[NSNull class]]){
		self.isProprietary = [dictionary[kTHNStoreModelProductIsProprietary] boolValue];
	}

	if(![dictionary[kTHNStoreModelProductIsSoldOut] isKindOfClass:[NSNull class]]){
		self.isSoldOut = [dictionary[kTHNStoreModelProductIsSoldOut] boolValue];
	}

	if(![dictionary[kTHNStoreModelProductLikeCount] isKindOfClass:[NSNull class]]){
		self.likeCount = [dictionary[kTHNStoreModelProductLikeCount] integerValue];
	}

	if(![dictionary[kTHNStoreModelProductMadeCycle] isKindOfClass:[NSNull class]]){
		self.madeCycle = [dictionary[kTHNStoreModelProductMadeCycle] integerValue];
	}

	if(![dictionary[kTHNStoreModelProductMaterialId] isKindOfClass:[NSNull class]]){
		self.materialId = [dictionary[kTHNStoreModelProductMaterialId] integerValue];
	}

	if(![dictionary[kTHNStoreModelProductMaterialName] isKindOfClass:[NSNull class]]){
		self.materialName = dictionary[kTHNStoreModelProductMaterialName];
	}	
	if(![dictionary[kTHNStoreModelProductMaxPrice] isKindOfClass:[NSNull class]]){
		self.maxPrice = [dictionary[kTHNStoreModelProductMaxPrice] integerValue];
	}

	if(![dictionary[kTHNStoreModelProductMaxSalePrice] isKindOfClass:[NSNull class]]){
		self.maxSalePrice = [dictionary[kTHNStoreModelProductMaxSalePrice] integerValue];
	}

	if(![dictionary[kTHNStoreModelProductMinPrice] isKindOfClass:[NSNull class]]){
		self.minPrice = [dictionary[kTHNStoreModelProductMinPrice] integerValue];
	}

	if(![dictionary[kTHNStoreModelProductMinSalePrice] isKindOfClass:[NSNull class]]){
		self.minSalePrice = [dictionary[kTHNStoreModelProductMinSalePrice] integerValue];
	}

	if(![dictionary[kTHNStoreModelProductModes] isKindOfClass:[NSNull class]]){
		self.modes = dictionary[kTHNStoreModelProductModes];
	}	
	if(![dictionary[kTHNStoreModelProductName] isKindOfClass:[NSNull class]]){
		self.name = dictionary[kTHNStoreModelProductName];
	}	
	if(![dictionary[kTHNStoreModelProductProvince] isKindOfClass:[NSNull class]]){
		self.province = dictionary[kTHNStoreModelProductProvince];
	}	
	if(![dictionary[kTHNStoreModelProductPublishedAt] isKindOfClass:[NSNull class]]){
		self.publishedAt = [dictionary[kTHNStoreModelProductPublishedAt] integerValue];
	}

	if(![dictionary[kTHNStoreModelProductRealPrice] isKindOfClass:[NSNull class]]){
		self.realPrice = [dictionary[kTHNStoreModelProductRealPrice] integerValue];
	}

	if(![dictionary[kTHNStoreModelProductRealSalePrice] isKindOfClass:[NSNull class]]){
		self.realSalePrice = [dictionary[kTHNStoreModelProductRealSalePrice] integerValue];
	}

	if(![dictionary[kTHNStoreModelProductRid] isKindOfClass:[NSNull class]]){
		self.rid = dictionary[kTHNStoreModelProductRid];
	}	
	if(![dictionary[kTHNStoreModelProductSecondCategoryId] isKindOfClass:[NSNull class]]){
		self.secondCategoryId = [dictionary[kTHNStoreModelProductSecondCategoryId] integerValue];
	}

	if(![dictionary[kTHNStoreModelProductStatus] isKindOfClass:[NSNull class]]){
		self.status = [dictionary[kTHNStoreModelProductStatus] integerValue];
	}

	if(![dictionary[kTHNStoreModelProductSticked] isKindOfClass:[NSNull class]]){
		self.sticked = [dictionary[kTHNStoreModelProductSticked] boolValue];
	}

	if(![dictionary[kTHNStoreModelProductStoreLogo] isKindOfClass:[NSNull class]]){
		self.storeLogo = dictionary[kTHNStoreModelProductStoreLogo];
	}	
	if(![dictionary[kTHNStoreModelProductStoreName] isKindOfClass:[NSNull class]]){
		self.storeName = dictionary[kTHNStoreModelProductStoreName];
	}	
	if(![dictionary[kTHNStoreModelProductStoreRid] isKindOfClass:[NSNull class]]){
		self.storeRid = dictionary[kTHNStoreModelProductStoreRid];
	}	
	if(![dictionary[kTHNStoreModelProductStyleId] isKindOfClass:[NSNull class]]){
		self.styleId = [dictionary[kTHNStoreModelProductStyleId] integerValue];
	}

	if(![dictionary[kTHNStoreModelProductStyleName] isKindOfClass:[NSNull class]]){
		self.styleName = dictionary[kTHNStoreModelProductStyleName];
	}	
	if(![dictionary[kTHNStoreModelProductTagLine] isKindOfClass:[NSNull class]]){
		self.tagLine = dictionary[kTHNStoreModelProductTagLine];
	}	
	if(![dictionary[kTHNStoreModelProductTopCategoryId] isKindOfClass:[NSNull class]]){
		self.topCategoryId = [dictionary[kTHNStoreModelProductTopCategoryId] integerValue];
	}

	if(![dictionary[kTHNStoreModelProductTotalStock] isKindOfClass:[NSNull class]]){
		self.totalStock = [dictionary[kTHNStoreModelProductTotalStock] integerValue];
	}

	if(![dictionary[kTHNStoreModelProductTown] isKindOfClass:[NSNull class]]){
		self.town = dictionary[kTHNStoreModelProductTown];
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
		dictionary[kTHNStoreModelProductBgcover] = self.bgcover;
	}
	dictionary[kTHNStoreModelProductCategoryId] = @(self.categoryId);
	if(self.city != nil){
		dictionary[kTHNStoreModelProductCity] = self.city;
	}
	dictionary[kTHNStoreModelProductCommissionPrice] = @(self.commissionPrice);
	dictionary[kTHNStoreModelProductCommissionRate] = @(self.commissionRate);
	if(self.country != nil){
		dictionary[kTHNStoreModelProductCountry] = self.country;
	}
	if(self.cover != nil){
		dictionary[kTHNStoreModelProductCover] = self.cover;
	}
	dictionary[kTHNStoreModelProductCoverId] = @(self.coverId);
	if(self.customDetails != nil){
		dictionary[kTHNStoreModelProductCustomDetails] = self.customDetails;
	}
	if(self.deliveryCity != nil){
		dictionary[kTHNStoreModelProductDeliveryCity] = self.deliveryCity;
	}
	if(self.deliveryCountry != nil){
		dictionary[kTHNStoreModelProductDeliveryCountry] = self.deliveryCountry;
	}
	dictionary[kTHNStoreModelProductDeliveryCountryId] = @(self.deliveryCountryId);
	if(self.deliveryProvince != nil){
		dictionary[kTHNStoreModelProductDeliveryProvince] = self.deliveryProvince;
	}
	dictionary[kTHNStoreModelProductDistributionType] = @(self.distributionType);
	dictionary[kTHNStoreModelProductFansCount] = @(self.fansCount);
	if(self.features != nil){
		dictionary[kTHNStoreModelProductFeatures] = self.features;
	}
	dictionary[kTHNStoreModelProductHaveDistributed] = @(self.haveDistributed);
	if(self.idCode != nil){
		dictionary[kTHNStoreModelProductIdCode] = self.idCode;
	}
	dictionary[kTHNStoreModelProductIsCustomMade] = @(self.isCustomMade);
	dictionary[kTHNStoreModelProductIsCustomService] = @(self.isCustomService);
	dictionary[kTHNStoreModelProductIsDistributed] = @(self.isDistributed);
	dictionary[kTHNStoreModelProductIsFreePostage] = @(self.isFreePostage);
	dictionary[kTHNStoreModelProductIsMadeHoliday] = @(self.isMadeHoliday);
	dictionary[kTHNStoreModelProductIsProprietary] = @(self.isProprietary);
	dictionary[kTHNStoreModelProductIsSoldOut] = @(self.isSoldOut);
	dictionary[kTHNStoreModelProductLikeCount] = @(self.likeCount);
	dictionary[kTHNStoreModelProductMadeCycle] = @(self.madeCycle);
	dictionary[kTHNStoreModelProductMaterialId] = @(self.materialId);
	if(self.materialName != nil){
		dictionary[kTHNStoreModelProductMaterialName] = self.materialName;
	}
	dictionary[kTHNStoreModelProductMaxPrice] = @(self.maxPrice);
	dictionary[kTHNStoreModelProductMaxSalePrice] = @(self.maxSalePrice);
	dictionary[kTHNStoreModelProductMinPrice] = @(self.minPrice);
	dictionary[kTHNStoreModelProductMinSalePrice] = @(self.minSalePrice);
	if(self.modes != nil){
		dictionary[kTHNStoreModelProductModes] = self.modes;
	}
	if(self.name != nil){
		dictionary[kTHNStoreModelProductName] = self.name;
	}
	if(self.province != nil){
		dictionary[kTHNStoreModelProductProvince] = self.province;
	}
	dictionary[kTHNStoreModelProductPublishedAt] = @(self.publishedAt);
	dictionary[kTHNStoreModelProductRealPrice] = @(self.realPrice);
	dictionary[kTHNStoreModelProductRealSalePrice] = @(self.realSalePrice);
	if(self.rid != nil){
		dictionary[kTHNStoreModelProductRid] = self.rid;
	}
	dictionary[kTHNStoreModelProductSecondCategoryId] = @(self.secondCategoryId);
	dictionary[kTHNStoreModelProductStatus] = @(self.status);
	dictionary[kTHNStoreModelProductSticked] = @(self.sticked);
	if(self.storeLogo != nil){
		dictionary[kTHNStoreModelProductStoreLogo] = self.storeLogo;
	}
	if(self.storeName != nil){
		dictionary[kTHNStoreModelProductStoreName] = self.storeName;
	}
	if(self.storeRid != nil){
		dictionary[kTHNStoreModelProductStoreRid] = self.storeRid;
	}
	dictionary[kTHNStoreModelProductStyleId] = @(self.styleId);
	if(self.styleName != nil){
		dictionary[kTHNStoreModelProductStyleName] = self.styleName;
	}
	if(self.tagLine != nil){
		dictionary[kTHNStoreModelProductTagLine] = self.tagLine;
	}
	dictionary[kTHNStoreModelProductTopCategoryId] = @(self.topCategoryId);
	dictionary[kTHNStoreModelProductTotalStock] = @(self.totalStock);
	if(self.town != nil){
		dictionary[kTHNStoreModelProductTown] = self.town;
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
		[aCoder encodeObject:self.bgcover forKey:kTHNStoreModelProductBgcover];
	}
	[aCoder encodeObject:@(self.categoryId) forKey:kTHNStoreModelProductCategoryId];	if(self.city != nil){
		[aCoder encodeObject:self.city forKey:kTHNStoreModelProductCity];
	}
	[aCoder encodeObject:@(self.commissionPrice) forKey:kTHNStoreModelProductCommissionPrice];	[aCoder encodeObject:@(self.commissionRate) forKey:kTHNStoreModelProductCommissionRate];	if(self.country != nil){
		[aCoder encodeObject:self.country forKey:kTHNStoreModelProductCountry];
	}
	if(self.cover != nil){
		[aCoder encodeObject:self.cover forKey:kTHNStoreModelProductCover];
	}
	[aCoder encodeObject:@(self.coverId) forKey:kTHNStoreModelProductCoverId];	if(self.customDetails != nil){
		[aCoder encodeObject:self.customDetails forKey:kTHNStoreModelProductCustomDetails];
	}
	if(self.deliveryCity != nil){
		[aCoder encodeObject:self.deliveryCity forKey:kTHNStoreModelProductDeliveryCity];
	}
	if(self.deliveryCountry != nil){
		[aCoder encodeObject:self.deliveryCountry forKey:kTHNStoreModelProductDeliveryCountry];
	}
	[aCoder encodeObject:@(self.deliveryCountryId) forKey:kTHNStoreModelProductDeliveryCountryId];	if(self.deliveryProvince != nil){
		[aCoder encodeObject:self.deliveryProvince forKey:kTHNStoreModelProductDeliveryProvince];
	}
	[aCoder encodeObject:@(self.distributionType) forKey:kTHNStoreModelProductDistributionType];	[aCoder encodeObject:@(self.fansCount) forKey:kTHNStoreModelProductFansCount];	if(self.features != nil){
		[aCoder encodeObject:self.features forKey:kTHNStoreModelProductFeatures];
	}
	[aCoder encodeObject:@(self.haveDistributed) forKey:kTHNStoreModelProductHaveDistributed];	if(self.idCode != nil){
		[aCoder encodeObject:self.idCode forKey:kTHNStoreModelProductIdCode];
	}
	[aCoder encodeObject:@(self.isCustomMade) forKey:kTHNStoreModelProductIsCustomMade];	[aCoder encodeObject:@(self.isCustomService) forKey:kTHNStoreModelProductIsCustomService];	[aCoder encodeObject:@(self.isDistributed) forKey:kTHNStoreModelProductIsDistributed];	[aCoder encodeObject:@(self.isFreePostage) forKey:kTHNStoreModelProductIsFreePostage];	[aCoder encodeObject:@(self.isMadeHoliday) forKey:kTHNStoreModelProductIsMadeHoliday];	[aCoder encodeObject:@(self.isProprietary) forKey:kTHNStoreModelProductIsProprietary];	[aCoder encodeObject:@(self.isSoldOut) forKey:kTHNStoreModelProductIsSoldOut];	[aCoder encodeObject:@(self.likeCount) forKey:kTHNStoreModelProductLikeCount];	[aCoder encodeObject:@(self.madeCycle) forKey:kTHNStoreModelProductMadeCycle];	[aCoder encodeObject:@(self.materialId) forKey:kTHNStoreModelProductMaterialId];	if(self.materialName != nil){
		[aCoder encodeObject:self.materialName forKey:kTHNStoreModelProductMaterialName];
	}
	[aCoder encodeObject:@(self.maxPrice) forKey:kTHNStoreModelProductMaxPrice];	[aCoder encodeObject:@(self.maxSalePrice) forKey:kTHNStoreModelProductMaxSalePrice];	[aCoder encodeObject:@(self.minPrice) forKey:kTHNStoreModelProductMinPrice];	[aCoder encodeObject:@(self.minSalePrice) forKey:kTHNStoreModelProductMinSalePrice];	if(self.modes != nil){
		[aCoder encodeObject:self.modes forKey:kTHNStoreModelProductModes];
	}
	if(self.name != nil){
		[aCoder encodeObject:self.name forKey:kTHNStoreModelProductName];
	}
	if(self.province != nil){
		[aCoder encodeObject:self.province forKey:kTHNStoreModelProductProvince];
	}
	[aCoder encodeObject:@(self.publishedAt) forKey:kTHNStoreModelProductPublishedAt];	[aCoder encodeObject:@(self.realPrice) forKey:kTHNStoreModelProductRealPrice];	[aCoder encodeObject:@(self.realSalePrice) forKey:kTHNStoreModelProductRealSalePrice];	if(self.rid != nil){
		[aCoder encodeObject:self.rid forKey:kTHNStoreModelProductRid];
	}
	[aCoder encodeObject:@(self.secondCategoryId) forKey:kTHNStoreModelProductSecondCategoryId];	[aCoder encodeObject:@(self.status) forKey:kTHNStoreModelProductStatus];	[aCoder encodeObject:@(self.sticked) forKey:kTHNStoreModelProductSticked];	if(self.storeLogo != nil){
		[aCoder encodeObject:self.storeLogo forKey:kTHNStoreModelProductStoreLogo];
	}
	if(self.storeName != nil){
		[aCoder encodeObject:self.storeName forKey:kTHNStoreModelProductStoreName];
	}
	if(self.storeRid != nil){
		[aCoder encodeObject:self.storeRid forKey:kTHNStoreModelProductStoreRid];
	}
	[aCoder encodeObject:@(self.styleId) forKey:kTHNStoreModelProductStyleId];	if(self.styleName != nil){
		[aCoder encodeObject:self.styleName forKey:kTHNStoreModelProductStyleName];
	}
	if(self.tagLine != nil){
		[aCoder encodeObject:self.tagLine forKey:kTHNStoreModelProductTagLine];
	}
	[aCoder encodeObject:@(self.topCategoryId) forKey:kTHNStoreModelProductTopCategoryId];	[aCoder encodeObject:@(self.totalStock) forKey:kTHNStoreModelProductTotalStock];	if(self.town != nil){
		[aCoder encodeObject:self.town forKey:kTHNStoreModelProductTown];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.bgcover = [aDecoder decodeObjectForKey:kTHNStoreModelProductBgcover];
	self.categoryId = [[aDecoder decodeObjectForKey:kTHNStoreModelProductCategoryId] integerValue];
	self.city = [aDecoder decodeObjectForKey:kTHNStoreModelProductCity];
	self.commissionPrice = [[aDecoder decodeObjectForKey:kTHNStoreModelProductCommissionPrice] floatValue];
	self.commissionRate = [[aDecoder decodeObjectForKey:kTHNStoreModelProductCommissionRate] integerValue];
	self.country = [aDecoder decodeObjectForKey:kTHNStoreModelProductCountry];
	self.cover = [aDecoder decodeObjectForKey:kTHNStoreModelProductCover];
	self.coverId = [[aDecoder decodeObjectForKey:kTHNStoreModelProductCoverId] integerValue];
	self.customDetails = [aDecoder decodeObjectForKey:kTHNStoreModelProductCustomDetails];
	self.deliveryCity = [aDecoder decodeObjectForKey:kTHNStoreModelProductDeliveryCity];
	self.deliveryCountry = [aDecoder decodeObjectForKey:kTHNStoreModelProductDeliveryCountry];
	self.deliveryCountryId = [[aDecoder decodeObjectForKey:kTHNStoreModelProductDeliveryCountryId] integerValue];
	self.deliveryProvince = [aDecoder decodeObjectForKey:kTHNStoreModelProductDeliveryProvince];
	self.distributionType = [[aDecoder decodeObjectForKey:kTHNStoreModelProductDistributionType] integerValue];
	self.fansCount = [[aDecoder decodeObjectForKey:kTHNStoreModelProductFansCount] integerValue];
	self.features = [aDecoder decodeObjectForKey:kTHNStoreModelProductFeatures];
	self.haveDistributed = [[aDecoder decodeObjectForKey:kTHNStoreModelProductHaveDistributed] boolValue];
	self.idCode = [aDecoder decodeObjectForKey:kTHNStoreModelProductIdCode];
	self.isCustomMade = [[aDecoder decodeObjectForKey:kTHNStoreModelProductIsCustomMade] boolValue];
	self.isCustomService = [[aDecoder decodeObjectForKey:kTHNStoreModelProductIsCustomService] boolValue];
	self.isDistributed = [[aDecoder decodeObjectForKey:kTHNStoreModelProductIsDistributed] boolValue];
	self.isFreePostage = [[aDecoder decodeObjectForKey:kTHNStoreModelProductIsFreePostage] boolValue];
	self.isMadeHoliday = [[aDecoder decodeObjectForKey:kTHNStoreModelProductIsMadeHoliday] boolValue];
	self.isProprietary = [[aDecoder decodeObjectForKey:kTHNStoreModelProductIsProprietary] boolValue];
	self.isSoldOut = [[aDecoder decodeObjectForKey:kTHNStoreModelProductIsSoldOut] boolValue];
	self.likeCount = [[aDecoder decodeObjectForKey:kTHNStoreModelProductLikeCount] integerValue];
	self.madeCycle = [[aDecoder decodeObjectForKey:kTHNStoreModelProductMadeCycle] integerValue];
	self.materialId = [[aDecoder decodeObjectForKey:kTHNStoreModelProductMaterialId] integerValue];
	self.materialName = [aDecoder decodeObjectForKey:kTHNStoreModelProductMaterialName];
	self.maxPrice = [[aDecoder decodeObjectForKey:kTHNStoreModelProductMaxPrice] integerValue];
	self.maxSalePrice = [[aDecoder decodeObjectForKey:kTHNStoreModelProductMaxSalePrice] integerValue];
	self.minPrice = [[aDecoder decodeObjectForKey:kTHNStoreModelProductMinPrice] integerValue];
	self.minSalePrice = [[aDecoder decodeObjectForKey:kTHNStoreModelProductMinSalePrice] integerValue];
	self.modes = [aDecoder decodeObjectForKey:kTHNStoreModelProductModes];
	self.name = [aDecoder decodeObjectForKey:kTHNStoreModelProductName];
	self.province = [aDecoder decodeObjectForKey:kTHNStoreModelProductProvince];
	self.publishedAt = [[aDecoder decodeObjectForKey:kTHNStoreModelProductPublishedAt] integerValue];
	self.realPrice = [[aDecoder decodeObjectForKey:kTHNStoreModelProductRealPrice] integerValue];
	self.realSalePrice = [[aDecoder decodeObjectForKey:kTHNStoreModelProductRealSalePrice] integerValue];
	self.rid = [aDecoder decodeObjectForKey:kTHNStoreModelProductRid];
	self.secondCategoryId = [[aDecoder decodeObjectForKey:kTHNStoreModelProductSecondCategoryId] integerValue];
	self.status = [[aDecoder decodeObjectForKey:kTHNStoreModelProductStatus] integerValue];
	self.sticked = [[aDecoder decodeObjectForKey:kTHNStoreModelProductSticked] boolValue];
	self.storeLogo = [aDecoder decodeObjectForKey:kTHNStoreModelProductStoreLogo];
	self.storeName = [aDecoder decodeObjectForKey:kTHNStoreModelProductStoreName];
	self.storeRid = [aDecoder decodeObjectForKey:kTHNStoreModelProductStoreRid];
	self.styleId = [[aDecoder decodeObjectForKey:kTHNStoreModelProductStyleId] integerValue];
	self.styleName = [aDecoder decodeObjectForKey:kTHNStoreModelProductStyleName];
	self.tagLine = [aDecoder decodeObjectForKey:kTHNStoreModelProductTagLine];
	self.topCategoryId = [[aDecoder decodeObjectForKey:kTHNStoreModelProductTopCategoryId] integerValue];
	self.totalStock = [[aDecoder decodeObjectForKey:kTHNStoreModelProductTotalStock] integerValue];
	self.town = [aDecoder decodeObjectForKey:kTHNStoreModelProductTown];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	THNStoreModelProduct *copy = [THNStoreModelProduct new];

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
