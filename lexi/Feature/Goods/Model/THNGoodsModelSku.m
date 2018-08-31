//
//	THNGoodsModelSku.m
//  on 31/8/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNGoodsModelSku.h"

NSString *const kTHNGoodsModelSkuCommissionPrice = @"commission_price";
NSString *const kTHNGoodsModelSkuCommissionRate = @"commission_rate";
NSString *const kTHNGoodsModelSkuCover = @"cover";
NSString *const kTHNGoodsModelSkuCoverId = @"cover_id";
NSString *const kTHNGoodsModelSkuDeliveryCountry = @"delivery_country";
NSString *const kTHNGoodsModelSkuDeliveryCountryId = @"delivery_country_id";
NSString *const kTHNGoodsModelSkuMode = @"mode";
NSString *const kTHNGoodsModelSkuPrice = @"price";
NSString *const kTHNGoodsModelSkuProductName = @"product_name";
NSString *const kTHNGoodsModelSkuProductRid = @"product_rid";
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

@interface THNGoodsModelSku ()
@end
@implementation THNGoodsModelSku




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNGoodsModelSkuCommissionPrice] isKindOfClass:[NSNull class]]){
		self.commissionPrice = [dictionary[kTHNGoodsModelSkuCommissionPrice] integerValue];
	}

	if(![dictionary[kTHNGoodsModelSkuCommissionRate] isKindOfClass:[NSNull class]]){
		self.commissionRate = [dictionary[kTHNGoodsModelSkuCommissionRate] integerValue];
	}

	if(![dictionary[kTHNGoodsModelSkuCover] isKindOfClass:[NSNull class]]){
		self.cover = dictionary[kTHNGoodsModelSkuCover];
	}	
	if(![dictionary[kTHNGoodsModelSkuCoverId] isKindOfClass:[NSNull class]]){
		self.coverId = dictionary[kTHNGoodsModelSkuCoverId];
	}	
	if(![dictionary[kTHNGoodsModelSkuDeliveryCountry] isKindOfClass:[NSNull class]]){
		self.deliveryCountry = dictionary[kTHNGoodsModelSkuDeliveryCountry];
	}	
	if(![dictionary[kTHNGoodsModelSkuDeliveryCountryId] isKindOfClass:[NSNull class]]){
		self.deliveryCountryId = [dictionary[kTHNGoodsModelSkuDeliveryCountryId] integerValue];
	}

	if(![dictionary[kTHNGoodsModelSkuMode] isKindOfClass:[NSNull class]]){
		self.mode = dictionary[kTHNGoodsModelSkuMode];
	}	
	if(![dictionary[kTHNGoodsModelSkuPrice] isKindOfClass:[NSNull class]]){
		self.price = [dictionary[kTHNGoodsModelSkuPrice] integerValue];
	}

	if(![dictionary[kTHNGoodsModelSkuProductName] isKindOfClass:[NSNull class]]){
		self.productName = dictionary[kTHNGoodsModelSkuProductName];
	}	
	if(![dictionary[kTHNGoodsModelSkuProductRid] isKindOfClass:[NSNull class]]){
		self.productRid = dictionary[kTHNGoodsModelSkuProductRid];
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
	return self;
}
@end
