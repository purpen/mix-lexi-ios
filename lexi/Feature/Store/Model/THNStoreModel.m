//
//	THNStoreModel.m
//  on 1/9/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNStoreModel.h"

NSString *const kTHNStoreModelBgcover = @"bgcover";
NSString *const kTHNStoreModelCategories = @"categories";
NSString *const kTHNStoreModelCity = @"city";
NSString *const kTHNStoreModelCountry = @"country";
NSString *const kTHNStoreModelCreatedAt = @"created_at";
NSString *const kTHNStoreModelDeliveryCity = @"delivery_city";
NSString *const kTHNStoreModelDeliveryCountry = @"delivery_country";
NSString *const kTHNStoreModelDeliveryProvince = @"delivery_province";
NSString *const kTHNStoreModelFansCount = @"fans_count";
NSString *const kTHNStoreModelIsFollowed = @"is_followed";
NSString *const kTHNStoreModelLifeRecordCount = @"life_record_count";
NSString *const kTHNStoreModelLogo = @"logo";
NSString *const kTHNStoreModelName = @"name";
NSString *const kTHNStoreModelProductCount = @"store_products_counts";
NSString *const kTHNStoreModelProducts = @"products";
NSString *const kTHNStoreModelProvince = @"province";
NSString *const kTHNStoreModelRid = @"rid";
NSString *const kTHNStoreModelTagLine = @"tag_line";
NSString *const kTHNStoreModelTown = @"town";

@interface THNStoreModel ()
@end
@implementation THNStoreModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNStoreModelBgcover] isKindOfClass:[NSNull class]]){
		self.bgcover = dictionary[kTHNStoreModelBgcover];
	}	
	if(dictionary[kTHNStoreModelCategories] != nil && [dictionary[kTHNStoreModelCategories] isKindOfClass:[NSArray class]]){
		self.categories = dictionary[kTHNStoreModelCategories];
	}
	if(![dictionary[kTHNStoreModelCity] isKindOfClass:[NSNull class]]){
		self.city = dictionary[kTHNStoreModelCity];
	}	
	if(![dictionary[kTHNStoreModelCountry] isKindOfClass:[NSNull class]]){
		self.country = dictionary[kTHNStoreModelCountry];
	}	
	if(![dictionary[kTHNStoreModelCreatedAt] isKindOfClass:[NSNull class]]){
		self.createdAt = [dictionary[kTHNStoreModelCreatedAt] integerValue];
	}

	if(![dictionary[kTHNStoreModelDeliveryCity] isKindOfClass:[NSNull class]]){
		self.deliveryCity = dictionary[kTHNStoreModelDeliveryCity];
	}	
	if(![dictionary[kTHNStoreModelDeliveryCountry] isKindOfClass:[NSNull class]]){
		self.deliveryCountry = dictionary[kTHNStoreModelDeliveryCountry];
	}	
	if(![dictionary[kTHNStoreModelDeliveryProvince] isKindOfClass:[NSNull class]]){
		self.deliveryProvince = dictionary[kTHNStoreModelDeliveryProvince];
	}	
	if(![dictionary[kTHNStoreModelFansCount] isKindOfClass:[NSNull class]]){
		self.fansCount = [dictionary[kTHNStoreModelFansCount] integerValue];
	}

	if(![dictionary[kTHNStoreModelIsFollowed] isKindOfClass:[NSNull class]]){
        self.isFollowed = [dictionary[kTHNStoreModelIsFollowed] boolValue];
	}

	if(![dictionary[kTHNStoreModelLifeRecordCount] isKindOfClass:[NSNull class]]){
		self.lifeRecordCount = [dictionary[kTHNStoreModelLifeRecordCount] integerValue];
	}

	if(![dictionary[kTHNStoreModelLogo] isKindOfClass:[NSNull class]]){
		self.logo = dictionary[kTHNStoreModelLogo];
	}	
	if(![dictionary[kTHNStoreModelName] isKindOfClass:[NSNull class]]){
		self.name = dictionary[kTHNStoreModelName];
	}	
	if(![dictionary[kTHNStoreModelProductCount] isKindOfClass:[NSNull class]]){
		self.productCount = [dictionary[kTHNStoreModelProductCount] integerValue];
	}

	if(dictionary[kTHNStoreModelProducts] != nil && [dictionary[kTHNStoreModelProducts] isKindOfClass:[NSArray class]]){
		NSArray * productsDictionaries = dictionary[kTHNStoreModelProducts];
		NSMutableArray * productsItems = [NSMutableArray array];
		for(NSDictionary * productsDictionary in productsDictionaries){
			THNGoodsModel * productsItem = [[THNGoodsModel alloc] initWithDictionary:productsDictionary];
			[productsItems addObject:productsItem];
		}
		self.products = productsItems;
	}
	if(![dictionary[kTHNStoreModelProvince] isKindOfClass:[NSNull class]]){
		self.province = dictionary[kTHNStoreModelProvince];
	}	
	if(![dictionary[kTHNStoreModelRid] isKindOfClass:[NSNull class]]){
		self.rid = dictionary[kTHNStoreModelRid];
	}	
	if(![dictionary[kTHNStoreModelTagLine] isKindOfClass:[NSNull class]]){
		self.tagLine = dictionary[kTHNStoreModelTagLine];
	}	
	if(![dictionary[kTHNStoreModelTown] isKindOfClass:[NSNull class]]){
		self.town = dictionary[kTHNStoreModelTown];
	}	
	return self;
}
@end
