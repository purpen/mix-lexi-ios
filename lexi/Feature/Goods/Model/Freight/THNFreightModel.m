//
//	THNFreightModel.m
//  on 3/9/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNFreightModel.h"

NSString *const kTHNFreightModelItems = @"items";
NSString *const kTHNFreightModelName = @"name";
NSString *const kTHNFreightModelPricingMethod = @"pricing_method";
NSString *const kTHNFreightModelRid = @"rid";
NSString *const kTHNFreightModelUpdateAt = @"update_at";

@interface THNFreightModel ()
@end
@implementation THNFreightModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(dictionary[kTHNFreightModelItems] != nil && [dictionary[kTHNFreightModelItems] isKindOfClass:[NSArray class]]){
		NSArray * itemsDictionaries = dictionary[kTHNFreightModelItems];
		NSMutableArray * itemsItems = [NSMutableArray array];
		for(NSDictionary * itemsDictionary in itemsDictionaries){
			THNFreightModelItem * itemsItem = [[THNFreightModelItem alloc] initWithDictionary:itemsDictionary];
			[itemsItems addObject:itemsItem];
		}
		self.items = itemsItems;
	}
	if(![dictionary[kTHNFreightModelName] isKindOfClass:[NSNull class]]){
		self.name = dictionary[kTHNFreightModelName];
	}	
	if(![dictionary[kTHNFreightModelPricingMethod] isKindOfClass:[NSNull class]]){
		self.pricingMethod = [dictionary[kTHNFreightModelPricingMethod] integerValue];
	}

	if(![dictionary[kTHNFreightModelRid] isKindOfClass:[NSNull class]]){
		self.rid = dictionary[kTHNFreightModelRid];
	}	
	if(![dictionary[kTHNFreightModelUpdateAt] isKindOfClass:[NSNull class]]){
		self.updateAt = [dictionary[kTHNFreightModelUpdateAt] integerValue];
	}

	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.items != nil){
		NSMutableArray * dictionaryElements = [NSMutableArray array];
		for(THNFreightModelItem * itemsElement in self.items){
			[dictionaryElements addObject:[itemsElement toDictionary]];
		}
		dictionary[kTHNFreightModelItems] = dictionaryElements;
	}
	if(self.name != nil){
		dictionary[kTHNFreightModelName] = self.name;
	}
	dictionary[kTHNFreightModelPricingMethod] = @(self.pricingMethod);
	if(self.rid != nil){
		dictionary[kTHNFreightModelRid] = self.rid;
	}
	dictionary[kTHNFreightModelUpdateAt] = @(self.updateAt);
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
	if(self.items != nil){
		[aCoder encodeObject:self.items forKey:kTHNFreightModelItems];
	}
	if(self.name != nil){
		[aCoder encodeObject:self.name forKey:kTHNFreightModelName];
	}
	[aCoder encodeObject:@(self.pricingMethod) forKey:kTHNFreightModelPricingMethod];	if(self.rid != nil){
		[aCoder encodeObject:self.rid forKey:kTHNFreightModelRid];
	}
	[aCoder encodeObject:@(self.updateAt) forKey:kTHNFreightModelUpdateAt];
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.items = [aDecoder decodeObjectForKey:kTHNFreightModelItems];
	self.name = [aDecoder decodeObjectForKey:kTHNFreightModelName];
	self.pricingMethod = [[aDecoder decodeObjectForKey:kTHNFreightModelPricingMethod] integerValue];
	self.rid = [aDecoder decodeObjectForKey:kTHNFreightModelRid];
	self.updateAt = [[aDecoder decodeObjectForKey:kTHNFreightModelUpdateAt] integerValue];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	THNFreightModel *copy = [THNFreightModel new];

	copy.items = [self.items copy];
	copy.name = [self.name copy];
	copy.pricingMethod = self.pricingMethod;
	copy.rid = [self.rid copy];
	copy.updateAt = self.updateAt;

	return copy;
}
@end
