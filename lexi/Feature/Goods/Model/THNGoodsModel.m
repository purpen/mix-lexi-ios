//
//	THNGoodsModel.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNGoodsModel.h"

NSString *const kTHNGoodsModelAssets = @"assets";
NSString *const kTHNGoodsModelCategoryId = @"category_id";
NSString *const kTHNGoodsModelCommissionPrice = @"commission_price";
NSString *const kTHNGoodsModelCommissionRate = @"commission_rate";
NSString *const kTHNGoodsModelContent = @"content";
NSString *const kTHNGoodsModelCountryId = @"country_id";
NSString *const kTHNGoodsModelCover = @"cover";
NSString *const kTHNGoodsModelCoverId = @"cover_id";
NSString *const kTHNGoodsModelCustomDetails = @"custom_details";
NSString *const kTHNGoodsModelDealContent = @"deal_content";
NSString *const kTHNGoodsModelDeliveryCity = @"delivery_city";
NSString *const kTHNGoodsModelDeliveryCountry = @"delivery_country";
NSString *const kTHNGoodsModelDeliveryProvince = @"delivery_province";
NSString *const kTHNGoodsModelFeatures = @"features";
NSString *const kTHNGoodsModelFid = @"fid";
NSString *const kTHNGoodsModelHaveDistributed = @"have_distributed";
NSString *const kTHNGoodsModelIdCode = @"id_code";
NSString *const kTHNGoodsModelIsCustomMade = @"is_custom_made";
NSString *const kTHNGoodsModelIsCustomService = @"is_custom_service";
NSString *const kTHNGoodsModelIsDistributed = @"is_distributed";
NSString *const kTHNGoodsModelIsFreePostage = @"is_free_postage";
NSString *const kTHNGoodsModelIsLike = @"is_like";
NSString *const kTHNGoodsModelIsMadeHoliday = @"is_made_holiday";
NSString *const kTHNGoodsModelIsProprietary = @"is_proprietary";
NSString *const kTHNGoodsModelIsSoldOut = @"is_sold_out";
NSString *const kTHNGoodsModelIsWish = @"is_wish";
NSString *const kTHNGoodsModelKeywords = @"keywords";
NSString *const kTHNGoodsModelLabels = @"labels";
NSString *const kTHNGoodsModelLikeCount = @"like_count";
NSString *const kTHNGoodsModelMadeCycle = @"made_cycle";
NSString *const kTHNGoodsModelMaterialId = @"material_id";
NSString *const kTHNGoodsModelMaterialName = @"material_name";
NSString *const kTHNGoodsModelMaxPrice = @"max_price";
NSString *const kTHNGoodsModelMaxSalePrice = @"max_sale_price";
NSString *const kTHNGoodsModelMinPrice = @"min_price";
NSString *const kTHNGoodsModelMinSalePrice = @"min_sale_price";
NSString *const kTHNGoodsModelModes = @"modes";
NSString *const kTHNGoodsModelName = @"name";
NSString *const kTHNGoodsModelProductLikeUsers = @"product_like_users";
NSString *const kTHNGoodsModelProductReturnPolicy = @"product_return_policy";
NSString *const kTHNGoodsModelPublishedAt = @"published_at";
NSString *const kTHNGoodsModelPyIntro = @"py_intro";
NSString *const kTHNGoodsModelRealPrice = @"real_price";
NSString *const kTHNGoodsModelRealSalePrice = @"real_sale_price";
NSString *const kTHNGoodsModelReturnPolicyId = @"return_policy_id";
NSString *const kTHNGoodsModelReturnPolicyTitle = @"return_policy_title";
NSString *const kTHNGoodsModelRid = @"rid";
NSString *const kTHNGoodsModelSecondCategoryId = @"second_category_id";
NSString *const kTHNGoodsModelStatus = @"status";
NSString *const kTHNGoodsModelStockCount = @"stock_count";
NSString *const kTHNGoodsModelStoreLogo = @"store_logo";
NSString *const kTHNGoodsModelStoreName = @"store_name";
NSString *const kTHNGoodsModelStoreRid = @"store_rid";
NSString *const kTHNGoodsModelStyleId = @"style_id";
NSString *const kTHNGoodsModelStyleName = @"style_name";
NSString *const kTHNGoodsModelTopCategoryId = @"top_category_id";
NSString *const kTHNGoodsModelTotalStock = @"total_stock";

