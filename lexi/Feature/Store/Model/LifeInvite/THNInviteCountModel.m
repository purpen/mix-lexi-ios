//
//	THNInviteCountModel.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNInviteCountModel.h"

NSString *const kTHNInviteCountModelInviteCount = @"invite_count";
NSString *const kTHNInviteCountModelPendingPrice = @"pending_price";
NSString *const kTHNInviteCountModelRewardPrice = @"reward_price";
NSString *const kTHNInviteCountModelTodayCount = @"today_count";

@interface THNInviteCountModel ()
@end
@implementation THNInviteCountModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNInviteCountModelInviteCount] isKindOfClass:[NSNull class]]){
		self.inviteCount = [dictionary[kTHNInviteCountModelInviteCount] integerValue];
	}

	if(![dictionary[kTHNInviteCountModelPendingPrice] isKindOfClass:[NSNull class]]){
		self.pendingPrice = [dictionary[kTHNInviteCountModelPendingPrice] integerValue];
	}

	if(![dictionary[kTHNInviteCountModelRewardPrice] isKindOfClass:[NSNull class]]){
		self.rewardPrice = [dictionary[kTHNInviteCountModelRewardPrice] integerValue];
	}

	if(![dictionary[kTHNInviteCountModelTodayCount] isKindOfClass:[NSNull class]]){
		self.todayCount = [dictionary[kTHNInviteCountModelTodayCount] integerValue];
	}

	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	dictionary[kTHNInviteCountModelInviteCount] = @(self.inviteCount);
	dictionary[kTHNInviteCountModelPendingPrice] = @(self.pendingPrice);
	dictionary[kTHNInviteCountModelRewardPrice] = @(self.rewardPrice);
	dictionary[kTHNInviteCountModelTodayCount] = @(self.todayCount);
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
	[aCoder encodeObject:@(self.inviteCount) forKey:kTHNInviteCountModelInviteCount];	[aCoder encodeObject:@(self.pendingPrice) forKey:kTHNInviteCountModelPendingPrice];	[aCoder encodeObject:@(self.rewardPrice) forKey:kTHNInviteCountModelRewardPrice];	[aCoder encodeObject:@(self.todayCount) forKey:kTHNInviteCountModelTodayCount];
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.inviteCount = [[aDecoder decodeObjectForKey:kTHNInviteCountModelInviteCount] integerValue];
	self.pendingPrice = [[aDecoder decodeObjectForKey:kTHNInviteCountModelPendingPrice] integerValue];
	self.rewardPrice = [[aDecoder decodeObjectForKey:kTHNInviteCountModelRewardPrice] integerValue];
	self.todayCount = [[aDecoder decodeObjectForKey:kTHNInviteCountModelTodayCount] integerValue];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	THNInviteCountModel *copy = [THNInviteCountModel new];

	copy.inviteCount = self.inviteCount;
	copy.pendingPrice = self.pendingPrice;
	copy.rewardPrice = self.rewardPrice;
	copy.todayCount = self.todayCount;

	return copy;
}
@end