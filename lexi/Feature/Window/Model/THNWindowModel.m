//
//	THNWindowModel.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNWindowModel.h"

NSString *const kTHNWindowModelCount = @"count";
NSString *const kTHNWindowModelNext = @"next";
NSString *const kTHNWindowModelPrev = @"prev";
NSString *const kTHNWindowModelShopWindows = @"shop_windows";

@interface THNWindowModel ()
@end
@implementation THNWindowModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNWindowModelCount] isKindOfClass:[NSNull class]]){
		self.count = [dictionary[kTHNWindowModelCount] integerValue];
	}

	if(![dictionary[kTHNWindowModelNext] isKindOfClass:[NSNull class]]){
		self.next = [dictionary[kTHNWindowModelNext] boolValue];
	}

	if(![dictionary[kTHNWindowModelPrev] isKindOfClass:[NSNull class]]){
		self.prev = [dictionary[kTHNWindowModelPrev] boolValue];
	}

	if(dictionary[kTHNWindowModelShopWindows] != nil && [dictionary[kTHNWindowModelShopWindows] isKindOfClass:[NSArray class]]){
		NSArray * shopWindowsDictionaries = dictionary[kTHNWindowModelShopWindows];
		NSMutableArray * shopWindowsItems = [NSMutableArray array];
		for(NSDictionary * shopWindowsDictionary in shopWindowsDictionaries){
			THNWindowModelShopWindows * shopWindowsItem = [[THNWindowModelShopWindows alloc] initWithDictionary:shopWindowsDictionary];
			[shopWindowsItems addObject:shopWindowsItem];
		}
		self.shopWindows = shopWindowsItems;
	}
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	dictionary[kTHNWindowModelCount] = @(self.count);
	dictionary[kTHNWindowModelNext] = @(self.next);
	dictionary[kTHNWindowModelPrev] = @(self.prev);
	if(self.shopWindows != nil){
		NSMutableArray * dictionaryElements = [NSMutableArray array];
		for(THNWindowModelShopWindows * shopWindowsElement in self.shopWindows){
			[dictionaryElements addObject:[shopWindowsElement toDictionary]];
		}
		dictionary[kTHNWindowModelShopWindows] = dictionaryElements;
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
	[aCoder encodeObject:@(self.count) forKey:kTHNWindowModelCount];	[aCoder encodeObject:@(self.next) forKey:kTHNWindowModelNext];	[aCoder encodeObject:@(self.prev) forKey:kTHNWindowModelPrev];	if(self.shopWindows != nil){
		[aCoder encodeObject:self.shopWindows forKey:kTHNWindowModelShopWindows];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.count = [[aDecoder decodeObjectForKey:kTHNWindowModelCount] integerValue];
	self.next = [[aDecoder decodeObjectForKey:kTHNWindowModelNext] boolValue];
	self.prev = [[aDecoder decodeObjectForKey:kTHNWindowModelPrev] boolValue];
	self.shopWindows = [aDecoder decodeObjectForKey:kTHNWindowModelShopWindows];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	THNWindowModel *copy = [THNWindowModel new];

	copy.count = self.count;
	copy.next = self.next;
	copy.prev = self.prev;
	copy.shopWindows = [self.shopWindows copy];

	return copy;
}
@end