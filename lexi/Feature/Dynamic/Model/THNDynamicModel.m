//
//	THNDynamicModel.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNDynamicModel.h"

NSString *const kTHNDynamicModelBgCover = @"bg_cover";
NSString *const kTHNDynamicModelCount = @"count";
NSString *const kTHNDynamicModelFollowedStatus = @"followed_status";
NSString *const kTHNDynamicModelLines = @"lines";
NSString *const kTHNDynamicModelNext = @"next";
NSString *const kTHNDynamicModelPrev = @"prev";
NSString *const kTHNDynamicModelUserAvatar = @"user_avatar";
NSString *const kTHNDynamicModelUsername = @"username";
NSString *const kTHNDynamicModelUid = @"uid";

@interface THNDynamicModel ()
@end
@implementation THNDynamicModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNDynamicModelBgCover] isKindOfClass:[NSNull class]]){
		self.bgCover = dictionary[kTHNDynamicModelBgCover];
	}	
	if(![dictionary[kTHNDynamicModelCount] isKindOfClass:[NSNull class]]){
		self.count = [dictionary[kTHNDynamicModelCount] integerValue];
	}

	if(![dictionary[kTHNDynamicModelFollowedStatus] isKindOfClass:[NSNull class]]){
		self.followedStatus = [dictionary[kTHNDynamicModelFollowedStatus] integerValue];
	}

	if(dictionary[kTHNDynamicModelLines] != nil && [dictionary[kTHNDynamicModelLines] isKindOfClass:[NSArray class]]){
		NSArray * linesDictionaries = dictionary[kTHNDynamicModelLines];
		NSMutableArray * linesItems = [NSMutableArray array];
		for(NSDictionary * linesDictionary in linesDictionaries){
			THNDynamicModelLines * linesItem = [[THNDynamicModelLines alloc] initWithDictionary:linesDictionary];
			[linesItems addObject:linesItem];
		}
		self.lines = linesItems;
	}
	if(![dictionary[kTHNDynamicModelNext] isKindOfClass:[NSNull class]]){
		self.next = [dictionary[kTHNDynamicModelNext] boolValue];
	}

	if(![dictionary[kTHNDynamicModelPrev] isKindOfClass:[NSNull class]]){
		self.prev = [dictionary[kTHNDynamicModelPrev] boolValue];
	}

	if(![dictionary[kTHNDynamicModelUserAvatar] isKindOfClass:[NSNull class]]){
		self.userAvatar = dictionary[kTHNDynamicModelUserAvatar];
	}	
    if(![dictionary[kTHNDynamicModelUsername] isKindOfClass:[NSNull class]]){
        self.username = dictionary[kTHNDynamicModelUsername];
    }
    if(![dictionary[kTHNDynamicModelUid] isKindOfClass:[NSNull class]]){
        self.uid = dictionary[kTHNDynamicModelUid];
    }
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.bgCover != nil){
		dictionary[kTHNDynamicModelBgCover] = self.bgCover;
	}
	dictionary[kTHNDynamicModelCount] = @(self.count);
	dictionary[kTHNDynamicModelFollowedStatus] = @(self.followedStatus);
	if(self.lines != nil){
		NSMutableArray * dictionaryElements = [NSMutableArray array];
		for(THNDynamicModelLines * linesElement in self.lines){
			[dictionaryElements addObject:[linesElement toDictionary]];
		}
		dictionary[kTHNDynamicModelLines] = dictionaryElements;
	}
	dictionary[kTHNDynamicModelNext] = @(self.next);
	dictionary[kTHNDynamicModelPrev] = @(self.prev);
	if(self.userAvatar != nil){
		dictionary[kTHNDynamicModelUserAvatar] = self.userAvatar;
	}
    if(self.username != nil){
        dictionary[kTHNDynamicModelUsername] = self.username;
    }
    if(self.uid != nil){
        dictionary[kTHNDynamicModelUid] = self.uid;
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
	if(self.bgCover != nil){
		[aCoder encodeObject:self.bgCover forKey:kTHNDynamicModelBgCover];
	}
	[aCoder encodeObject:@(self.count) forKey:kTHNDynamicModelCount];	[aCoder encodeObject:@(self.followedStatus) forKey:kTHNDynamicModelFollowedStatus];	if(self.lines != nil){
		[aCoder encodeObject:self.lines forKey:kTHNDynamicModelLines];
	}
	[aCoder encodeObject:@(self.next) forKey:kTHNDynamicModelNext];	[aCoder encodeObject:@(self.prev) forKey:kTHNDynamicModelPrev];	if(self.userAvatar != nil){
		[aCoder encodeObject:self.userAvatar forKey:kTHNDynamicModelUserAvatar];
	}
    if(self.username != nil){
        [aCoder encodeObject:self.username forKey:kTHNDynamicModelUsername];
    }
    if(self.uid != nil){
        [aCoder encodeObject:self.uid forKey:kTHNDynamicModelUid];
    }

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.bgCover = [aDecoder decodeObjectForKey:kTHNDynamicModelBgCover];
	self.count = [[aDecoder decodeObjectForKey:kTHNDynamicModelCount] integerValue];
	self.followedStatus = [[aDecoder decodeObjectForKey:kTHNDynamicModelFollowedStatus] integerValue];
	self.lines = [aDecoder decodeObjectForKey:kTHNDynamicModelLines];
	self.next = [[aDecoder decodeObjectForKey:kTHNDynamicModelNext] boolValue];
	self.prev = [[aDecoder decodeObjectForKey:kTHNDynamicModelPrev] boolValue];
	self.userAvatar = [aDecoder decodeObjectForKey:kTHNDynamicModelUserAvatar];
	self.username = [aDecoder decodeObjectForKey:kTHNDynamicModelUsername];
    self.uid = [aDecoder decodeObjectForKey:kTHNDynamicModelUid];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	THNDynamicModel *copy = [THNDynamicModel new];

	copy.bgCover = [self.bgCover copy];
	copy.count = self.count;
	copy.followedStatus = self.followedStatus;
	copy.lines = [self.lines copy];
	copy.next = self.next;
	copy.prev = self.prev;
	copy.userAvatar = [self.userAvatar copy];
	copy.username = [self.username copy];
    self.uid = [self.uid copy];

	return copy;
}
@end
