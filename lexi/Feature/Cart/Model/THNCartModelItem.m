//
//	THNCartModelItem.m
//  on 15/9/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNCartModelItem.h"

NSString *const kTHNCartModelItemOption = @"option";
NSString *const kTHNCartModelItemProduct = @"product";
NSString *const kTHNCartModelItemQuantity = @"quantity";
NSString *const kTHNCartModelItemRid = @"rid";

@interface THNCartModelItem ()
@end
@implementation THNCartModelItem




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNCartModelItemOption] isKindOfClass:[NSNull class]]){
		self.option = dictionary[kTHNCartModelItemOption];
	}	
	if(![dictionary[kTHNCartModelItemProduct] isKindOfClass:[NSNull class]]){
		self.product = [[THNCartModelProduct alloc] initWithDictionary:dictionary[kTHNCartModelItemProduct]];
	}

	if(![dictionary[kTHNCartModelItemQuantity] isKindOfClass:[NSNull class]]){
		self.quantity = [dictionary[kTHNCartModelItemQuantity] integerValue];
	}

	if(![dictionary[kTHNCartModelItemRid] isKindOfClass:[NSNull class]]){
		self.rid = dictionary[kTHNCartModelItemRid];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.option != nil){
		dictionary[kTHNCartModelItemOption] = self.option;
	}
	if(self.product != nil){
		dictionary[kTHNCartModelItemProduct] = [self.product toDictionary];
	}
	dictionary[kTHNCartModelItemQuantity] = @(self.quantity);
	if(self.rid != nil){
		dictionary[kTHNCartModelItemRid] = self.rid;
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
	if(self.option != nil){
		[aCoder encodeObject:self.option forKey:kTHNCartModelItemOption];
	}
	if(self.product != nil){
		[aCoder encodeObject:self.product forKey:kTHNCartModelItemProduct];
	}
	[aCoder encodeObject:@(self.quantity) forKey:kTHNCartModelItemQuantity];	if(self.rid != nil){
		[aCoder encodeObject:self.rid forKey:kTHNCartModelItemRid];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.option = [aDecoder decodeObjectForKey:kTHNCartModelItemOption];
	self.product = [aDecoder decodeObjectForKey:kTHNCartModelItemProduct];
	self.quantity = [[aDecoder decodeObjectForKey:kTHNCartModelItemQuantity] integerValue];
	self.rid = [aDecoder decodeObjectForKey:kTHNCartModelItemRid];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	THNCartModelItem *copy = [THNCartModelItem new];

	copy.option = [self.option copy];
	copy.product = [self.product copy];
	copy.quantity = self.quantity;
	copy.rid = [self.rid copy];

	return copy;
}
@end
