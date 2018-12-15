//
//	THNInviteRewardsModel.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNInviteRewardsModel.h"

NSString *const kTHNInviteRewardsModelCount = @"count";
NSString *const kTHNInviteRewardsModelNext = @"next";
NSString *const kTHNInviteRewardsModelPrev = @"prev";
NSString *const kTHNInviteRewardsModelRewards = @"rewards";

@interface THNInviteRewardsModel ()
@end
@implementation THNInviteRewardsModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNInviteRewardsModelCount] isKindOfClass:[NSNull class]]){
		self.count = [dictionary[kTHNInviteRewardsModelCount] integerValue];
	}

	if(![dictionary[kTHNInviteRewardsModelNext] isKindOfClass:[NSNull class]]){
		self.next = [dictionary[kTHNInviteRewardsModelNext] boolValue];
	}

	if(![dictionary[kTHNInviteRewardsModelPrev] isKindOfClass:[NSNull class]]){
		self.prev = [dictionary[kTHNInviteRewardsModelPrev] boolValue];
	}

	if(dictionary[kTHNInviteRewardsModelRewards] != nil && [dictionary[kTHNInviteRewardsModelRewards] isKindOfClass:[NSArray class]]){
		NSArray * rewardsDictionaries = dictionary[kTHNInviteRewardsModelRewards];
		NSMutableArray * rewardsItems = [NSMutableArray array];
		for(NSDictionary * rewardsDictionary in rewardsDictionaries){
			THNInviteRewardsModelRewards * rewardsItem = [[THNInviteRewardsModelRewards alloc] initWithDictionary:rewardsDictionary];
			[rewardsItems addObject:rewardsItem];
		}
		self.rewards = rewardsItems;
	}
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	dictionary[kTHNInviteRewardsModelCount] = @(self.count);
	dictionary[kTHNInviteRewardsModelNext] = @(self.next);
	dictionary[kTHNInviteRewardsModelPrev] = @(self.prev);
	if(self.rewards != nil){
		NSMutableArray * dictionaryElements = [NSMutableArray array];
		for(THNInviteRewardsModelRewards * rewardsElement in self.rewards){
			[dictionaryElements addObject:[rewardsElement toDictionary]];
		}
		dictionary[kTHNInviteRewardsModelRewards] = dictionaryElements;
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
	[aCoder encodeObject:@(self.count) forKey:kTHNInviteRewardsModelCount];	[aCoder encodeObject:@(self.next) forKey:kTHNInviteRewardsModelNext];	[aCoder encodeObject:@(self.prev) forKey:kTHNInviteRewardsModelPrev];	if(self.rewards != nil){
		[aCoder encodeObject:self.rewards forKey:kTHNInviteRewardsModelRewards];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.count = [[aDecoder decodeObjectForKey:kTHNInviteRewardsModelCount] integerValue];
	self.next = [[aDecoder decodeObjectForKey:kTHNInviteRewardsModelNext] boolValue];
	self.prev = [[aDecoder decodeObjectForKey:kTHNInviteRewardsModelPrev] boolValue];
	self.rewards = [aDecoder decodeObjectForKey:kTHNInviteRewardsModelRewards];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	THNInviteRewardsModel *copy = [THNInviteRewardsModel new];

	copy.count = self.count;
	copy.next = self.next;
	copy.prev = self.prev;
	copy.rewards = [self.rewards copy];

	return copy;
}
@end