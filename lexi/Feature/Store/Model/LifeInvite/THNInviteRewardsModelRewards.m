//
//	THNInviteRewardsModelRewards.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNInviteRewardsModelRewards.h"

NSString *const kTHNInviteRewardsModelRewardsAmount = @"amount";
NSString *const kTHNInviteRewardsModelRewardsCreatedAt = @"created_at";
NSString *const kTHNInviteRewardsModelRewardsStatus = @"status";
NSString *const kTHNInviteRewardsModelRewardsTitle = @"title";
NSString *const kTHNInviteRewardsModelRewardsUserLogo = @"user_logo";
NSString *const kTHNInviteRewardsModelRewardsUserName = @"user_name";
NSString *const kTHNInviteRewardsModelRewardsUserSn = @"user_sn";

@interface THNInviteRewardsModelRewards ()
@end
@implementation THNInviteRewardsModelRewards




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNInviteRewardsModelRewardsAmount] isKindOfClass:[NSNull class]]){
		self.amount = [dictionary[kTHNInviteRewardsModelRewardsAmount] floatValue];
	}

	if(![dictionary[kTHNInviteRewardsModelRewardsCreatedAt] isKindOfClass:[NSNull class]]){
		self.createdAt = [dictionary[kTHNInviteRewardsModelRewardsCreatedAt] integerValue];
	}

	if(![dictionary[kTHNInviteRewardsModelRewardsStatus] isKindOfClass:[NSNull class]]){
		self.status = [dictionary[kTHNInviteRewardsModelRewardsStatus] integerValue];
	}

	if(![dictionary[kTHNInviteRewardsModelRewardsTitle] isKindOfClass:[NSNull class]]){
		self.title = dictionary[kTHNInviteRewardsModelRewardsTitle];
	}	
	if(![dictionary[kTHNInviteRewardsModelRewardsUserLogo] isKindOfClass:[NSNull class]]){
		self.userLogo = dictionary[kTHNInviteRewardsModelRewardsUserLogo];
	}	
	if(![dictionary[kTHNInviteRewardsModelRewardsUserName] isKindOfClass:[NSNull class]]){
		self.userName = dictionary[kTHNInviteRewardsModelRewardsUserName];
	}	
	if(![dictionary[kTHNInviteRewardsModelRewardsUserSn] isKindOfClass:[NSNull class]]){
		self.userSn = dictionary[kTHNInviteRewardsModelRewardsUserSn];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	dictionary[kTHNInviteRewardsModelRewardsAmount] = @(self.amount);
	dictionary[kTHNInviteRewardsModelRewardsCreatedAt] = @(self.createdAt);
	dictionary[kTHNInviteRewardsModelRewardsStatus] = @(self.status);
	if(self.title != nil){
		dictionary[kTHNInviteRewardsModelRewardsTitle] = self.title;
	}
	if(self.userLogo != nil){
		dictionary[kTHNInviteRewardsModelRewardsUserLogo] = self.userLogo;
	}
	if(self.userName != nil){
		dictionary[kTHNInviteRewardsModelRewardsUserName] = self.userName;
	}
	if(self.userSn != nil){
		dictionary[kTHNInviteRewardsModelRewardsUserSn] = self.userSn;
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
	[aCoder encodeObject:@(self.amount) forKey:kTHNInviteRewardsModelRewardsAmount];	[aCoder encodeObject:@(self.createdAt) forKey:kTHNInviteRewardsModelRewardsCreatedAt];	[aCoder encodeObject:@(self.status) forKey:kTHNInviteRewardsModelRewardsStatus];	if(self.title != nil){
		[aCoder encodeObject:self.title forKey:kTHNInviteRewardsModelRewardsTitle];
	}
	if(self.userLogo != nil){
		[aCoder encodeObject:self.userLogo forKey:kTHNInviteRewardsModelRewardsUserLogo];
	}
	if(self.userName != nil){
		[aCoder encodeObject:self.userName forKey:kTHNInviteRewardsModelRewardsUserName];
	}
	if(self.userSn != nil){
		[aCoder encodeObject:self.userSn forKey:kTHNInviteRewardsModelRewardsUserSn];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.amount = [[aDecoder decodeObjectForKey:kTHNInviteRewardsModelRewardsAmount] floatValue];
	self.createdAt = [[aDecoder decodeObjectForKey:kTHNInviteRewardsModelRewardsCreatedAt] integerValue];
	self.status = [[aDecoder decodeObjectForKey:kTHNInviteRewardsModelRewardsStatus] integerValue];
	self.title = [aDecoder decodeObjectForKey:kTHNInviteRewardsModelRewardsTitle];
	self.userLogo = [aDecoder decodeObjectForKey:kTHNInviteRewardsModelRewardsUserLogo];
	self.userName = [aDecoder decodeObjectForKey:kTHNInviteRewardsModelRewardsUserName];
	self.userSn = [aDecoder decodeObjectForKey:kTHNInviteRewardsModelRewardsUserSn];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	THNInviteRewardsModelRewards *copy = [THNInviteRewardsModelRewards new];

	copy.amount = self.amount;
	copy.createdAt = self.createdAt;
	copy.status = self.status;
	copy.title = [self.title copy];
	copy.userLogo = [self.userLogo copy];
	copy.userName = [self.userName copy];
	copy.userSn = [self.userSn copy];

	return copy;
}
@end