//
//	THNFreightModelItem.m
//  on 3/9/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNFreightModelItem.h"

NSString *const kTHNFreightModelItemContinuousAmount = @"continuous_amount";
NSString *const kTHNFreightModelItemContinuousItem = @"continuous_item";
NSString *const kTHNFreightModelItemContinuousWeight = @"continuous_weight";
NSString *const kTHNFreightModelItemExpressCode = @"express_code";
NSString *const kTHNFreightModelItemExpressId = @"express_id";
NSString *const kTHNFreightModelItemExpressName = @"express_name";
NSString *const kTHNFreightModelItemFirstAmount = @"first_amount";
NSString *const kTHNFreightModelItemFreight = @"freight";
NSString *const kTHNFreightModelItemFirstItem = @"first_item";
NSString *const kTHNFreightModelItemFirstWeight = @"first_weight";
NSString *const kTHNFreightModelItemIsDefault = @"is_default";
NSString *const kTHNFreightModelItemMaxDays = @"max_days";
NSString *const kTHNFreightModelItemMinDays = @"min_days";
NSString *const kTHNFreightModelItemPlaceItems = @"place_items";
NSString *const kTHNFreightModelItemRid = @"rid";

@interface THNFreightModelItem ()
@end
@implementation THNFreightModelItem




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNFreightModelItemContinuousAmount] isKindOfClass:[NSNull class]]){
		self.continuousAmount = [dictionary[kTHNFreightModelItemContinuousAmount] integerValue];
	}

	if(![dictionary[kTHNFreightModelItemContinuousItem] isKindOfClass:[NSNull class]]){
		self.continuousItem = [dictionary[kTHNFreightModelItemContinuousItem] integerValue];
	}

	if(![dictionary[kTHNFreightModelItemContinuousWeight] isKindOfClass:[NSNull class]]){
		self.continuousWeight = [dictionary[kTHNFreightModelItemContinuousWeight] integerValue];
	}

	if(![dictionary[kTHNFreightModelItemExpressCode] isKindOfClass:[NSNull class]]){
		self.expressCode = dictionary[kTHNFreightModelItemExpressCode];
	}	
	if(![dictionary[kTHNFreightModelItemExpressId] isKindOfClass:[NSNull class]]){
		self.expressId = [dictionary[kTHNFreightModelItemExpressId] integerValue];
	}

	if(![dictionary[kTHNFreightModelItemExpressName] isKindOfClass:[NSNull class]]){
		self.expressName = dictionary[kTHNFreightModelItemExpressName];
	}	
    if(![dictionary[kTHNFreightModelItemFirstAmount] isKindOfClass:[NSNull class]]){
        self.firstAmount = [dictionary[kTHNFreightModelItemFirstAmount] floatValue];
    }
    if(![dictionary[kTHNFreightModelItemFreight] isKindOfClass:[NSNull class]]){
        self.freight = [dictionary[kTHNFreightModelItemFreight] floatValue];
    }

	if(![dictionary[kTHNFreightModelItemFirstItem] isKindOfClass:[NSNull class]]){
		self.firstItem = [dictionary[kTHNFreightModelItemFirstItem] integerValue];
	}

	if(![dictionary[kTHNFreightModelItemFirstWeight] isKindOfClass:[NSNull class]]){
		self.firstWeight = [dictionary[kTHNFreightModelItemFirstWeight] integerValue];
	}

	if(![dictionary[kTHNFreightModelItemIsDefault] isKindOfClass:[NSNull class]]){
		self.isDefault = [dictionary[kTHNFreightModelItemIsDefault] boolValue];
	}

	if(![dictionary[kTHNFreightModelItemMaxDays] isKindOfClass:[NSNull class]]){
		self.maxDays = [dictionary[kTHNFreightModelItemMaxDays] integerValue];
	}

	if(![dictionary[kTHNFreightModelItemMinDays] isKindOfClass:[NSNull class]]){
		self.minDays = [dictionary[kTHNFreightModelItemMinDays] integerValue];
	}

	if(![dictionary[kTHNFreightModelItemPlaceItems] isKindOfClass:[NSNull class]]){
		self.placeItems = dictionary[kTHNFreightModelItemPlaceItems];
	}	
	if(![dictionary[kTHNFreightModelItemRid] isKindOfClass:[NSNull class]]){
		self.rid = dictionary[kTHNFreightModelItemRid];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	dictionary[kTHNFreightModelItemContinuousAmount] = @(self.continuousAmount);
	dictionary[kTHNFreightModelItemContinuousItem] = @(self.continuousItem);
	dictionary[kTHNFreightModelItemContinuousWeight] = @(self.continuousWeight);
	if(self.expressCode != nil){
		dictionary[kTHNFreightModelItemExpressCode] = self.expressCode;
	}
	dictionary[kTHNFreightModelItemExpressId] = @(self.expressId);
	if(self.expressName != nil){
		dictionary[kTHNFreightModelItemExpressName] = self.expressName;
	}
	dictionary[kTHNFreightModelItemFirstAmount] = @(self.firstAmount);
	dictionary[kTHNFreightModelItemFirstItem] = @(self.firstItem);
	dictionary[kTHNFreightModelItemFirstWeight] = @(self.firstWeight);
	dictionary[kTHNFreightModelItemIsDefault] = @(self.isDefault);
	dictionary[kTHNFreightModelItemMaxDays] = @(self.maxDays);
	dictionary[kTHNFreightModelItemMinDays] = @(self.minDays);
	if(self.placeItems != nil){
		dictionary[kTHNFreightModelItemPlaceItems] = self.placeItems;
	}
	if(self.rid != nil){
		dictionary[kTHNFreightModelItemRid] = self.rid;
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
	[aCoder encodeObject:@(self.continuousAmount) forKey:kTHNFreightModelItemContinuousAmount];	[aCoder encodeObject:@(self.continuousItem) forKey:kTHNFreightModelItemContinuousItem];	[aCoder encodeObject:@(self.continuousWeight) forKey:kTHNFreightModelItemContinuousWeight];	if(self.expressCode != nil){
		[aCoder encodeObject:self.expressCode forKey:kTHNFreightModelItemExpressCode];
	}
	[aCoder encodeObject:@(self.expressId) forKey:kTHNFreightModelItemExpressId];	if(self.expressName != nil){
		[aCoder encodeObject:self.expressName forKey:kTHNFreightModelItemExpressName];
	}
	[aCoder encodeObject:@(self.firstAmount) forKey:kTHNFreightModelItemFirstAmount];	[aCoder encodeObject:@(self.firstItem) forKey:kTHNFreightModelItemFirstItem];	[aCoder encodeObject:@(self.firstWeight) forKey:kTHNFreightModelItemFirstWeight];	[aCoder encodeObject:@(self.isDefault) forKey:kTHNFreightModelItemIsDefault];	[aCoder encodeObject:@(self.maxDays) forKey:kTHNFreightModelItemMaxDays];	[aCoder encodeObject:@(self.minDays) forKey:kTHNFreightModelItemMinDays];	if(self.placeItems != nil){
		[aCoder encodeObject:self.placeItems forKey:kTHNFreightModelItemPlaceItems];
	}
	if(self.rid != nil){
		[aCoder encodeObject:self.rid forKey:kTHNFreightModelItemRid];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.continuousAmount = [[aDecoder decodeObjectForKey:kTHNFreightModelItemContinuousAmount] integerValue];
	self.continuousItem = [[aDecoder decodeObjectForKey:kTHNFreightModelItemContinuousItem] integerValue];
	self.continuousWeight = [[aDecoder decodeObjectForKey:kTHNFreightModelItemContinuousWeight] integerValue];
	self.expressCode = [aDecoder decodeObjectForKey:kTHNFreightModelItemExpressCode];
	self.expressId = [[aDecoder decodeObjectForKey:kTHNFreightModelItemExpressId] integerValue];
	self.expressName = [aDecoder decodeObjectForKey:kTHNFreightModelItemExpressName];
	self.firstAmount = [[aDecoder decodeObjectForKey:kTHNFreightModelItemFirstAmount] integerValue];
	self.firstItem = [[aDecoder decodeObjectForKey:kTHNFreightModelItemFirstItem] integerValue];
	self.firstWeight = [[aDecoder decodeObjectForKey:kTHNFreightModelItemFirstWeight] integerValue];
	self.isDefault = [[aDecoder decodeObjectForKey:kTHNFreightModelItemIsDefault] boolValue];
	self.maxDays = [[aDecoder decodeObjectForKey:kTHNFreightModelItemMaxDays] integerValue];
	self.minDays = [[aDecoder decodeObjectForKey:kTHNFreightModelItemMinDays] integerValue];
	self.placeItems = [aDecoder decodeObjectForKey:kTHNFreightModelItemPlaceItems];
	self.rid = [aDecoder decodeObjectForKey:kTHNFreightModelItemRid];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	THNFreightModelItem *copy = [THNFreightModelItem new];

	copy.continuousAmount = self.continuousAmount;
	copy.continuousItem = self.continuousItem;
	copy.continuousWeight = self.continuousWeight;
	copy.expressCode = [self.expressCode copy];
	copy.expressId = self.expressId;
	copy.expressName = [self.expressName copy];
	copy.firstAmount = self.firstAmount;
	copy.firstItem = self.firstItem;
	copy.firstWeight = self.firstWeight;
	copy.isDefault = self.isDefault;
	copy.maxDays = self.maxDays;
	copy.minDays = self.minDays;
	copy.placeItems = [self.placeItems copy];
	copy.rid = [self.rid copy];

	return copy;
}
@end
