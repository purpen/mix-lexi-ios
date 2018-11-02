//
//	THNCouponSharedModelProductSku.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNCouponSharedModelProductSku.h"

NSString *const kTHNCouponSharedModelProductSkuProductAmount = @"product_amount";
NSString *const kTHNCouponSharedModelProductSkuProductCouponAmount = @"product_coupon_amount";
NSString *const kTHNCouponSharedModelProductSkuProductCover = @"product_cover";
NSString *const kTHNCouponSharedModelProductSkuProductName = @"product_name";
NSString *const kTHNCouponSharedModelProductSkuProductRid = @"product_rid";

@interface THNCouponSharedModelProductSku ()
@end
@implementation THNCouponSharedModelProductSku




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNCouponSharedModelProductSkuProductAmount] isKindOfClass:[NSNull class]]){
		self.productAmount = [dictionary[kTHNCouponSharedModelProductSkuProductAmount] floatValue];
	}

	if(![dictionary[kTHNCouponSharedModelProductSkuProductCouponAmount] isKindOfClass:[NSNull class]]){
		self.productCouponAmount = [dictionary[kTHNCouponSharedModelProductSkuProductCouponAmount] floatValue];
	}

	if(![dictionary[kTHNCouponSharedModelProductSkuProductCover] isKindOfClass:[NSNull class]]){
		self.productCover = dictionary[kTHNCouponSharedModelProductSkuProductCover];
	}	
	if(![dictionary[kTHNCouponSharedModelProductSkuProductName] isKindOfClass:[NSNull class]]){
		self.productName = dictionary[kTHNCouponSharedModelProductSkuProductName];
	}	
	if(![dictionary[kTHNCouponSharedModelProductSkuProductRid] isKindOfClass:[NSNull class]]){
		self.productRid = dictionary[kTHNCouponSharedModelProductSkuProductRid];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	dictionary[kTHNCouponSharedModelProductSkuProductAmount] = @(self.productAmount);
	dictionary[kTHNCouponSharedModelProductSkuProductCouponAmount] = @(self.productCouponAmount);
	if(self.productCover != nil){
		dictionary[kTHNCouponSharedModelProductSkuProductCover] = self.productCover;
	}
	if(self.productName != nil){
		dictionary[kTHNCouponSharedModelProductSkuProductName] = self.productName;
	}
	if(self.productRid != nil){
		dictionary[kTHNCouponSharedModelProductSkuProductRid] = self.productRid;
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
	[aCoder encodeObject:@(self.productAmount) forKey:kTHNCouponSharedModelProductSkuProductAmount];	[aCoder encodeObject:@(self.productCouponAmount) forKey:kTHNCouponSharedModelProductSkuProductCouponAmount];	if(self.productCover != nil){
		[aCoder encodeObject:self.productCover forKey:kTHNCouponSharedModelProductSkuProductCover];
	}
	if(self.productName != nil){
		[aCoder encodeObject:self.productName forKey:kTHNCouponSharedModelProductSkuProductName];
	}
	if(self.productRid != nil){
		[aCoder encodeObject:self.productRid forKey:kTHNCouponSharedModelProductSkuProductRid];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.productAmount = [[aDecoder decodeObjectForKey:kTHNCouponSharedModelProductSkuProductAmount] integerValue];
	self.productCouponAmount = [[aDecoder decodeObjectForKey:kTHNCouponSharedModelProductSkuProductCouponAmount] integerValue];
	self.productCover = [aDecoder decodeObjectForKey:kTHNCouponSharedModelProductSkuProductCover];
	self.productName = [aDecoder decodeObjectForKey:kTHNCouponSharedModelProductSkuProductName];
	self.productRid = [aDecoder decodeObjectForKey:kTHNCouponSharedModelProductSkuProductRid];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	THNCouponSharedModelProductSku *copy = [THNCouponSharedModelProductSku new];

	copy.productAmount = self.productAmount;
	copy.productCouponAmount = self.productCouponAmount;
	copy.productCover = [self.productCover copy];
	copy.productName = [self.productName copy];
	copy.productRid = [self.productRid copy];

	return copy;
}
@end
