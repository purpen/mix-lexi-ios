//
//	THNCouponSingleModel.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNCouponSingleModel.h"

NSString *const kTHNCouponSingleModelAmount = @"amount";
NSString *const kTHNCouponSingleModelCouponCode = @"coupon_code";
NSString *const kTHNCouponSingleModelIsGrant = @"is_grant";
NSString *const kTHNCouponSingleModelIsRecommend = @"is_recommend";
NSString *const kTHNCouponSingleModelMinAmount = @"min_amount";
NSString *const kTHNCouponSingleModelProductAmount = @"product_amount";
NSString *const kTHNCouponSingleModelProductCouponAmount = @"product_coupon_amount";
NSString *const kTHNCouponSingleModelProductCover = @"product_cover";
NSString *const kTHNCouponSingleModelProductName = @"product_name";
NSString *const kTHNCouponSingleModelProductRid = @"product_rid";
NSString *const kTHNCouponSingleModelStoreRid = @"store_rid";
NSString *const kTHNCouponSingleModelSurplusCount = @"surplus_count";

@interface THNCouponSingleModel ()
@end
@implementation THNCouponSingleModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNCouponSingleModelAmount] isKindOfClass:[NSNull class]]){
		self.amount = [dictionary[kTHNCouponSingleModelAmount] integerValue];
	}

	if(![dictionary[kTHNCouponSingleModelCouponCode] isKindOfClass:[NSNull class]]){
		self.couponCode = dictionary[kTHNCouponSingleModelCouponCode];
	}	
	if(![dictionary[kTHNCouponSingleModelIsGrant] isKindOfClass:[NSNull class]]){
		self.isGrant = [dictionary[kTHNCouponSingleModelIsGrant] boolValue];
	}

	if(![dictionary[kTHNCouponSingleModelIsRecommend] isKindOfClass:[NSNull class]]){
		self.isRecommend = [dictionary[kTHNCouponSingleModelIsRecommend] boolValue];
	}

	if(![dictionary[kTHNCouponSingleModelMinAmount] isKindOfClass:[NSNull class]]){
		self.minAmount = [dictionary[kTHNCouponSingleModelMinAmount] integerValue];
	}

	if(![dictionary[kTHNCouponSingleModelProductAmount] isKindOfClass:[NSNull class]]){
		self.productAmount = [dictionary[kTHNCouponSingleModelProductAmount] integerValue];
	}

	if(![dictionary[kTHNCouponSingleModelProductCouponAmount] isKindOfClass:[NSNull class]]){
		self.productCouponAmount = [dictionary[kTHNCouponSingleModelProductCouponAmount] integerValue];
	}

	if(![dictionary[kTHNCouponSingleModelProductCover] isKindOfClass:[NSNull class]]){
		self.productCover = dictionary[kTHNCouponSingleModelProductCover];
	}	
	if(![dictionary[kTHNCouponSingleModelProductName] isKindOfClass:[NSNull class]]){
		self.productName = dictionary[kTHNCouponSingleModelProductName];
	}	
	if(![dictionary[kTHNCouponSingleModelProductRid] isKindOfClass:[NSNull class]]){
		self.productRid = dictionary[kTHNCouponSingleModelProductRid];
	}	
	if(![dictionary[kTHNCouponSingleModelStoreRid] isKindOfClass:[NSNull class]]){
		self.storeRid = dictionary[kTHNCouponSingleModelStoreRid];
	}	
	if(![dictionary[kTHNCouponSingleModelSurplusCount] isKindOfClass:[NSNull class]]){
		self.surplusCount = [dictionary[kTHNCouponSingleModelSurplusCount] integerValue];
	}

	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	dictionary[kTHNCouponSingleModelAmount] = @(self.amount);
	if(self.couponCode != nil){
		dictionary[kTHNCouponSingleModelCouponCode] = self.couponCode;
	}
	dictionary[kTHNCouponSingleModelIsGrant] = @(self.isGrant);
	dictionary[kTHNCouponSingleModelIsRecommend] = @(self.isRecommend);
	dictionary[kTHNCouponSingleModelMinAmount] = @(self.minAmount);
	dictionary[kTHNCouponSingleModelProductAmount] = @(self.productAmount);
	dictionary[kTHNCouponSingleModelProductCouponAmount] = @(self.productCouponAmount);
	if(self.productCover != nil){
		dictionary[kTHNCouponSingleModelProductCover] = self.productCover;
	}
	if(self.productName != nil){
		dictionary[kTHNCouponSingleModelProductName] = self.productName;
	}
	if(self.productRid != nil){
		dictionary[kTHNCouponSingleModelProductRid] = self.productRid;
	}
	if(self.storeRid != nil){
		dictionary[kTHNCouponSingleModelStoreRid] = self.storeRid;
	}
	dictionary[kTHNCouponSingleModelSurplusCount] = @(self.surplusCount);
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
	[aCoder encodeObject:@(self.amount) forKey:kTHNCouponSingleModelAmount];	if(self.couponCode != nil){
		[aCoder encodeObject:self.couponCode forKey:kTHNCouponSingleModelCouponCode];
	}
	[aCoder encodeObject:@(self.isGrant) forKey:kTHNCouponSingleModelIsGrant];	[aCoder encodeObject:@(self.isRecommend) forKey:kTHNCouponSingleModelIsRecommend];	[aCoder encodeObject:@(self.minAmount) forKey:kTHNCouponSingleModelMinAmount];	[aCoder encodeObject:@(self.productAmount) forKey:kTHNCouponSingleModelProductAmount];	[aCoder encodeObject:@(self.productCouponAmount) forKey:kTHNCouponSingleModelProductCouponAmount];	if(self.productCover != nil){
		[aCoder encodeObject:self.productCover forKey:kTHNCouponSingleModelProductCover];
	}
	if(self.productName != nil){
		[aCoder encodeObject:self.productName forKey:kTHNCouponSingleModelProductName];
	}
	if(self.productRid != nil){
		[aCoder encodeObject:self.productRid forKey:kTHNCouponSingleModelProductRid];
	}
	if(self.storeRid != nil){
		[aCoder encodeObject:self.storeRid forKey:kTHNCouponSingleModelStoreRid];
	}
	[aCoder encodeObject:@(self.surplusCount) forKey:kTHNCouponSingleModelSurplusCount];
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.amount = [[aDecoder decodeObjectForKey:kTHNCouponSingleModelAmount] integerValue];
	self.couponCode = [aDecoder decodeObjectForKey:kTHNCouponSingleModelCouponCode];
	self.isGrant = [[aDecoder decodeObjectForKey:kTHNCouponSingleModelIsGrant] boolValue];
	self.isRecommend = [[aDecoder decodeObjectForKey:kTHNCouponSingleModelIsRecommend] boolValue];
	self.minAmount = [[aDecoder decodeObjectForKey:kTHNCouponSingleModelMinAmount] integerValue];
	self.productAmount = [[aDecoder decodeObjectForKey:kTHNCouponSingleModelProductAmount] integerValue];
	self.productCouponAmount = [[aDecoder decodeObjectForKey:kTHNCouponSingleModelProductCouponAmount] integerValue];
	self.productCover = [aDecoder decodeObjectForKey:kTHNCouponSingleModelProductCover];
	self.productName = [aDecoder decodeObjectForKey:kTHNCouponSingleModelProductName];
	self.productRid = [aDecoder decodeObjectForKey:kTHNCouponSingleModelProductRid];
	self.storeRid = [aDecoder decodeObjectForKey:kTHNCouponSingleModelStoreRid];
	self.surplusCount = [[aDecoder decodeObjectForKey:kTHNCouponSingleModelSurplusCount] integerValue];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	THNCouponSingleModel *copy = [THNCouponSingleModel new];

	copy.amount = self.amount;
	copy.couponCode = [self.couponCode copy];
	copy.isGrant = self.isGrant;
	copy.isRecommend = self.isRecommend;
	copy.minAmount = self.minAmount;
	copy.productAmount = self.productAmount;
	copy.productCouponAmount = self.productCouponAmount;
	copy.productCover = [self.productCover copy];
	copy.productName = [self.productName copy];
	copy.productRid = [self.productRid copy];
	copy.storeRid = [self.storeRid copy];
	copy.surplusCount = self.surplusCount;

	return copy;
}
@end