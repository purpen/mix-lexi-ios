//
//	THNCashRecordModel.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNCashRecordModel.h"

NSString *const kTHNCashRecordModelCount = @"count";
NSString *const kTHNCashRecordModelNext = @"next";
NSString *const kTHNCashRecordModelPrev = @"prev";
NSString *const kTHNCashRecordModelRecordList = @"record_list";

@interface THNCashRecordModel ()
@end
@implementation THNCashRecordModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNCashRecordModelCount] isKindOfClass:[NSNull class]]){
		self.count = [dictionary[kTHNCashRecordModelCount] integerValue];
	}

	if(![dictionary[kTHNCashRecordModelNext] isKindOfClass:[NSNull class]]){
		self.next = [dictionary[kTHNCashRecordModelNext] boolValue];
	}

	if(![dictionary[kTHNCashRecordModelPrev] isKindOfClass:[NSNull class]]){
		self.prev = [dictionary[kTHNCashRecordModelPrev] boolValue];
	}

	if(dictionary[kTHNCashRecordModelRecordList] != nil && [dictionary[kTHNCashRecordModelRecordList] isKindOfClass:[NSArray class]]){
		NSArray * recordListDictionaries = dictionary[kTHNCashRecordModelRecordList];
		NSMutableArray * recordListItems = [NSMutableArray array];
		for(NSDictionary * recordListDictionary in recordListDictionaries){
			THNCashRecordModelRecordList * recordListItem = [[THNCashRecordModelRecordList alloc] initWithDictionary:recordListDictionary];
			[recordListItems addObject:recordListItem];
		}
		self.recordList = recordListItems;
	}
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	dictionary[kTHNCashRecordModelCount] = @(self.count);
	dictionary[kTHNCashRecordModelNext] = @(self.next);
	dictionary[kTHNCashRecordModelPrev] = @(self.prev);
	if(self.recordList != nil){
		NSMutableArray * dictionaryElements = [NSMutableArray array];
		for(THNCashRecordModelRecordList * recordListElement in self.recordList){
			[dictionaryElements addObject:[recordListElement toDictionary]];
		}
		dictionary[kTHNCashRecordModelRecordList] = dictionaryElements;
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
	[aCoder encodeObject:@(self.count) forKey:kTHNCashRecordModelCount];	[aCoder encodeObject:@(self.next) forKey:kTHNCashRecordModelNext];	[aCoder encodeObject:@(self.prev) forKey:kTHNCashRecordModelPrev];	if(self.recordList != nil){
		[aCoder encodeObject:self.recordList forKey:kTHNCashRecordModelRecordList];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.count = [[aDecoder decodeObjectForKey:kTHNCashRecordModelCount] integerValue];
	self.next = [[aDecoder decodeObjectForKey:kTHNCashRecordModelNext] boolValue];
	self.prev = [[aDecoder decodeObjectForKey:kTHNCashRecordModelPrev] boolValue];
	self.recordList = [aDecoder decodeObjectForKey:kTHNCashRecordModelRecordList];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	THNCashRecordModel *copy = [THNCashRecordModel new];

	copy.count = self.count;
	copy.next = self.next;
	copy.prev = self.prev;
	copy.recordList = [self.recordList copy];

	return copy;
}
@end