//
//	THNCouponOfficialModel.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNCouponOfficialModel.h"

NSString *const kTHNCouponOfficialModelAmount = @"amount";
NSString *const kTHNCouponOfficialModelCode = @"code";
NSString *const kTHNCouponOfficialModelCount = @"count";
NSString *const kTHNCouponOfficialModelCreatedAt = @"created_at";
NSString *const kTHNCouponOfficialModelEndDate = @"end_date";
NSString *const kTHNCouponOfficialModelIsGrant = @"is_grant";
NSString *const kTHNCouponOfficialModelMinAmount = @"min_amount";
NSString *const kTHNCouponOfficialModelPickupCount = @"pickup_count";
NSString *const kTHNCouponOfficialModelStartDate = @"start_date";
NSString *const kTHNCouponOfficialModelSurplusCount = @"surplus_count";
NSString *const kTHNCouponOfficialModelTypeText = @"type_text";
NSString *const kTHNCouponOfficialModelUseCount = @"use_count";
NSString *const kTHNCouponOfficialModelCategoryName = @"category_name";

@interface THNCouponOfficialModel ()
@end
@implementation THNCouponOfficialModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNCouponOfficialModelAmount] isKindOfClass:[NSNull class]]){
		self.amount = [dictionary[kTHNCouponOfficialModelAmount] floatValue];
	}

	if(![dictionary[kTHNCouponOfficialModelCode] isKindOfClass:[NSNull class]]){
		self.code = dictionary[kTHNCouponOfficialModelCode];
	}	
	if(![dictionary[kTHNCouponOfficialModelCount] isKindOfClass:[NSNull class]]){
		self.count = [dictionary[kTHNCouponOfficialModelCount] integerValue];
	}

	if(![dictionary[kTHNCouponOfficialModelCreatedAt] isKindOfClass:[NSNull class]]){
		self.createdAt = [dictionary[kTHNCouponOfficialModelCreatedAt] integerValue];
	}

	if(![dictionary[kTHNCouponOfficialModelEndDate] isKindOfClass:[NSNull class]]){
		self.endDate = [dictionary[kTHNCouponOfficialModelEndDate] integerValue];
	}

	if(![dictionary[kTHNCouponOfficialModelIsGrant] isKindOfClass:[NSNull class]]){
		self.isGrant = [dictionary[kTHNCouponOfficialModelIsGrant] boolValue];
	}

	if(![dictionary[kTHNCouponOfficialModelMinAmount] isKindOfClass:[NSNull class]]){
		self.minAmount = [dictionary[kTHNCouponOfficialModelMinAmount] floatValue];
	}

	if(![dictionary[kTHNCouponOfficialModelPickupCount] isKindOfClass:[NSNull class]]){
		self.pickupCount = [dictionary[kTHNCouponOfficialModelPickupCount] integerValue];
	}

	if(![dictionary[kTHNCouponOfficialModelStartDate] isKindOfClass:[NSNull class]]){
		self.startDate = [dictionary[kTHNCouponOfficialModelStartDate] integerValue];
	}

	if(![dictionary[kTHNCouponOfficialModelSurplusCount] isKindOfClass:[NSNull class]]){
		self.surplusCount = [dictionary[kTHNCouponOfficialModelSurplusCount] integerValue];
	}

	if(![dictionary[kTHNCouponOfficialModelTypeText] isKindOfClass:[NSNull class]]){
		self.typeText = dictionary[kTHNCouponOfficialModelTypeText];
	}	
    if(![dictionary[kTHNCouponOfficialModelUseCount] isKindOfClass:[NSNull class]]){
        self.useCount = [dictionary[kTHNCouponOfficialModelUseCount] integerValue];
    }
    
    if(![dictionary[kTHNCouponOfficialModelCategoryName] isKindOfClass:[NSNull class]]){
        self.categoryName = dictionary[kTHNCouponOfficialModelCategoryName];
    }

	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	dictionary[kTHNCouponOfficialModelAmount] = @(self.amount);
	if(self.code != nil){
		dictionary[kTHNCouponOfficialModelCode] = self.code;
	}
	dictionary[kTHNCouponOfficialModelCount] = @(self.count);
	dictionary[kTHNCouponOfficialModelCreatedAt] = @(self.createdAt);
	dictionary[kTHNCouponOfficialModelEndDate] = @(self.endDate);
	dictionary[kTHNCouponOfficialModelIsGrant] = @(self.isGrant);
	dictionary[kTHNCouponOfficialModelMinAmount] = @(self.minAmount);
	dictionary[kTHNCouponOfficialModelPickupCount] = @(self.pickupCount);
	dictionary[kTHNCouponOfficialModelStartDate] = @(self.startDate);
	dictionary[kTHNCouponOfficialModelSurplusCount] = @(self.surplusCount);
    if (self.categoryName != nil) {
        dictionary[kTHNCouponOfficialModelCategoryName] = self.categoryName;
    }
	if(self.typeText != nil){
		dictionary[kTHNCouponOfficialModelTypeText] = self.typeText;
	}
	dictionary[kTHNCouponOfficialModelUseCount] = @(self.useCount);
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
	[aCoder encodeObject:@(self.amount) forKey:kTHNCouponOfficialModelAmount];	if(self.code != nil){
		[aCoder encodeObject:self.code forKey:kTHNCouponOfficialModelCode];
	}
    if (self.categoryName != nil) {
        [aCoder encodeObject:self.categoryName forKey:kTHNCouponOfficialModelCategoryName];
    }
	[aCoder encodeObject:@(self.count) forKey:kTHNCouponOfficialModelCount];	[aCoder encodeObject:@(self.createdAt) forKey:kTHNCouponOfficialModelCreatedAt];	[aCoder encodeObject:@(self.endDate) forKey:kTHNCouponOfficialModelEndDate];	[aCoder encodeObject:@(self.isGrant) forKey:kTHNCouponOfficialModelIsGrant];	[aCoder encodeObject:@(self.minAmount) forKey:kTHNCouponOfficialModelMinAmount];	[aCoder encodeObject:@(self.pickupCount) forKey:kTHNCouponOfficialModelPickupCount];	[aCoder encodeObject:@(self.startDate) forKey:kTHNCouponOfficialModelStartDate];	[aCoder encodeObject:@(self.surplusCount) forKey:kTHNCouponOfficialModelSurplusCount];	if(self.typeText != nil){
		[aCoder encodeObject:self.typeText forKey:kTHNCouponOfficialModelTypeText];
	}
	[aCoder encodeObject:@(self.useCount) forKey:kTHNCouponOfficialModelUseCount];
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.amount = [[aDecoder decodeObjectForKey:kTHNCouponOfficialModelAmount] integerValue];
	self.code = [aDecoder decodeObjectForKey:kTHNCouponOfficialModelCode];
    self.categoryName = [aDecoder decodeObjectForKey:kTHNCouponOfficialModelCategoryName];
	self.count = [[aDecoder decodeObjectForKey:kTHNCouponOfficialModelCount] integerValue];
	self.createdAt = [[aDecoder decodeObjectForKey:kTHNCouponOfficialModelCreatedAt] integerValue];
	self.endDate = [[aDecoder decodeObjectForKey:kTHNCouponOfficialModelEndDate] integerValue];
	self.isGrant = [[aDecoder decodeObjectForKey:kTHNCouponOfficialModelIsGrant] boolValue];
	self.minAmount = [[aDecoder decodeObjectForKey:kTHNCouponOfficialModelMinAmount] integerValue];
	self.pickupCount = [[aDecoder decodeObjectForKey:kTHNCouponOfficialModelPickupCount] integerValue];
	self.startDate = [[aDecoder decodeObjectForKey:kTHNCouponOfficialModelStartDate] integerValue];
	self.surplusCount = [[aDecoder decodeObjectForKey:kTHNCouponOfficialModelSurplusCount] integerValue];
	self.typeText = [aDecoder decodeObjectForKey:kTHNCouponOfficialModelTypeText];
	self.useCount = [[aDecoder decodeObjectForKey:kTHNCouponOfficialModelUseCount] integerValue];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	THNCouponOfficialModel *copy = [THNCouponOfficialModel new];

	copy.amount = self.amount;
	copy.code = [self.code copy];
    copy.categoryName = [self.categoryName copy];
	copy.count = self.count;
	copy.createdAt = self.createdAt;
	copy.endDate = self.endDate;
	copy.isGrant = self.isGrant;
	copy.minAmount = self.minAmount;
	copy.pickupCount = self.pickupCount;
	copy.startDate = self.startDate;
	copy.surplusCount = self.surplusCount;
	copy.typeText = [self.typeText copy];
	copy.useCount = self.useCount;

	return copy;
}
@end
