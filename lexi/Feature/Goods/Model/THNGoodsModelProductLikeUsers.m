//
//	THNGoodsModelProductLikeUsers.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNGoodsModelProductLikeUsers.h"

NSString *const kTHNGoodsModelProductLikeUsersAvatar = @"avatar";
NSString *const kTHNGoodsModelProductLikeUsersUid = @"uid";
NSString *const kTHNGoodsModelProductLikeUsersUsername = @"username";

@interface THNGoodsModelProductLikeUsers ()
@end
@implementation THNGoodsModelProductLikeUsers




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNGoodsModelProductLikeUsersAvatar] isKindOfClass:[NSNull class]]){
		self.avatar = dictionary[kTHNGoodsModelProductLikeUsersAvatar];
	}	
	if(![dictionary[kTHNGoodsModelProductLikeUsersUid] isKindOfClass:[NSNull class]]){
		self.uid = dictionary[kTHNGoodsModelProductLikeUsersUid];
	}	
	if(![dictionary[kTHNGoodsModelProductLikeUsersUsername] isKindOfClass:[NSNull class]]){
		self.username = dictionary[kTHNGoodsModelProductLikeUsersUsername];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.avatar != nil){
		dictionary[kTHNGoodsModelProductLikeUsersAvatar] = self.avatar;
	}
	if(self.uid != nil){
		dictionary[kTHNGoodsModelProductLikeUsersUid] = self.uid;
	}
	if(self.username != nil){
		dictionary[kTHNGoodsModelProductLikeUsersUsername] = self.username;
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
	if(self.avatar != nil){
		[aCoder encodeObject:self.avatar forKey:kTHNGoodsModelProductLikeUsersAvatar];
	}
	if(self.uid != nil){
		[aCoder encodeObject:self.uid forKey:kTHNGoodsModelProductLikeUsersUid];
	}
	if(self.username != nil){
		[aCoder encodeObject:self.username forKey:kTHNGoodsModelProductLikeUsersUsername];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.avatar = [aDecoder decodeObjectForKey:kTHNGoodsModelProductLikeUsersAvatar];
	self.uid = [aDecoder decodeObjectForKey:kTHNGoodsModelProductLikeUsersUid];
	self.username = [aDecoder decodeObjectForKey:kTHNGoodsModelProductLikeUsersUsername];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	THNGoodsModelProductLikeUsers *copy = [THNGoodsModelProductLikeUsers new];

	copy.avatar = [self.avatar copy];
	copy.uid = [self.uid copy];
	copy.username = [self.username copy];

	return copy;
}
@end