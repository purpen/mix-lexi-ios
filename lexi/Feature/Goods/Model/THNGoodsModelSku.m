//
//	THNGoodsModelSku.m
//  on 1/9/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNGoodsModelSku.h"

NSString *const kTHNGoodsModelSkuBgcover = @"bgcover";
NSString *const kTHNGoodsModelSkuCity = @"city";
NSString *const kTHNGoodsModelSkuCommissionPrice = @"commission_price";
NSString *const kTHNGoodsModelSkuCommissionRate = @"commission_rate";
NSString *const kTHNGoodsModelSkuCountry = @"country";
NSString *const kTHNGoodsModelSkuCover = @"cover";
NSString *const kTHNGoodsModelSkuCoverId = @"cover_id";
NSString *const kTHNGoodsModelSkuDeliveryCity = @"delivery_city";
NSString *const kTHNGoodsModelSkuDeliveryCountry = @"delivery_country";
NSString *const kTHNGoodsModelSkuDeliveryCountryId = @"delivery_country_id";
NSString *const kTHNGoodsModelSkuDeliveryProvince = @"delivery_province";
NSString *const kTHNGoodsModelSkuDistributionType = @"distribution_type";
NSString *const kTHNGoodsModelSkuFansCount = @"fans_count";
NSString *const kTHNGoodsModelSkuMode = @"mode";
NSString *const kTHNGoodsModelSkuPrice = @"price";
NSString *const kTHNGoodsModelSkuProductName = @"product_name";
NSString *const kTHNGoodsModelSkuProductRid = @"product_rid";
NSString *const kTHNGoodsModelSkuProvince = @"province";
NSString *const kTHNGoodsModelSkuRid = @"rid";
NSString *const kTHNGoodsModelSkuSColor = @"s_color";
NSString *const kTHNGoodsModelSkuSModel = @"s_model";
NSString *const kTHNGoodsModelSkuSWeight = @"s_weight";
NSString *const kTHNGoodsModelSkuSalePrice = @"sale_price";
NSString *const kTHNGoodsModelSkuStockCount = @"stock_count";
NSString *const kTHNGoodsModelSkuStockQuantity = @"stock_quantity";
NSString *const kTHNGoodsModelSkuStoreLogo = @"store_logo";
NSString *const kTHNGoodsModelSkuStoreName = @"store_name";
NSString *const kTHNGoodsModelSkuStoreRid = @"store_rid";
NSString *const kTHNGoodsModelSkuTagLine = @"tag_line";
NSString *const kTHNGoodsModelSkuTown = @"town";

