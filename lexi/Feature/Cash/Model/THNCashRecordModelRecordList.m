//
//	THNCashRecordModelRecordList.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNCashRecordModelRecordList.h"

NSString *const kTHNCashRecordModelRecordListActualAmount = @"actual_amount";
NSString *const kTHNCashRecordModelRecordListCreatedAt = @"created_at";
NSString *const kTHNCashRecordModelRecordListRid = @"rid";
NSString *const kTHNCashRecordModelRecordListStatus = @"status";

@interface THNCashRecordModelRecordList ()
@end
@implementation THNCashRecordModelRecordList




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNCashRecordModelRecordListActualAmount] isKindOfClass:[NSNull class]]){
		self.actualAmount = [dictionary[kTHNCashRecordModelRecordListActualAmount] integerValue];
	}

	if(![dictionary[kTHNCashRecordModelRecordListCreatedAt] isKindOfClass:[NSNull class]]){
		self.createdAt = [dictionary[kTHNCashRecordModelRecordListCreatedAt] integerValue];
	}

	if(![dictionary[kTHNCashRecordModelRecordListRid] isKindOfClass:[NSNull class]]){
		self.rid = dictionary[kTHNCashRecordModelRecordListRid];
	}	
	if(![dictionary[kTHNCashRecordModelRecordListStatus] isKindOfClass:[NSNull class]]){
		self.status = [dictionary[kTHNCashRecordModelRecordListStatus] integerValue];
	}

	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	dictionary[kTHNCashRecordModelRecordListActualAmount] = @(self.actualAmount);
	dictionary[kTHNCashRecordModelRecordListCreatedAt] = @(self.createdAt);
	if(self.rid != nil){
		dictionary[kTHNCashRecordModelRecordListRid] = self.rid;
	}
	dictionary[kTHNCashRecordModelRecordListStatus] = @(self.status);
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
	[aCoder encodeObject:@(self.actualAmount) forKey:kTHNCashRecordModelRecordListActualAmount];	[aCoder encodeObject:@(self.createdAt) forKey:kTHNCashRecordModelRecordListCreatedAt];	if(self.rid != nil){
		[aCoder encodeObject:self.rid forKey:kTHNCashRecordModelRecordListRid];
	}
	[aCoder encodeObject:@(self.status) forKey:kTHNCashRecordModelRecordListStatus];
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.actualAmount = [[aDecoder decodeObjectForKey:kTHNCashRecordModelRecordListActualAmount] integerValue];
	self.createdAt = [[aDecoder decodeObjectForKey:kTHNCashRecordModelRecordListCreatedAt] integerValue];
	self.rid = [aDecoder decodeObjectForKey:kTHNCashRecordModelRecordListRid];
	self.status = [[aDecoder decodeObjectForKey:kTHNCashRecordModelRecordListStatus] integerValue];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	THNCashRecordModelRecordList *copy = [THNCashRecordModelRecordList new];

	copy.actualAmount = self.actualAmount;
	copy.createdAt = self.createdAt;
	copy.rid = [self.rid copy];
	copy.status = self.status;

	return copy;
}
@end