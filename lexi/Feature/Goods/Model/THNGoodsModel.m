//
//	THNGoodsModel.m
//  on 1/9/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNGoodsModel.h"

NSString *const kTHNGoodsModelAssets = @"assets";
NSString *const kTHNGoodsModelBgcover = @"bgcover";
NSString *const kTHNGoodsModelCategoryId = @"category_id";
NSString *const kTHNGoodsModelCity = @"city";
NSString *const kTHNGoodsModelCommissionPrice = @"commission_price";
NSString *const kTHNGoodsModelCommissionRate = @"commission_rate";
NSString *const kTHNGoodsModelContent = @"content";
NSString *const kTHNGoodsModelCountry = @"country";
NSString *const kTHNGoodsModelCover = @"cover";
NSString *const kTHNGoodsModelCoverId = @"cover_id";
NSString *const kTHNGoodsModelCustomDetails = @"custom_details";
NSString *const kTHNGoodsModelDealContent = @"deal_content";
NSString *const kTHNGoodsModelDeliveryCity = @"delivery_city";
NSString *const kTHNGoodsModelDeliveryCountry = @"delivery_country";
NSString *const kTHNGoodsModelDeliveryCountryId = @"delivery_country_id";
NSString *const kTHNGoodsModelDeliveryProvince = @"delivery_province";
NSString *const kTHNGoodsModelDistributionType = @"distribution_type";
NSString *const kTHNGoodsModelFansCount = @"fans_count";
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
NSString *const kTHNGoodsModelProvince = @"province";
NSString *const kTHNGoodsModelPublishedAt = @"published_at";
NSString *const kTHNGoodsModelRealPrice = @"real_price";
NSString *const kTHNGoodsModelRealSalePrice = @"real_sale_price";
NSString *const kTHNGoodsModelReturnPolicyId = @"return_policy_id";
NSString *const kTHNGoodsModelReturnPolicyTitle = @"return_policy_title";
NSString *const kTHNGoodsModelRid = @"rid";
NSString *const kTHNGoodsModelSecondCategoryId = @"second_category_id";
NSString *const kTHNGoodsModelSkus = @"skus";
NSString *const kTHNGoodsModelStatus = @"status";
NSString *const kTHNGoodsModelSticked = @"sticked";
NSString *const kTHNGoodsModelStockCount = @"stock_count";
NSString *const kTHNGoodsModelStoreLogo = @"store_logo";
NSString *const kTHNGoodsModelStoreName = @"store_name";
NSString *const kTHNGoodsModelStoreRid = @"store_rid";
NSString *const kTHNGoodsModelStyleId = @"style_id";
NSString *const kTHNGoodsModelStyleName = @"style_name";
NSString *const kTHNGoodsModelTagLine = @"tag_line";
NSString *const kTHNGoodsModelTopCategoryId = @"top_category_id";
NSString *const kTHNGoodsModelTotalStock = @"total_stock";
NSString *const kTHNGoodsModelTown = @"town";

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
			THNGoodsModelAsset * assetsItem = [[THNGoodsModelAsset alloc] initWithDictionary:assetsDictionary];
			[assetsItems addObject:assetsItem];
		}
		self.assets = assetsItems;
	}
	if(![dictionary[kTHNGoodsModelBgcover] isKindOfClass:[NSNull class]]){
		self.bgcover = dictionary[kTHNGoodsModelBgcover];
	}	
	if(![dictionary[kTHNGoodsModelCategoryId] isKindOfClass:[NSNull class]]){
		self.categoryId = [dictionary[kTHNGoodsModelCategoryId] integerValue];
	}

	if(![dictionary[kTHNGoodsModelCity] isKindOfClass:[NSNull class]]){
		self.city = dictionary[kTHNGoodsModelCity];
	}	
	if(![dictionary[kTHNGoodsModelCommissionPrice] isKindOfClass:[NSNull class]]){
		self.commissionPrice = [dictionary[kTHNGoodsModelCommissionPrice] integerValue];
	}

	if(![dictionary[kTHNGoodsModelCommissionRate] isKindOfClass:[NSNull class]]){
		self.commissionRate = [dictionary[kTHNGoodsModelCommissionRate] integerValue];
	}

	if(![dictionary[kTHNGoodsModelContent] isKindOfClass:[NSNull class]]){
		self.content = dictionary[kTHNGoodsModelContent];
	}	
	if(![dictionary[kTHNGoodsModelCountry] isKindOfClass:[NSNull class]]){
		self.country = dictionary[kTHNGoodsModelCountry];
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
			THNGoodsModelDealContent * dealContentItem = [[THNGoodsModelDealContent alloc] initWithDictionary:dealContentDictionary];
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
	if(![dictionary[kTHNGoodsModelDeliveryCountryId] isKindOfClass:[NSNull class]]){
		self.deliveryCountryId = [dictionary[kTHNGoodsModelDeliveryCountryId] integerValue];
	}

	if(![dictionary[kTHNGoodsModelDeliveryProvince] isKindOfClass:[NSNull class]]){
		self.deliveryProvince = dictionary[kTHNGoodsModelDeliveryProvince];
	}	
	if(![dictionary[kTHNGoodsModelDistributionType] isKindOfClass:[NSNull class]]){
		self.distributionType = [dictionary[kTHNGoodsModelDistributionType] integerValue];
	}

	if(![dictionary[kTHNGoodsModelFansCount] isKindOfClass:[NSNull class]]){
		self.fansCount = [dictionary[kTHNGoodsModelFansCount] integerValue];
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
			THNGoodsModelLabel * labelsItem = [[THNGoodsModelLabel alloc] initWithDictionary:labelsDictionary];
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
			THNGoodsModelProductLikeUser * productLikeUsersItem = [[THNGoodsModelProductLikeUser alloc] initWithDictionary:productLikeUsersDictionary];
			[productLikeUsersItems addObject:productLikeUsersItem];
		}
		self.productLikeUsers = productLikeUsersItems;
	}
	if(![dictionary[kTHNGoodsModelProductReturnPolicy] isKindOfClass:[NSNull class]]){
		self.productReturnPolicy = dictionary[kTHNGoodsModelProductReturnPolicy];
	}	
	if(![dictionary[kTHNGoodsModelProvince] isKindOfClass:[NSNull class]]){
		self.province = dictionary[kTHNGoodsModelProvince];
	}	
	if(![dictionary[kTHNGoodsModelPublishedAt] isKindOfClass:[NSNull class]]){
		self.publishedAt = [dictionary[kTHNGoodsModelPublishedAt] integerValue];
	}

	if(![dictionary[kTHNGoodsModelRealPrice] isKindOfClass:[NSNull class]]){
		self.realPrice = [dictionary[kTHNGoodsModelRealPrice] integerValue];
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

	if(dictionary[kTHNGoodsModelSkus] != nil && [dictionary[kTHNGoodsModelSkus] isKindOfClass:[NSArray class]]){
		NSArray * skusDictionaries = dictionary[kTHNGoodsModelSkus];
		NSMutableArray * skusItems = [NSMutableArray array];
		for(NSDictionary * skusDictionary in skusDictionaries){
			THNGoodsModelSku * skusItem = [[THNGoodsModelSku alloc] initWithDictionary:skusDictionary];
			[skusItems addObject:skusItem];
		}
		self.skus = skusItems;
	}
	if(![dictionary[kTHNGoodsModelStatus] isKindOfClass:[NSNull class]]){
		self.status = [dictionary[kTHNGoodsModelStatus] integerValue];
	}

	if(![dictionary[kTHNGoodsModelSticked] isKindOfClass:[NSNull class]]){
		self.sticked = [dictionary[kTHNGoodsModelSticked] boolValue];
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
	if(![dictionary[kTHNGoodsModelTagLine] isKindOfClass:[NSNull class]]){
		self.tagLine = dictionary[kTHNGoodsModelTagLine];
	}	
	if(![dictionary[kTHNGoodsModelTopCategoryId] isKindOfClass:[NSNull class]]){
		self.topCategoryId = [dictionary[kTHNGoodsModelTopCategoryId] integerValue];
	}

	if(![dictionary[kTHNGoodsModelTotalStock] isKindOfClass:[NSNull class]]){
		self.totalStock = [dictionary[kTHNGoodsModelTotalStock] integerValue];
	}

	if(![dictionary[kTHNGoodsModelTown] isKindOfClass:[NSNull class]]){
		self.town = dictionary[kTHNGoodsModelTown];
	}	
	return self;
}
@end
