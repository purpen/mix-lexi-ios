//
//	THNInviteFriendsModelFriends.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNInviteFriendsModelFriends.h"

NSString *const kTHNInviteFriendsModelFriendsAmount = @"amount";
NSString *const kTHNInviteFriendsModelFriendsPhases = @"phases";
NSString *const kTHNInviteFriendsModelFriendsUserLogo = @"user_logo";
NSString *const kTHNInviteFriendsModelFriendsUserName = @"user_name";
NSString *const kTHNInviteFriendsModelFriendsUserSn = @"user_sn";

@interface THNInviteFriendsModelFriends ()
@end
@implementation THNInviteFriendsModelFriends




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNInviteFriendsModelFriendsAmount] isKindOfClass:[NSNull class]]){
		self.amount = [dictionary[kTHNInviteFriendsModelFriendsAmount] floatValue];
	}

	if(![dictionary[kTHNInviteFriendsModelFriendsPhases] isKindOfClass:[NSNull class]]){
		self.phases = [dictionary[kTHNInviteFriendsModelFriendsPhases] integerValue];
	}

	if(![dictionary[kTHNInviteFriendsModelFriendsUserLogo] isKindOfClass:[NSNull class]]){
		self.userLogo = dictionary[kTHNInviteFriendsModelFriendsUserLogo];
	}	
	if(![dictionary[kTHNInviteFriendsModelFriendsUserName] isKindOfClass:[NSNull class]]){
		self.userName = dictionary[kTHNInviteFriendsModelFriendsUserName];
	}	
	if(![dictionary[kTHNInviteFriendsModelFriendsUserSn] isKindOfClass:[NSNull class]]){
		self.userSn = dictionary[kTHNInviteFriendsModelFriendsUserSn];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	dictionary[kTHNInviteFriendsModelFriendsAmount] = @(self.amount);
	dictionary[kTHNInviteFriendsModelFriendsPhases] = @(self.phases);
	if(self.userLogo != nil){
		dictionary[kTHNInviteFriendsModelFriendsUserLogo] = self.userLogo;
	}
	if(self.userName != nil){
		dictionary[kTHNInviteFriendsModelFriendsUserName] = self.userName;
	}
	if(self.userSn != nil){
		dictionary[kTHNInviteFriendsModelFriendsUserSn] = self.userSn;
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
	[aCoder encodeObject:@(self.amount) forKey:kTHNInviteFriendsModelFriendsAmount];	[aCoder encodeObject:@(self.phases) forKey:kTHNInviteFriendsModelFriendsPhases];	if(self.userLogo != nil){
		[aCoder encodeObject:self.userLogo forKey:kTHNInviteFriendsModelFriendsUserLogo];
	}
	if(self.userName != nil){
		[aCoder encodeObject:self.userName forKey:kTHNInviteFriendsModelFriendsUserName];
	}
	if(self.userSn != nil){
		[aCoder encodeObject:self.userSn forKey:kTHNInviteFriendsModelFriendsUserSn];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.amount = [[aDecoder decodeObjectForKey:kTHNInviteFriendsModelFriendsAmount] integerValue];
	self.phases = [[aDecoder decodeObjectForKey:kTHNInviteFriendsModelFriendsPhases] integerValue];
	self.userLogo = [aDecoder decodeObjectForKey:kTHNInviteFriendsModelFriendsUserLogo];
	self.userName = [aDecoder decodeObjectForKey:kTHNInviteFriendsModelFriendsUserName];
	self.userSn = [aDecoder decodeObjectForKey:kTHNInviteFriendsModelFriendsUserSn];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	THNInviteFriendsModelFriends *copy = [THNInviteFriendsModelFriends new];

	copy.amount = self.amount;
	copy.phases = self.phases;
	copy.userLogo = [self.userLogo copy];
	copy.userName = [self.userName copy];
	copy.userSn = [self.userSn copy];

	return copy;
}
@end