@interface THNGoodsModelSku ()
@end
@implementation THNGoodsModelSku




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNGoodsModelSkuBgcover] isKindOfClass:[NSNull class]]){
		self.bgcover = dictionary[kTHNGoodsModelSkuBgcover];
	}	
	if(![dictionary[kTHNGoodsModelSkuCity] isKindOfClass:[NSNull class]]){
		self.city = dictionary[kTHNGoodsModelSkuCity];
	}	
	if(![dictionary[kTHNGoodsModelSkuCommissionPrice] isKindOfClass:[NSNull class]]){
		self.commissionPrice = [dictionary[kTHNGoodsModelSkuCommissionPrice] floatValue];
	}

	if(![dictionary[kTHNGoodsModelSkuCommissionRate] isKindOfClass:[NSNull class]]){
		self.commissionRate = [dictionary[kTHNGoodsModelSkuCommissionRate] integerValue];
	}

	if(![dictionary[kTHNGoodsModelSkuCountry] isKindOfClass:[NSNull class]]){
		self.country = dictionary[kTHNGoodsModelSkuCountry];
	}	
	if(![dictionary[kTHNGoodsModelSkuCover] isKindOfClass:[NSNull class]]){
		self.cover = dictionary[kTHNGoodsModelSkuCover];
	}	
	if(![dictionary[kTHNGoodsModelSkuCoverId] isKindOfClass:[NSNull class]]){
		self.coverId = dictionary[kTHNGoodsModelSkuCoverId];
	}	
	if(![dictionary[kTHNGoodsModelSkuDeliveryCity] isKindOfClass:[NSNull class]]){
		self.deliveryCity = dictionary[kTHNGoodsModelSkuDeliveryCity];
	}	
	if(![dictionary[kTHNGoodsModelSkuDeliveryCountry] isKindOfClass:[NSNull class]]){
		self.deliveryCountry = dictionary[kTHNGoodsModelSkuDeliveryCountry];
	}	
	if(![dictionary[kTHNGoodsModelSkuDeliveryCountryId] isKindOfClass:[NSNull class]]){
		self.deliveryCountryId = [dictionary[kTHNGoodsModelSkuDeliveryCountryId] integerValue];
	}

	if(![dictionary[kTHNGoodsModelSkuDeliveryProvince] isKindOfClass:[NSNull class]]){
		self.deliveryProvince = dictionary[kTHNGoodsModelSkuDeliveryProvince];
	}	
	if(![dictionary[kTHNGoodsModelSkuDistributionType] isKindOfClass:[NSNull class]]){
		self.distributionType = [dictionary[kTHNGoodsModelSkuDistributionType] integerValue];
	}

	if(![dictionary[kTHNGoodsModelSkuFansCount] isKindOfClass:[NSNull class]]){
		self.fansCount = [dictionary[kTHNGoodsModelSkuFansCount] integerValue];
	}

	if(![dictionary[kTHNGoodsModelSkuMode] isKindOfClass:[NSNull class]]){
		self.mode = dictionary[kTHNGoodsModelSkuMode];
	}	
	if(![dictionary[kTHNGoodsModelSkuPrice] isKindOfClass:[NSNull class]]){
		self.price = [dictionary[kTHNGoodsModelSkuPrice] floatValue];
	}

	if(![dictionary[kTHNGoodsModelSkuProductName] isKindOfClass:[NSNull class]]){
		self.productName = dictionary[kTHNGoodsModelSkuProductName];
	}	
	if(![dictionary[kTHNGoodsModelSkuProductRid] isKindOfClass:[NSNull class]]){
		self.productRid = dictionary[kTHNGoodsModelSkuProductRid];
	}	
	if(![dictionary[kTHNGoodsModelSkuProvince] isKindOfClass:[NSNull class]]){
		self.province = dictionary[kTHNGoodsModelSkuProvince];
	}	
	if(![dictionary[kTHNGoodsModelSkuRid] isKindOfClass:[NSNull class]]){
		self.rid = dictionary[kTHNGoodsModelSkuRid];
	}	
	if(![dictionary[kTHNGoodsModelSkuSColor] isKindOfClass:[NSNull class]]){
		self.sColor = dictionary[kTHNGoodsModelSkuSColor];
	}	
	if(![dictionary[kTHNGoodsModelSkuSModel] isKindOfClass:[NSNull class]]){
		self.sModel = dictionary[kTHNGoodsModelSkuSModel];
	}	
	if(![dictionary[kTHNGoodsModelSkuSWeight] isKindOfClass:[NSNull class]]){
		self.sWeight = [dictionary[kTHNGoodsModelSkuSWeight] integerValue];
	}

	if(![dictionary[kTHNGoodsModelSkuSalePrice] isKindOfClass:[NSNull class]]){
		self.salePrice = [dictionary[kTHNGoodsModelSkuSalePrice] floatValue];
	}

	if(![dictionary[kTHNGoodsModelSkuStockCount] isKindOfClass:[NSNull class]]){
		self.stockCount = [dictionary[kTHNGoodsModelSkuStockCount] integerValue];
	}

	if(![dictionary[kTHNGoodsModelSkuStockQuantity] isKindOfClass:[NSNull class]]){
		self.stockQuantity = [dictionary[kTHNGoodsModelSkuStockQuantity] integerValue];
	}

	if(![dictionary[kTHNGoodsModelSkuStoreLogo] isKindOfClass:[NSNull class]]){
		self.storeLogo = dictionary[kTHNGoodsModelSkuStoreLogo];
	}	
	if(![dictionary[kTHNGoodsModelSkuStoreName] isKindOfClass:[NSNull class]]){
		self.storeName = dictionary[kTHNGoodsModelSkuStoreName];
	}	
	if(![dictionary[kTHNGoodsModelSkuStoreRid] isKindOfClass:[NSNull class]]){
		self.storeRid = dictionary[kTHNGoodsModelSkuStoreRid];
	}	
	if(![dictionary[kTHNGoodsModelSkuTagLine] isKindOfClass:[NSNull class]]){
		self.tagLine = dictionary[kTHNGoodsModelSkuTagLine];
	}	
	if(![dictionary[kTHNGoodsModelSkuTown] isKindOfClass:[NSNull class]]){
		self.town = dictionary[kTHNGoodsModelSkuTown];
	}	
	return self;
}
@end