@interface THNGoodsModel ()
@end
@implementation THNGoodsModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(dictionary[kTHNGoodsModelAssets] != nil && [dictionary[kTHNGoodsModelAssets] isKindOfClass:[NSArray class]]){
		NSArray * assetsDictionaries = dictionary[kTHNGoodsModelAssets];
		NSMutableArray * assetsItems = [NSMutableArray array];
		for(NSDictionary * assetsDictionary in assetsDictionaries){
			THNGoodsModelAssets * assetsItem = [[THNGoodsModelAssets alloc] initWithDictionary:assetsDictionary];
			[assetsItems addObject:assetsItem];
		}
		self.assets = assetsItems;
	}
	if(![dictionary[kTHNGoodsModelCategoryId] isKindOfClass:[NSNull class]]){
		self.categoryId = [dictionary[kTHNGoodsModelCategoryId] integerValue];
	}

	if(![dictionary[kTHNGoodsModelCommissionPrice] isKindOfClass:[NSNull class]]){
		self.commissionPrice = [dictionary[kTHNGoodsModelCommissionPrice] floatValue];
	}

	if(![dictionary[kTHNGoodsModelCommissionRate] isKindOfClass:[NSNull class]]){
		self.commissionRate = [dictionary[kTHNGoodsModelCommissionRate] integerValue];
	}

	if(![dictionary[kTHNGoodsModelContent] isKindOfClass:[NSNull class]]){
		self.content = dictionary[kTHNGoodsModelContent];
	}	
	if(![dictionary[kTHNGoodsModelCountryId] isKindOfClass:[NSNull class]]){
		self.countryId = [dictionary[kTHNGoodsModelCountryId] integerValue];
	}

	if(![dictionary[kTHNGoodsModelCover] isKindOfClass:[NSNull class]]){
		self.cover = dictionary[kTHNGoodsModelCover];
	}	
	if(![dictionary[kTHNGoodsModelCoverId] isKindOfClass:[NSNull class]]){
		self.coverId = [dictionary[kTHNGoodsModelCoverId] integerValue];
	}

	if(![dictionary[kTHNGoodsModelCustomDetails] isKindOfClass:[NSNull class]]){
		self.customDetails = dictionary[kTHNGoodsModelCustomDetails];
	}	
	if(dictionary[kTHNGoodsModelDealContent] != nil && [dictionary[kTHNGoodsModelDealContent] isKindOfClass:[NSArray class]]){
		NSArray * dealContentDictionaries = dictionary[kTHNGoodsModelDealContent];
		NSMutableArray * dealContentItems = [NSMutableArray array];
		for(NSDictionary * dealContentDictionary in dealContentDictionaries){
			THNDealContentModel * dealContentItem = [[THNDealContentModel alloc] initWithDictionary:dealContentDictionary];
			[dealContentItems addObject:dealContentItem];
		}
		self.dealContent = dealContentItems;
	}
	if(![dictionary[kTHNGoodsModelDeliveryCity] isKindOfClass:[NSNull class]]){
		self.deliveryCity = dictionary[kTHNGoodsModelDeliveryCity];
	}	
	if(![dictionary[kTHNGoodsModelDeliveryCountry] isKindOfClass:[NSNull class]]){
		self.deliveryCountry = dictionary[kTHNGoodsModelDeliveryCountry];
	}	
	if(![dictionary[kTHNGoodsModelDeliveryProvince] isKindOfClass:[NSNull class]]){
		self.deliveryProvince = dictionary[kTHNGoodsModelDeliveryProvince];
	}	
	if(![dictionary[kTHNGoodsModelFeatures] isKindOfClass:[NSNull class]]){
		self.features = dictionary[kTHNGoodsModelFeatures];
	}	
	if(![dictionary[kTHNGoodsModelFid] isKindOfClass:[NSNull class]]){
		self.fid = dictionary[kTHNGoodsModelFid];
	}	
	if(![dictionary[kTHNGoodsModelHaveDistributed] isKindOfClass:[NSNull class]]){
		self.haveDistributed = [dictionary[kTHNGoodsModelHaveDistributed] boolValue];
	}

	if(![dictionary[kTHNGoodsModelIdCode] isKindOfClass:[NSNull class]]){
		self.idCode = dictionary[kTHNGoodsModelIdCode];
	}	
	if(![dictionary[kTHNGoodsModelIsCustomMade] isKindOfClass:[NSNull class]]){
		self.isCustomMade = [dictionary[kTHNGoodsModelIsCustomMade] boolValue];
	}

	if(![dictionary[kTHNGoodsModelIsCustomService] isKindOfClass:[NSNull class]]){
		self.isCustomService = [dictionary[kTHNGoodsModelIsCustomService] boolValue];
	}

	if(![dictionary[kTHNGoodsModelIsDistributed] isKindOfClass:[NSNull class]]){
		self.isDistributed = [dictionary[kTHNGoodsModelIsDistributed] boolValue];
	}

	if(![dictionary[kTHNGoodsModelIsFreePostage] isKindOfClass:[NSNull class]]){
		self.isFreePostage = [dictionary[kTHNGoodsModelIsFreePostage] boolValue];
	}

	if(![dictionary[kTHNGoodsModelIsLike] isKindOfClass:[NSNull class]]){
		self.isLike = [dictionary[kTHNGoodsModelIsLike] boolValue];
	}

	if(![dictionary[kTHNGoodsModelIsMadeHoliday] isKindOfClass:[NSNull class]]){
		self.isMadeHoliday = [dictionary[kTHNGoodsModelIsMadeHoliday] boolValue];
	}

	if(![dictionary[kTHNGoodsModelIsProprietary] isKindOfClass:[NSNull class]]){
		self.isProprietary = [dictionary[kTHNGoodsModelIsProprietary] boolValue];
	}

	if(![dictionary[kTHNGoodsModelIsSoldOut] isKindOfClass:[NSNull class]]){
		self.isSoldOut = [dictionary[kTHNGoodsModelIsSoldOut] boolValue];
	}

	if(![dictionary[kTHNGoodsModelIsWish] isKindOfClass:[NSNull class]]){
		self.isWish = [dictionary[kTHNGoodsModelIsWish] boolValue];
	}

	if(![dictionary[kTHNGoodsModelKeywords] isKindOfClass:[NSNull class]]){
		self.keywords = dictionary[kTHNGoodsModelKeywords];
	}	
	if(dictionary[kTHNGoodsModelLabels] != nil && [dictionary[kTHNGoodsModelLabels] isKindOfClass:[NSArray class]]){
		NSArray * labelsDictionaries = dictionary[kTHNGoodsModelLabels];
		NSMutableArray * labelsItems = [NSMutableArray array];
		for(NSDictionary * labelsDictionary in labelsDictionaries){
			THNGoodsModelLabels * labelsItem = [[THNGoodsModelLabels alloc] initWithDictionary:labelsDictionary];
			[labelsItems addObject:labelsItem];
		}
		self.labels = labelsItems;
	}
	if(![dictionary[kTHNGoodsModelLikeCount] isKindOfClass:[NSNull class]]){
		self.likeCount = [dictionary[kTHNGoodsModelLikeCount] integerValue];
	}

	if(![dictionary[kTHNGoodsModelMadeCycle] isKindOfClass:[NSNull class]]){
		self.madeCycle = [dictionary[kTHNGoodsModelMadeCycle] integerValue];
	}

	if(![dictionary[kTHNGoodsModelMaterialId] isKindOfClass:[NSNull class]]){
		self.materialId = [dictionary[kTHNGoodsModelMaterialId] integerValue];
	}

	if(![dictionary[kTHNGoodsModelMaterialName] isKindOfClass:[NSNull class]]){
		self.materialName = dictionary[kTHNGoodsModelMaterialName];
	}	
	if(![dictionary[kTHNGoodsModelMaxPrice] isKindOfClass:[NSNull class]]){
		self.maxPrice = [dictionary[kTHNGoodsModelMaxPrice] floatValue];
	}

	if(![dictionary[kTHNGoodsModelMaxSalePrice] isKindOfClass:[NSNull class]]){
		self.maxSalePrice = [dictionary[kTHNGoodsModelMaxSalePrice] floatValue];
	}

	if(![dictionary[kTHNGoodsModelMinPrice] isKindOfClass:[NSNull class]]){
		self.minPrice = [dictionary[kTHNGoodsModelMinPrice] floatValue];
	}

	if(![dictionary[kTHNGoodsModelMinSalePrice] isKindOfClass:[NSNull class]]){
		self.minSalePrice = [dictionary[kTHNGoodsModelMinSalePrice] floatValue];
	}

	if(![dictionary[kTHNGoodsModelModes] isKindOfClass:[NSNull class]]){
		self.modes = dictionary[kTHNGoodsModelModes];
	}	
	if(![dictionary[kTHNGoodsModelName] isKindOfClass:[NSNull class]]){
		self.name = dictionary[kTHNGoodsModelName];
	}	
	if(dictionary[kTHNGoodsModelProductLikeUsers] != nil && [dictionary[kTHNGoodsModelProductLikeUsers] isKindOfClass:[NSArray class]]){
		NSArray * productLikeUsersDictionaries = dictionary[kTHNGoodsModelProductLikeUsers];
		NSMutableArray * productLikeUsersItems = [NSMutableArray array];
		for(NSDictionary * productLikeUsersDictionary in productLikeUsersDictionaries){
			THNGoodsModelProductLikeUsers * productLikeUsersItem = [[THNGoodsModelProductLikeUsers alloc] initWithDictionary:productLikeUsersDictionary];
			[productLikeUsersItems addObject:productLikeUsersItem];
		}
		self.productLikeUsers = productLikeUsersItems;
	}
	if(![dictionary[kTHNGoodsModelProductReturnPolicy] isKindOfClass:[NSNull class]]){
		self.productReturnPolicy = dictionary[kTHNGoodsModelProductReturnPolicy];
	}	
	if(![dictionary[kTHNGoodsModelPublishedAt] isKindOfClass:[NSNull class]]){
		self.publishedAt = [dictionary[kTHNGoodsModelPublishedAt] integerValue];
	}

	if(![dictionary[kTHNGoodsModelPyIntro] isKindOfClass:[NSNull class]]){
		self.pyIntro = dictionary[kTHNGoodsModelPyIntro];
	}	
	if(![dictionary[kTHNGoodsModelRealPrice] isKindOfClass:[NSNull class]]){
		self.realPrice = [dictionary[kTHNGoodsModelRealPrice] floatValue];
	}

	if(![dictionary[kTHNGoodsModelRealSalePrice] isKindOfClass:[NSNull class]]){
		self.realSalePrice = [dictionary[kTHNGoodsModelRealSalePrice] floatValue];
	}

	if(![dictionary[kTHNGoodsModelReturnPolicyId] isKindOfClass:[NSNull class]]){
		self.returnPolicyId = [dictionary[kTHNGoodsModelReturnPolicyId] integerValue];
	}

	if(![dictionary[kTHNGoodsModelReturnPolicyTitle] isKindOfClass:[NSNull class]]){
		self.returnPolicyTitle = dictionary[kTHNGoodsModelReturnPolicyTitle];
	}	
	if(![dictionary[kTHNGoodsModelRid] isKindOfClass:[NSNull class]]){
		self.rid = dictionary[kTHNGoodsModelRid];
	}	
	if(![dictionary[kTHNGoodsModelSecondCategoryId] isKindOfClass:[NSNull class]]){
		self.secondCategoryId = [dictionary[kTHNGoodsModelSecondCategoryId] integerValue];
	}

	if(![dictionary[kTHNGoodsModelStatus] isKindOfClass:[NSNull class]]){
		self.status = [dictionary[kTHNGoodsModelStatus] integerValue];
	}

	if(![dictionary[kTHNGoodsModelStockCount] isKindOfClass:[NSNull class]]){
		self.stockCount = [dictionary[kTHNGoodsModelStockCount] integerValue];
	}

	if(![dictionary[kTHNGoodsModelStoreLogo] isKindOfClass:[NSNull class]]){
		self.storeLogo = dictionary[kTHNGoodsModelStoreLogo];
	}	
	if(![dictionary[kTHNGoodsModelStoreName] isKindOfClass:[NSNull class]]){
		self.storeName = dictionary[kTHNGoodsModelStoreName];
	}	
	if(![dictionary[kTHNGoodsModelStoreRid] isKindOfClass:[NSNull class]]){
		self.storeRid = dictionary[kTHNGoodsModelStoreRid];
	}	
	if(![dictionary[kTHNGoodsModelStyleId] isKindOfClass:[NSNull class]]){
		self.styleId = [dictionary[kTHNGoodsModelStyleId] integerValue];
	}

	if(![dictionary[kTHNGoodsModelStyleName] isKindOfClass:[NSNull class]]){
		self.styleName = dictionary[kTHNGoodsModelStyleName];
	}	
	if(![dictionary[kTHNGoodsModelTopCategoryId] isKindOfClass:[NSNull class]]){
		self.topCategoryId = [dictionary[kTHNGoodsModelTopCategoryId] integerValue];
	}

	if(![dictionary[kTHNGoodsModelTotalStock] isKindOfClass:[NSNull class]]){
		self.totalStock = [dictionary[kTHNGoodsModelTotalStock] integerValue];
	}

	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.assets != nil){
		NSMutableArray * dictionaryElements = [NSMutableArray array];
		for(THNGoodsModelAssets * assetsElement in self.assets){
			[dictionaryElements addObject:[assetsElement toDictionary]];
		}
		dictionary[kTHNGoodsModelAssets] = dictionaryElements;
	}
	dictionary[kTHNGoodsModelCategoryId] = @(self.categoryId);
	dictionary[kTHNGoodsModelCommissionPrice] = @(self.commissionPrice);
	dictionary[kTHNGoodsModelCommissionRate] = @(self.commissionRate);
	if(self.content != nil){
		dictionary[kTHNGoodsModelContent] = self.content;
	}
	dictionary[kTHNGoodsModelCountryId] = @(self.countryId);
	if(self.cover != nil){
		dictionary[kTHNGoodsModelCover] = self.cover;
	}
	dictionary[kTHNGoodsModelCoverId] = @(self.coverId);
	if(self.customDetails != nil){
		dictionary[kTHNGoodsModelCustomDetails] = self.customDetails;
	}
	if(self.dealContent != nil){
		NSMutableArray * dictionaryElements = [NSMutableArray array];
		for(THNDealContentModel * dealContentElement in self.dealContent){
			[dictionaryElements addObject:[dealContentElement toDictionary]];
		}
		dictionary[kTHNGoodsModelDealContent] = dictionaryElements;
	}
	if(self.deliveryCity != nil){
		dictionary[kTHNGoodsModelDeliveryCity] = self.deliveryCity;
	}
	if(self.deliveryCountry != nil){
		dictionary[kTHNGoodsModelDeliveryCountry] = self.deliveryCountry;
	}
	if(self.deliveryProvince != nil){
		dictionary[kTHNGoodsModelDeliveryProvince] = self.deliveryProvince;
	}
	if(self.features != nil){
		dictionary[kTHNGoodsModelFeatures] = self.features;
	}
	if(self.fid != nil){
		dictionary[kTHNGoodsModelFid] = self.fid;
	}
	dictionary[kTHNGoodsModelHaveDistributed] = @(self.haveDistributed);
	if(self.idCode != nil){
		dictionary[kTHNGoodsModelIdCode] = self.idCode;
	}
	dictionary[kTHNGoodsModelIsCustomMade] = @(self.isCustomMade);
	dictionary[kTHNGoodsModelIsCustomService] = @(self.isCustomService);
	dictionary[kTHNGoodsModelIsDistributed] = @(self.isDistributed);
	dictionary[kTHNGoodsModelIsFreePostage] = @(self.isFreePostage);
	dictionary[kTHNGoodsModelIsLike] = @(self.isLike);
	dictionary[kTHNGoodsModelIsMadeHoliday] = @(self.isMadeHoliday);
	dictionary[kTHNGoodsModelIsProprietary] = @(self.isProprietary);
	dictionary[kTHNGoodsModelIsSoldOut] = @(self.isSoldOut);
	dictionary[kTHNGoodsModelIsWish] = @(self.isWish);
	if(self.keywords != nil){
		dictionary[kTHNGoodsModelKeywords] = self.keywords;
	}
	if(self.labels != nil){
		NSMutableArray * dictionaryElements = [NSMutableArray array];
		for(THNGoodsModelLabels * labelsElement in self.labels){
			[dictionaryElements addObject:[labelsElement toDictionary]];
		}
		dictionary[kTHNGoodsModelLabels] = dictionaryElements;
	}
	dictionary[kTHNGoodsModelLikeCount] = @(self.likeCount);
	dictionary[kTHNGoodsModelMadeCycle] = @(self.madeCycle);
	dictionary[kTHNGoodsModelMaterialId] = @(self.materialId);
	if(self.materialName != nil){
		dictionary[kTHNGoodsModelMaterialName] = self.materialName;
	}
	dictionary[kTHNGoodsModelMaxPrice] = @(self.maxPrice);
	dictionary[kTHNGoodsModelMaxSalePrice] = @(self.maxSalePrice);
	dictionary[kTHNGoodsModelMinPrice] = @(self.minPrice);
	dictionary[kTHNGoodsModelMinSalePrice] = @(self.minSalePrice);
	if(self.modes != nil){
		dictionary[kTHNGoodsModelModes] = self.modes;
	}
	if(self.name != nil){
		dictionary[kTHNGoodsModelName] = self.name;
	}
	if(self.productLikeUsers != nil){
		NSMutableArray * dictionaryElements = [NSMutableArray array];
		for(THNGoodsModelProductLikeUsers * productLikeUsersElement in self.productLikeUsers){
			[dictionaryElements addObject:[productLikeUsersElement toDictionary]];
		}
		dictionary[kTHNGoodsModelProductLikeUsers] = dictionaryElements;
	}
	if(self.productReturnPolicy != nil){
		dictionary[kTHNGoodsModelProductReturnPolicy] = self.productReturnPolicy;
	}
	dictionary[kTHNGoodsModelPublishedAt] = @(self.publishedAt);
	if(self.pyIntro != nil){
		dictionary[kTHNGoodsModelPyIntro] = self.pyIntro;
	}
	dictionary[kTHNGoodsModelRealPrice] = @(self.realPrice);
	dictionary[kTHNGoodsModelRealSalePrice] = @(self.realSalePrice);
	dictionary[kTHNGoodsModelReturnPolicyId] = @(self.returnPolicyId);
	if(self.returnPolicyTitle != nil){
		dictionary[kTHNGoodsModelReturnPolicyTitle] = self.returnPolicyTitle;
	}
	if(self.rid != nil){
		dictionary[kTHNGoodsModelRid] = self.rid;
	}
	dictionary[kTHNGoodsModelSecondCategoryId] = @(self.secondCategoryId);
	dictionary[kTHNGoodsModelStatus] = @(self.status);
	dictionary[kTHNGoodsModelStockCount] = @(self.stockCount);
	if(self.storeLogo != nil){
		dictionary[kTHNGoodsModelStoreLogo] = self.storeLogo;
	}
	if(self.storeName != nil){
		dictionary[kTHNGoodsModelStoreName] = self.storeName;
	}
	if(self.storeRid != nil){
		dictionary[kTHNGoodsModelStoreRid] = self.storeRid;
	}
	dictionary[kTHNGoodsModelStyleId] = @(self.styleId);
	if(self.styleName != nil){
		dictionary[kTHNGoodsModelStyleName] = self.styleName;
	}
	dictionary[kTHNGoodsModelTopCategoryId] = @(self.topCategoryId);
	dictionary[kTHNGoodsModelTotalStock] = @(self.totalStock);
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
	if(self.assets != nil){
		[aCoder encodeObject:self.assets forKey:kTHNGoodsModelAssets];
	}
	[aCoder encodeObject:@(self.categoryId) forKey:kTHNGoodsModelCategoryId];	[aCoder encodeObject:@(self.commissionPrice) forKey:kTHNGoodsModelCommissionPrice];	[aCoder encodeObject:@(self.commissionRate) forKey:kTHNGoodsModelCommissionRate];	if(self.content != nil){
		[aCoder encodeObject:self.content forKey:kTHNGoodsModelContent];
	}
	[aCoder encodeObject:@(self.countryId) forKey:kTHNGoodsModelCountryId];	if(self.cover != nil){
		[aCoder encodeObject:self.cover forKey:kTHNGoodsModelCover];
	}
	[aCoder encodeObject:@(self.coverId) forKey:kTHNGoodsModelCoverId];	if(self.customDetails != nil){
		[aCoder encodeObject:self.customDetails forKey:kTHNGoodsModelCustomDetails];
	}
	if(self.dealContent != nil){
		[aCoder encodeObject:self.dealContent forKey:kTHNGoodsModelDealContent];
	}
	if(self.deliveryCity != nil){
		[aCoder encodeObject:self.deliveryCity forKey:kTHNGoodsModelDeliveryCity];
	}
	if(self.deliveryCountry != nil){
		[aCoder encodeObject:self.deliveryCountry forKey:kTHNGoodsModelDeliveryCountry];
	}
	if(self.deliveryProvince != nil){
		[aCoder encodeObject:self.deliveryProvince forKey:kTHNGoodsModelDeliveryProvince];
	}
	if(self.features != nil){
		[aCoder encodeObject:self.features forKey:kTHNGoodsModelFeatures];
	}
	if(self.fid != nil){
		[aCoder encodeObject:self.fid forKey:kTHNGoodsModelFid];
	}
	[aCoder encodeObject:@(self.haveDistributed) forKey:kTHNGoodsModelHaveDistributed];	if(self.idCode != nil){
		[aCoder encodeObject:self.idCode forKey:kTHNGoodsModelIdCode];
	}
	[aCoder encodeObject:@(self.isCustomMade) forKey:kTHNGoodsModelIsCustomMade];	[aCoder encodeObject:@(self.isCustomService) forKey:kTHNGoodsModelIsCustomService];	[aCoder encodeObject:@(self.isDistributed) forKey:kTHNGoodsModelIsDistributed];	[aCoder encodeObject:@(self.isFreePostage) forKey:kTHNGoodsModelIsFreePostage];	[aCoder encodeObject:@(self.isLike) forKey:kTHNGoodsModelIsLike];	[aCoder encodeObject:@(self.isMadeHoliday) forKey:kTHNGoodsModelIsMadeHoliday];	[aCoder encodeObject:@(self.isProprietary) forKey:kTHNGoodsModelIsProprietary];	[aCoder encodeObject:@(self.isSoldOut) forKey:kTHNGoodsModelIsSoldOut];	[aCoder encodeObject:@(self.isWish) forKey:kTHNGoodsModelIsWish];	if(self.keywords != nil){
		[aCoder encodeObject:self.keywords forKey:kTHNGoodsModelKeywords];
	}
	if(self.labels != nil){
		[aCoder encodeObject:self.labels forKey:kTHNGoodsModelLabels];
	}
	[aCoder encodeObject:@(self.likeCount) forKey:kTHNGoodsModelLikeCount];	[aCoder encodeObject:@(self.madeCycle) forKey:kTHNGoodsModelMadeCycle];	[aCoder encodeObject:@(self.materialId) forKey:kTHNGoodsModelMaterialId];	if(self.materialName != nil){
		[aCoder encodeObject:self.materialName forKey:kTHNGoodsModelMaterialName];
	}
	[aCoder encodeObject:@(self.maxPrice) forKey:kTHNGoodsModelMaxPrice];	[aCoder encodeObject:@(self.maxSalePrice) forKey:kTHNGoodsModelMaxSalePrice];	[aCoder encodeObject:@(self.minPrice) forKey:kTHNGoodsModelMinPrice];	[aCoder encodeObject:@(self.minSalePrice) forKey:kTHNGoodsModelMinSalePrice];	if(self.modes != nil){
		[aCoder encodeObject:self.modes forKey:kTHNGoodsModelModes];
	}
	if(self.name != nil){
		[aCoder encodeObject:self.name forKey:kTHNGoodsModelName];
	}
	if(self.productLikeUsers != nil){
		[aCoder encodeObject:self.productLikeUsers forKey:kTHNGoodsModelProductLikeUsers];
	}
	if(self.productReturnPolicy != nil){
		[aCoder encodeObject:self.productReturnPolicy forKey:kTHNGoodsModelProductReturnPolicy];
	}
	[aCoder encodeObject:@(self.publishedAt) forKey:kTHNGoodsModelPublishedAt];	if(self.pyIntro != nil){
		[aCoder encodeObject:self.pyIntro forKey:kTHNGoodsModelPyIntro];
	}
	[aCoder encodeObject:@(self.realPrice) forKey:kTHNGoodsModelRealPrice];	[aCoder encodeObject:@(self.realSalePrice) forKey:kTHNGoodsModelRealSalePrice];	[aCoder encodeObject:@(self.returnPolicyId) forKey:kTHNGoodsModelReturnPolicyId];	if(self.returnPolicyTitle != nil){
		[aCoder encodeObject:self.returnPolicyTitle forKey:kTHNGoodsModelReturnPolicyTitle];
	}
	if(self.rid != nil){
		[aCoder encodeObject:self.rid forKey:kTHNGoodsModelRid];
	}
	[aCoder encodeObject:@(self.secondCategoryId) forKey:kTHNGoodsModelSecondCategoryId];	[aCoder encodeObject:@(self.status) forKey:kTHNGoodsModelStatus];	[aCoder encodeObject:@(self.stockCount) forKey:kTHNGoodsModelStockCount];	if(self.storeLogo != nil){
		[aCoder encodeObject:self.storeLogo forKey:kTHNGoodsModelStoreLogo];
	}
	if(self.storeName != nil){
		[aCoder encodeObject:self.storeName forKey:kTHNGoodsModelStoreName];
	}
	if(self.storeRid != nil){
		[aCoder encodeObject:self.storeRid forKey:kTHNGoodsModelStoreRid];
	}
	[aCoder encodeObject:@(self.styleId) forKey:kTHNGoodsModelStyleId];	if(self.styleName != nil){
		[aCoder encodeObject:self.styleName forKey:kTHNGoodsModelStyleName];
	}
	[aCoder encodeObject:@(self.topCategoryId) forKey:kTHNGoodsModelTopCategoryId];	[aCoder encodeObject:@(self.totalStock) forKey:kTHNGoodsModelTotalStock];
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.assets = [aDecoder decodeObjectForKey:kTHNGoodsModelAssets];
	self.categoryId = [[aDecoder decodeObjectForKey:kTHNGoodsModelCategoryId] integerValue];
	self.commissionPrice = [[aDecoder decodeObjectForKey:kTHNGoodsModelCommissionPrice] floatValue];
	self.commissionRate = [[aDecoder decodeObjectForKey:kTHNGoodsModelCommissionRate] integerValue];
	self.content = [aDecoder decodeObjectForKey:kTHNGoodsModelContent];
	self.countryId = [[aDecoder decodeObjectForKey:kTHNGoodsModelCountryId] integerValue];
	self.cover = [aDecoder decodeObjectForKey:kTHNGoodsModelCover];
	self.coverId = [[aDecoder decodeObjectForKey:kTHNGoodsModelCoverId] integerValue];
	self.customDetails = [aDecoder decodeObjectForKey:kTHNGoodsModelCustomDetails];
	self.dealContent = [aDecoder decodeObjectForKey:kTHNGoodsModelDealContent];
	self.deliveryCity = [aDecoder decodeObjectForKey:kTHNGoodsModelDeliveryCity];
	self.deliveryCountry = [aDecoder decodeObjectForKey:kTHNGoodsModelDeliveryCountry];
	self.deliveryProvince = [aDecoder decodeObjectForKey:kTHNGoodsModelDeliveryProvince];
	self.features = [aDecoder decodeObjectForKey:kTHNGoodsModelFeatures];
	self.fid = [aDecoder decodeObjectForKey:kTHNGoodsModelFid];
	self.haveDistributed = [[aDecoder decodeObjectForKey:kTHNGoodsModelHaveDistributed] boolValue];
	self.idCode = [aDecoder decodeObjectForKey:kTHNGoodsModelIdCode];
	self.isCustomMade = [[aDecoder decodeObjectForKey:kTHNGoodsModelIsCustomMade] boolValue];
	self.isCustomService = [[aDecoder decodeObjectForKey:kTHNGoodsModelIsCustomService] boolValue];
	self.isDistributed = [[aDecoder decodeObjectForKey:kTHNGoodsModelIsDistributed] boolValue];
	self.isFreePostage = [[aDecoder decodeObjectForKey:kTHNGoodsModelIsFreePostage] boolValue];
	self.isLike = [[aDecoder decodeObjectForKey:kTHNGoodsModelIsLike] boolValue];
	self.isMadeHoliday = [[aDecoder decodeObjectForKey:kTHNGoodsModelIsMadeHoliday] boolValue];
	self.isProprietary = [[aDecoder decodeObjectForKey:kTHNGoodsModelIsProprietary] boolValue];
	self.isSoldOut = [[aDecoder decodeObjectForKey:kTHNGoodsModelIsSoldOut] boolValue];
	self.isWish = [[aDecoder decodeObjectForKey:kTHNGoodsModelIsWish] boolValue];
	self.keywords = [aDecoder decodeObjectForKey:kTHNGoodsModelKeywords];
	self.labels = [aDecoder decodeObjectForKey:kTHNGoodsModelLabels];
	self.likeCount = [[aDecoder decodeObjectForKey:kTHNGoodsModelLikeCount] integerValue];
	self.madeCycle = [[aDecoder decodeObjectForKey:kTHNGoodsModelMadeCycle] integerValue];
	self.materialId = [[aDecoder decodeObjectForKey:kTHNGoodsModelMaterialId] integerValue];
	self.materialName = [aDecoder decodeObjectForKey:kTHNGoodsModelMaterialName];
	self.maxPrice = [[aDecoder decodeObjectForKey:kTHNGoodsModelMaxPrice] integerValue];
	self.maxSalePrice = [[aDecoder decodeObjectForKey:kTHNGoodsModelMaxSalePrice] integerValue];
	self.minPrice = [[aDecoder decodeObjectForKey:kTHNGoodsModelMinPrice] integerValue];
	self.minSalePrice = [[aDecoder decodeObjectForKey:kTHNGoodsModelMinSalePrice] integerValue];
	self.modes = [aDecoder decodeObjectForKey:kTHNGoodsModelModes];
	self.name = [aDecoder decodeObjectForKey:kTHNGoodsModelName];
	self.productLikeUsers = [aDecoder decodeObjectForKey:kTHNGoodsModelProductLikeUsers];
	self.productReturnPolicy = [aDecoder decodeObjectForKey:kTHNGoodsModelProductReturnPolicy];
	self.publishedAt = [[aDecoder decodeObjectForKey:kTHNGoodsModelPublishedAt] integerValue];
	self.pyIntro = [aDecoder decodeObjectForKey:kTHNGoodsModelPyIntro];
	self.realPrice = [[aDecoder decodeObjectForKey:kTHNGoodsModelRealPrice] integerValue];
	self.realSalePrice = [[aDecoder decodeObjectForKey:kTHNGoodsModelRealSalePrice] integerValue];
	self.returnPolicyId = [[aDecoder decodeObjectForKey:kTHNGoodsModelReturnPolicyId] integerValue];
	self.returnPolicyTitle = [aDecoder decodeObjectForKey:kTHNGoodsModelReturnPolicyTitle];
	self.rid = [aDecoder decodeObjectForKey:kTHNGoodsModelRid];
	self.secondCategoryId = [[aDecoder decodeObjectForKey:kTHNGoodsModelSecondCategoryId] integerValue];
	self.status = [[aDecoder decodeObjectForKey:kTHNGoodsModelStatus] integerValue];
	self.stockCount = [[aDecoder decodeObjectForKey:kTHNGoodsModelStockCount] integerValue];
	self.storeLogo = [aDecoder decodeObjectForKey:kTHNGoodsModelStoreLogo];
	self.storeName = [aDecoder decodeObjectForKey:kTHNGoodsModelStoreName];
	self.storeRid = [aDecoder decodeObjectForKey:kTHNGoodsModelStoreRid];
	self.styleId = [[aDecoder decodeObjectForKey:kTHNGoodsModelStyleId] integerValue];
	self.styleName = [aDecoder decodeObjectForKey:kTHNGoodsModelStyleName];
	self.topCategoryId = [[aDecoder decodeObjectForKey:kTHNGoodsModelTopCategoryId] integerValue];
	self.totalStock = [[aDecoder decodeObjectForKey:kTHNGoodsModelTotalStock] integerValue];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	THNGoodsModel *copy = [THNGoodsModel new];

	copy.assets = [self.assets copy];
	copy.categoryId = self.categoryId;
	copy.commissionPrice = self.commissionPrice;
	copy.commissionRate = self.commissionRate;
	copy.content = [self.content copy];
	copy.countryId = self.countryId;
	copy.cover = [self.cover copy];
	copy.coverId = self.coverId;
	copy.customDetails = [self.customDetails copy];
	copy.dealContent = [self.dealContent copy];
	copy.deliveryCity = [self.deliveryCity copy];
	copy.deliveryCountry = [self.deliveryCountry copy];
	copy.deliveryProvince = [self.deliveryProvince copy];
	copy.features = [self.features copy];
	copy.fid = [self.fid copy];
	copy.haveDistributed = self.haveDistributed;
	copy.idCode = [self.idCode copy];
	copy.isCustomMade = self.isCustomMade;
	copy.isCustomService = self.isCustomService;
	copy.isDistributed = self.isDistributed;
	copy.isFreePostage = self.isFreePostage;
	copy.isLike = self.isLike;
	copy.isMadeHoliday = self.isMadeHoliday;
	copy.isProprietary = self.isProprietary;
	copy.isSoldOut = self.isSoldOut;
	copy.isWish = self.isWish;
	copy.keywords = [self.keywords copy];
	copy.labels = [self.labels copy];
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
	copy.productLikeUsers = [self.productLikeUsers copy];
	copy.productReturnPolicy = [self.productReturnPolicy copy];
	copy.publishedAt = self.publishedAt;
	copy.pyIntro = [self.pyIntro copy];
	copy.realPrice = self.realPrice;
	copy.realSalePrice = self.realSalePrice;
	copy.returnPolicyId = self.returnPolicyId;
	copy.returnPolicyTitle = [self.returnPolicyTitle copy];
	copy.rid = [self.rid copy];
	copy.secondCategoryId = self.secondCategoryId;
	copy.status = self.status;
	copy.stockCount = self.stockCount;
	copy.storeLogo = [self.storeLogo copy];
	copy.storeName = [self.storeName copy];
	copy.storeRid = [self.storeRid copy];
	copy.styleId = self.styleId;
	copy.styleName = [self.styleName copy];
	copy.topCategoryId = self.topCategoryId;
	copy.totalStock = self.totalStock;

	return copy;
}
@end
