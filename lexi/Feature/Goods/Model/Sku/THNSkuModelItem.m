//
//	THNSkuModelItem.m
//  on 31/8/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNSkuModelItem.h"

NSString *const kTHNSkuModelItemCover = @"cover";
NSString *const kTHNSkuModelItemDeliveryCountry = @"delivery_country";
NSString *const kTHNSkuModelItemDeliveryProvince = @"delivery_province";
NSString *const kTHNSkuModelItemDeliveryCountryId = @"delivery_country_id";
NSString *const kTHNSkuModelItemMode = @"mode";
NSString *const kTHNSkuModelItemPrice = @"price";
NSString *const kTHNSkuModelItemProductName = @"product_name";
NSString *const kTHNSkuModelItemProductRid = @"product_rid";
NSString *const kTHNSkuModelItemRid = @"rid";
NSString *const kTHNSkuModelItemSColor = @"s_color";
NSString *const kTHNSkuModelItemSModel = @"s_model";
NSString *const kTHNSkuModelItemSWeight = @"s_weight";
NSString *const kTHNSkuModelItemSalePrice = @"sale_price";
NSString *const kTHNSkuModelItemStockCount = @"stock_count";
NSString *const kTHNSkuModelItemStoreLogo = @"store_logo";
NSString *const kTHNSkuModelItemStoreName = @"store_name";
NSString *const kTHNSkuModelItemStoreRid = @"store_rid";

@interface THNSkuModelItem ()
@end
@implementation THNSkuModelItem




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNSkuModelItemCover] isKindOfClass:[NSNull class]]){
		self.cover = dictionary[kTHNSkuModelItemCover];
	}	
	if(![dictionary[kTHNSkuModelItemDeliveryCountry] isKindOfClass:[NSNull class]]){
		self.deliveryCountry = dictionary[kTHNSkuModelItemDeliveryCountry];
	}
    if(![dictionary[kTHNSkuModelItemDeliveryProvince] isKindOfClass:[NSNull class]]){
        self.deliveryProvince = dictionary[kTHNSkuModelItemDeliveryProvince];
    }
	if(![dictionary[kTHNSkuModelItemDeliveryCountryId] isKindOfClass:[NSNull class]]){
		self.deliveryCountryId = [dictionary[kTHNSkuModelItemDeliveryCountryId] integerValue];
	}

	if(![dictionary[kTHNSkuModelItemMode] isKindOfClass:[NSNull class]]){
		self.mode = dictionary[kTHNSkuModelItemMode];
	}	
	if(![dictionary[kTHNSkuModelItemPrice] isKindOfClass:[NSNull class]]){
		self.price = [dictionary[kTHNSkuModelItemPrice] floatValue];
	}	
	if(![dictionary[kTHNSkuModelItemProductName] isKindOfClass:[NSNull class]]){
		self.productName = dictionary[kTHNSkuModelItemProductName];
	}	
	if(![dictionary[kTHNSkuModelItemProductRid] isKindOfClass:[NSNull class]]){
		self.productRid = dictionary[kTHNSkuModelItemProductRid];
	}	
	if(![dictionary[kTHNSkuModelItemRid] isKindOfClass:[NSNull class]]){
		self.rid = dictionary[kTHNSkuModelItemRid];
	}	
	if(![dictionary[kTHNSkuModelItemSColor] isKindOfClass:[NSNull class]]){
		self.sColor = dictionary[kTHNSkuModelItemSColor];
	}	
	if(![dictionary[kTHNSkuModelItemSModel] isKindOfClass:[NSNull class]]){
		self.sModel = dictionary[kTHNSkuModelItemSModel];
	}	
	if(![dictionary[kTHNSkuModelItemSWeight] isKindOfClass:[NSNull class]]){
		self.sWeight = dictionary[kTHNSkuModelItemSWeight];
	}	
	if(![dictionary[kTHNSkuModelItemSalePrice] isKindOfClass:[NSNull class]]){
		self.salePrice = [dictionary[kTHNSkuModelItemSalePrice] floatValue];
	}	
	if(![dictionary[kTHNSkuModelItemStockCount] isKindOfClass:[NSNull class]]){
		self.stockCount = [dictionary[kTHNSkuModelItemStockCount] integerValue];
	}

	if(![dictionary[kTHNSkuModelItemStoreLogo] isKindOfClass:[NSNull class]]){
		self.storeLogo = dictionary[kTHNSkuModelItemStoreLogo];
	}	
	if(![dictionary[kTHNSkuModelItemStoreName] isKindOfClass:[NSNull class]]){
		self.storeName = dictionary[kTHNSkuModelItemStoreName];
	}	
	if(![dictionary[kTHNSkuModelItemStoreRid] isKindOfClass:[NSNull class]]){
		self.storeRid = dictionary[kTHNSkuModelItemStoreRid];
	}	
	return self;
}
@end
