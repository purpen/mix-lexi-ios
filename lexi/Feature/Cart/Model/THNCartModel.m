//
//	THNCartModel.m
//  on 15/9/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNCartModel.h"

NSString *const kTHNCartModelItemCount = @"item_count";
NSString *const kTHNCartModelItems = @"items";

@interface THNCartModel ()
@end
@implementation THNCartModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNCartModelItemCount] isKindOfClass:[NSNull class]]){
		self.itemCount = [dictionary[kTHNCartModelItemCount] integerValue];
	}

	if(dictionary[kTHNCartModelItems] != nil && [dictionary[kTHNCartModelItems] isKindOfClass:[NSArray class]]){
		NSArray * itemsDictionaries = dictionary[kTHNCartModelItems];
		NSMutableArray * itemsItems = [NSMutableArray array];
		for(NSDictionary * itemsDictionary in itemsDictionaries){
			THNCartModelItem * itemsItem = [[THNCartModelItem alloc] initWithDictionary:itemsDictionary];
			[itemsItems addObject:itemsItem];
		}
		self.items = itemsItems;
	}
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	dictionary[kTHNCartModelItemCount] = @(self.itemCount);
	if(self.items != nil){
		NSMutableArray * dictionaryElements = [NSMutableArray array];
		for(THNCartModelItem * itemsElement in self.items){
			[dictionaryElements addObject:[itemsElement toDictionary]];
		}
		dictionary[kTHNCartModelItems] = dictionaryElements;
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
	[aCoder encodeObject:@(self.itemCount) forKey:kTHNCartModelItemCount];	if(self.items != nil){
		[aCoder encodeObject:self.items forKey:kTHNCartModelItems];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.itemCount = [[aDecoder decodeObjectForKey:kTHNCartModelItemCount] integerValue];
	self.items = [aDecoder decodeObjectForKey:kTHNCartModelItems];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	THNCartModel *copy = [THNCartModel new];

	copy.itemCount = self.itemCount;
	copy.items = [self.items copy];

	return copy;
}
@end
