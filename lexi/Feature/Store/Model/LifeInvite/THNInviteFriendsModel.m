//
//	THNInviteFriendsModel.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNInviteFriendsModel.h"

NSString *const kTHNInviteFriendsModelCount = @"count";
NSString *const kTHNInviteFriendsModelFriends = @"friends";
NSString *const kTHNInviteFriendsModelNext = @"next";
NSString *const kTHNInviteFriendsModelPrev = @"prev";

@interface THNInviteFriendsModel ()
@end
@implementation THNInviteFriendsModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNInviteFriendsModelCount] isKindOfClass:[NSNull class]]){
		self.count = [dictionary[kTHNInviteFriendsModelCount] integerValue];
	}

	if(dictionary[kTHNInviteFriendsModelFriends] != nil && [dictionary[kTHNInviteFriendsModelFriends] isKindOfClass:[NSArray class]]){
		NSArray * friendsDictionaries = dictionary[kTHNInviteFriendsModelFriends];
		NSMutableArray * friendsItems = [NSMutableArray array];
		for(NSDictionary * friendsDictionary in friendsDictionaries){
			THNInviteFriendsModelFriends * friendsItem = [[THNInviteFriendsModelFriends alloc] initWithDictionary:friendsDictionary];
			[friendsItems addObject:friendsItem];
		}
		self.friends = friendsItems;
	}
	if(![dictionary[kTHNInviteFriendsModelNext] isKindOfClass:[NSNull class]]){
		self.next = [dictionary[kTHNInviteFriendsModelNext] boolValue];
	}

	if(![dictionary[kTHNInviteFriendsModelPrev] isKindOfClass:[NSNull class]]){
		self.prev = [dictionary[kTHNInviteFriendsModelPrev] boolValue];
	}

	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	dictionary[kTHNInviteFriendsModelCount] = @(self.count);
	if(self.friends != nil){
		NSMutableArray * dictionaryElements = [NSMutableArray array];
		for(THNInviteFriendsModelFriends * friendsElement in self.friends){
			[dictionaryElements addObject:[friendsElement toDictionary]];
		}
		dictionary[kTHNInviteFriendsModelFriends] = dictionaryElements;
	}
	dictionary[kTHNInviteFriendsModelNext] = @(self.next);
	dictionary[kTHNInviteFriendsModelPrev] = @(self.prev);
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
	[aCoder encodeObject:@(self.count) forKey:kTHNInviteFriendsModelCount];	if(self.friends != nil){
		[aCoder encodeObject:self.friends forKey:kTHNInviteFriendsModelFriends];
	}
	[aCoder encodeObject:@(self.next) forKey:kTHNInviteFriendsModelNext];	[aCoder encodeObject:@(self.prev) forKey:kTHNInviteFriendsModelPrev];
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.count = [[aDecoder decodeObjectForKey:kTHNInviteFriendsModelCount] integerValue];
	self.friends = [aDecoder decodeObjectForKey:kTHNInviteFriendsModelFriends];
	self.next = [[aDecoder decodeObjectForKey:kTHNInviteFriendsModelNext] boolValue];
	self.prev = [[aDecoder decodeObjectForKey:kTHNInviteFriendsModelPrev] boolValue];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	THNInviteFriendsModel *copy = [THNInviteFriendsModel new];

	copy.count = self.count;
	copy.friends = [self.friends copy];
	copy.next = self.next;
	copy.prev = self.prev;

	return copy;
}
@end