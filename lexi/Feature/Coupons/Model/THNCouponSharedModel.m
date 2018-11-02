//
//	THNCouponSharedModel.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNCouponSharedModel.h"

NSString *const kTHNCouponSharedModelAmount = @"amount";
NSString *const kTHNCouponSharedModelCouponCode = @"coupon_code";
NSString *const kTHNCouponSharedModelIsRecommend = @"is_recommend";
NSString *const kTHNCouponSharedModelMinAmount = @"min_amount";
NSString *const kTHNCouponSharedModelProductSku = @"product_sku";
NSString *const kTHNCouponSharedModelStoreBgcover = @"store_bgcover";
NSString *const kTHNCouponSharedModelStoreLogo = @"store_logo";
NSString *const kTHNCouponSharedModelStoreName = @"store_name";
NSString *const kTHNCouponSharedModelStoreRid = @"store_rid";

@interface THNCouponSharedModel ()
@end
@implementation THNCouponSharedModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNCouponSharedModelAmount] isKindOfClass:[NSNull class]]){
		self.amount = [dictionary[kTHNCouponSharedModelAmount] integerValue];
	}

	if(![dictionary[kTHNCouponSharedModelCouponCode] isKindOfClass:[NSNull class]]){
		self.couponCode = dictionary[kTHNCouponSharedModelCouponCode];
	}	
	if(![dictionary[kTHNCouponSharedModelIsRecommend] isKindOfClass:[NSNull class]]){
		self.isRecommend = [dictionary[kTHNCouponSharedModelIsRecommend] boolValue];
	}

	if(![dictionary[kTHNCouponSharedModelMinAmount] isKindOfClass:[NSNull class]]){
		self.minAmount = [dictionary[kTHNCouponSharedModelMinAmount] integerValue];
	}

	if(dictionary[kTHNCouponSharedModelProductSku] != nil && [dictionary[kTHNCouponSharedModelProductSku] isKindOfClass:[NSArray class]]){
		NSArray * productSkuDictionaries = dictionary[kTHNCouponSharedModelProductSku];
		NSMutableArray * productSkuItems = [NSMutableArray array];
		for(NSDictionary * productSkuDictionary in productSkuDictionaries){
			THNCouponSharedModelProductSku * productSkuItem = [[THNCouponSharedModelProductSku alloc] initWithDictionary:productSkuDictionary];
			[productSkuItems addObject:productSkuItem];
		}
		self.productSku = productSkuItems;
	}
	if(![dictionary[kTHNCouponSharedModelStoreBgcover] isKindOfClass:[NSNull class]]){
		self.storeBgcover = dictionary[kTHNCouponSharedModelStoreBgcover];
	}	
	if(![dictionary[kTHNCouponSharedModelStoreLogo] isKindOfClass:[NSNull class]]){
		self.storeLogo = dictionary[kTHNCouponSharedModelStoreLogo];
	}	
	if(![dictionary[kTHNCouponSharedModelStoreName] isKindOfClass:[NSNull class]]){
		self.storeName = dictionary[kTHNCouponSharedModelStoreName];
	}	
	if(![dictionary[kTHNCouponSharedModelStoreRid] isKindOfClass:[NSNull class]]){
		self.storeRid = dictionary[kTHNCouponSharedModelStoreRid];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	dictionary[kTHNCouponSharedModelAmount] = @(self.amount);
	if(self.couponCode != nil){
		dictionary[kTHNCouponSharedModelCouponCode] = self.couponCode;
	}
	dictionary[kTHNCouponSharedModelIsRecommend] = @(self.isRecommend);
	dictionary[kTHNCouponSharedModelMinAmount] = @(self.minAmount);
	if(self.productSku != nil){
		NSMutableArray * dictionaryElements = [NSMutableArray array];
		for(THNCouponSharedModelProductSku * productSkuElement in self.productSku){
			[dictionaryElements addObject:[productSkuElement toDictionary]];
		}
		dictionary[kTHNCouponSharedModelProductSku] = dictionaryElements;
	}
	if(self.storeBgcover != nil){
		dictionary[kTHNCouponSharedModelStoreBgcover] = self.storeBgcover;
	}
	if(self.storeLogo != nil){
		dictionary[kTHNCouponSharedModelStoreLogo] = self.storeLogo;
	}
	if(self.storeName != nil){
		dictionary[kTHNCouponSharedModelStoreName] = self.storeName;
	}
	if(self.storeRid != nil){
		dictionary[kTHNCouponSharedModelStoreRid] = self.storeRid;
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
	[aCoder encodeObject:@(self.amount) forKey:kTHNCouponSharedModelAmount];	if(self.couponCode != nil){
		[aCoder encodeObject:self.couponCode forKey:kTHNCouponSharedModelCouponCode];
	}
	[aCoder encodeObject:@(self.isRecommend) forKey:kTHNCouponSharedModelIsRecommend];	[aCoder encodeObject:@(self.minAmount) forKey:kTHNCouponSharedModelMinAmount];	if(self.productSku != nil){
		[aCoder encodeObject:self.productSku forKey:kTHNCouponSharedModelProductSku];
	}
	if(self.storeBgcover != nil){
		[aCoder encodeObject:self.storeBgcover forKey:kTHNCouponSharedModelStoreBgcover];
	}
	if(self.storeLogo != nil){
		[aCoder encodeObject:self.storeLogo forKey:kTHNCouponSharedModelStoreLogo];
	}
	if(self.storeName != nil){
		[aCoder encodeObject:self.storeName forKey:kTHNCouponSharedModelStoreName];
	}
	if(self.storeRid != nil){
		[aCoder encodeObject:self.storeRid forKey:kTHNCouponSharedModelStoreRid];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.amount = [[aDecoder decodeObjectForKey:kTHNCouponSharedModelAmount] integerValue];
	self.couponCode = [aDecoder decodeObjectForKey:kTHNCouponSharedModelCouponCode];
	self.isRecommend = [[aDecoder decodeObjectForKey:kTHNCouponSharedModelIsRecommend] boolValue];
	self.minAmount = [[aDecoder decodeObjectForKey:kTHNCouponSharedModelMinAmount] integerValue];
	self.productSku = [aDecoder decodeObjectForKey:kTHNCouponSharedModelProductSku];
	self.storeBgcover = [aDecoder decodeObjectForKey:kTHNCouponSharedModelStoreBgcover];
	self.storeLogo = [aDecoder decodeObjectForKey:kTHNCouponSharedModelStoreLogo];
	self.storeName = [aDecoder decodeObjectForKey:kTHNCouponSharedModelStoreName];
	self.storeRid = [aDecoder decodeObjectForKey:kTHNCouponSharedModelStoreRid];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	THNCouponSharedModel *copy = [THNCouponSharedModel new];

	copy.amount = self.amount;
	copy.couponCode = [self.couponCode copy];
	copy.isRecommend = self.isRecommend;
	copy.minAmount = self.minAmount;
	copy.productSku = [self.productSku copy];
	copy.storeBgcover = [self.storeBgcover copy];
	copy.storeLogo = [self.storeLogo copy];
	copy.storeName = [self.storeName copy];
	copy.storeRid = [self.storeRid copy];

	return copy;
}
@end