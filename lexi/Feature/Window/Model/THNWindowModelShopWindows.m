//
//	THNWindowModelShopWindows.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNWindowModelShopWindows.h"

NSString *const kTHNWindowModelShopWindowsCommentCount = @"comment_count";
NSString *const kTHNWindowModelShopWindowsDescriptionField = @"description";
NSString *const kTHNWindowModelShopWindowsIsExpert = @"is_expert";
NSString *const kTHNWindowModelShopWindowsIsFollow = @"is_follow";
NSString *const kTHNWindowModelShopWindowsIsLike = @"is_like";
NSString *const kTHNWindowModelShopWindowsIsOfficial = @"is_official";
NSString *const kTHNWindowModelShopWindowsKeywords = @"keywords";
NSString *const kTHNWindowModelShopWindowsLikeCount = @"like_count";
NSString *const kTHNWindowModelShopWindowsProductCount = @"product_count";
NSString *const kTHNWindowModelShopWindowsProductCovers = @"product_covers";
NSString *const kTHNWindowModelShopWindowsProducts = @"products";
NSString *const kTHNWindowModelShopWindowsRid = @"rid";
NSString *const kTHNWindowModelShopWindowsTitle = @"title";
NSString *const kTHNWindowModelShopWindowsUid = @"uid";
NSString *const kTHNWindowModelShopWindowsUpdatedAt = @"updated_at";
NSString *const kTHNWindowModelShopWindowsUserAvatar = @"user_avatar";
NSString *const kTHNWindowModelShopWindowsUserName = @"user_name";

@interface THNWindowModelShopWindows ()
@end
@implementation THNWindowModelShopWindows




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNWindowModelShopWindowsCommentCount] isKindOfClass:[NSNull class]]){
		self.commentCount = [dictionary[kTHNWindowModelShopWindowsCommentCount] integerValue];
	}

	if(![dictionary[kTHNWindowModelShopWindowsDescriptionField] isKindOfClass:[NSNull class]]){
		self.descriptionField = dictionary[kTHNWindowModelShopWindowsDescriptionField];
	}	
	if(![dictionary[kTHNWindowModelShopWindowsIsExpert] isKindOfClass:[NSNull class]]){
		self.isExpert = [dictionary[kTHNWindowModelShopWindowsIsExpert] boolValue];
	}

	if(![dictionary[kTHNWindowModelShopWindowsIsFollow] isKindOfClass:[NSNull class]]){
		self.isFollow = [dictionary[kTHNWindowModelShopWindowsIsFollow] boolValue];
	}

	if(![dictionary[kTHNWindowModelShopWindowsIsLike] isKindOfClass:[NSNull class]]){
		self.isLike = [dictionary[kTHNWindowModelShopWindowsIsLike] boolValue];
	}

	if(![dictionary[kTHNWindowModelShopWindowsIsOfficial] isKindOfClass:[NSNull class]]){
		self.isOfficial = [dictionary[kTHNWindowModelShopWindowsIsOfficial] boolValue];
	}

	if(![dictionary[kTHNWindowModelShopWindowsKeywords] isKindOfClass:[NSNull class]]){
		self.keywords = dictionary[kTHNWindowModelShopWindowsKeywords];
	}	
	if(![dictionary[kTHNWindowModelShopWindowsLikeCount] isKindOfClass:[NSNull class]]){
		self.likeCount = [dictionary[kTHNWindowModelShopWindowsLikeCount] integerValue];
	}

	if(![dictionary[kTHNWindowModelShopWindowsProductCount] isKindOfClass:[NSNull class]]){
		self.productCount = [dictionary[kTHNWindowModelShopWindowsProductCount] integerValue];
	}

	if(![dictionary[kTHNWindowModelShopWindowsProductCovers] isKindOfClass:[NSNull class]]){
		self.productCovers = dictionary[kTHNWindowModelShopWindowsProductCovers];
	}	
	if(dictionary[kTHNWindowModelShopWindowsProducts] != nil && [dictionary[kTHNWindowModelShopWindowsProducts] isKindOfClass:[NSArray class]]){
		NSArray * productsDictionaries = dictionary[kTHNWindowModelShopWindowsProducts];
		NSMutableArray * productsItems = [NSMutableArray array];
		for(NSDictionary * productsDictionary in productsDictionaries){
			THNWindowModelProducts * productsItem = [[THNWindowModelProducts alloc] initWithDictionary:productsDictionary];
			[productsItems addObject:productsItem];
		}
		self.products = productsItems;
	}
	if(![dictionary[kTHNWindowModelShopWindowsRid] isKindOfClass:[NSNull class]]){
		self.rid = [dictionary[kTHNWindowModelShopWindowsRid] integerValue];
	}

	if(![dictionary[kTHNWindowModelShopWindowsTitle] isKindOfClass:[NSNull class]]){
		self.title = dictionary[kTHNWindowModelShopWindowsTitle];
	}	
	if(![dictionary[kTHNWindowModelShopWindowsUid] isKindOfClass:[NSNull class]]){
		self.uid = dictionary[kTHNWindowModelShopWindowsUid];
	}	
	if(![dictionary[kTHNWindowModelShopWindowsUpdatedAt] isKindOfClass:[NSNull class]]){
		self.updatedAt = [dictionary[kTHNWindowModelShopWindowsUpdatedAt] integerValue];
	}

	if(![dictionary[kTHNWindowModelShopWindowsUserAvatar] isKindOfClass:[NSNull class]]){
		self.userAvatar = dictionary[kTHNWindowModelShopWindowsUserAvatar];
	}	
	if(![dictionary[kTHNWindowModelShopWindowsUserName] isKindOfClass:[NSNull class]]){
		self.userName = dictionary[kTHNWindowModelShopWindowsUserName];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	dictionary[kTHNWindowModelShopWindowsCommentCount] = @(self.commentCount);
	if(self.descriptionField != nil){
		dictionary[kTHNWindowModelShopWindowsDescriptionField] = self.descriptionField;
	}
	dictionary[kTHNWindowModelShopWindowsIsExpert] = @(self.isExpert);
	dictionary[kTHNWindowModelShopWindowsIsFollow] = @(self.isFollow);
	dictionary[kTHNWindowModelShopWindowsIsLike] = @(self.isLike);
	dictionary[kTHNWindowModelShopWindowsIsOfficial] = @(self.isOfficial);
	if(self.keywords != nil){
		dictionary[kTHNWindowModelShopWindowsKeywords] = self.keywords;
	}
	dictionary[kTHNWindowModelShopWindowsLikeCount] = @(self.likeCount);
	dictionary[kTHNWindowModelShopWindowsProductCount] = @(self.productCount);
	if(self.productCovers != nil){
		dictionary[kTHNWindowModelShopWindowsProductCovers] = self.productCovers;
	}
	if(self.products != nil){
		NSMutableArray * dictionaryElements = [NSMutableArray array];
		for(THNWindowModelProducts * productsElement in self.products){
			[dictionaryElements addObject:[productsElement toDictionary]];
		}
		dictionary[kTHNWindowModelShopWindowsProducts] = dictionaryElements;
	}
	dictionary[kTHNWindowModelShopWindowsRid] = @(self.rid);
	if(self.title != nil){
		dictionary[kTHNWindowModelShopWindowsTitle] = self.title;
	}
	if(self.uid != nil){
		dictionary[kTHNWindowModelShopWindowsUid] = self.uid;
	}
	dictionary[kTHNWindowModelShopWindowsUpdatedAt] = @(self.updatedAt);
	if(self.userAvatar != nil){
		dictionary[kTHNWindowModelShopWindowsUserAvatar] = self.userAvatar;
	}
	if(self.userName != nil){
		dictionary[kTHNWindowModelShopWindowsUserName] = self.userName;
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
	[aCoder encodeObject:@(self.commentCount) forKey:kTHNWindowModelShopWindowsCommentCount];	if(self.descriptionField != nil){
		[aCoder encodeObject:self.descriptionField forKey:kTHNWindowModelShopWindowsDescriptionField];
	}
	[aCoder encodeObject:@(self.isExpert) forKey:kTHNWindowModelShopWindowsIsExpert];	[aCoder encodeObject:@(self.isFollow) forKey:kTHNWindowModelShopWindowsIsFollow];	[aCoder encodeObject:@(self.isLike) forKey:kTHNWindowModelShopWindowsIsLike];	[aCoder encodeObject:@(self.isOfficial) forKey:kTHNWindowModelShopWindowsIsOfficial];	if(self.keywords != nil){
		[aCoder encodeObject:self.keywords forKey:kTHNWindowModelShopWindowsKeywords];
	}
	[aCoder encodeObject:@(self.likeCount) forKey:kTHNWindowModelShopWindowsLikeCount];	[aCoder encodeObject:@(self.productCount) forKey:kTHNWindowModelShopWindowsProductCount];	if(self.productCovers != nil){
		[aCoder encodeObject:self.productCovers forKey:kTHNWindowModelShopWindowsProductCovers];
	}
	if(self.products != nil){
		[aCoder encodeObject:self.products forKey:kTHNWindowModelShopWindowsProducts];
	}
	[aCoder encodeObject:@(self.rid) forKey:kTHNWindowModelShopWindowsRid];	if(self.title != nil){
		[aCoder encodeObject:self.title forKey:kTHNWindowModelShopWindowsTitle];
	}
	if(self.uid != nil){
		[aCoder encodeObject:self.uid forKey:kTHNWindowModelShopWindowsUid];
	}
	[aCoder encodeObject:@(self.updatedAt) forKey:kTHNWindowModelShopWindowsUpdatedAt];	if(self.userAvatar != nil){
		[aCoder encodeObject:self.userAvatar forKey:kTHNWindowModelShopWindowsUserAvatar];
	}
	if(self.userName != nil){
		[aCoder encodeObject:self.userName forKey:kTHNWindowModelShopWindowsUserName];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.commentCount = [[aDecoder decodeObjectForKey:kTHNWindowModelShopWindowsCommentCount] integerValue];
	self.descriptionField = [aDecoder decodeObjectForKey:kTHNWindowModelShopWindowsDescriptionField];
	self.isExpert = [[aDecoder decodeObjectForKey:kTHNWindowModelShopWindowsIsExpert] boolValue];
	self.isFollow = [[aDecoder decodeObjectForKey:kTHNWindowModelShopWindowsIsFollow] boolValue];
	self.isLike = [[aDecoder decodeObjectForKey:kTHNWindowModelShopWindowsIsLike] boolValue];
	self.isOfficial = [[aDecoder decodeObjectForKey:kTHNWindowModelShopWindowsIsOfficial] boolValue];
	self.keywords = [aDecoder decodeObjectForKey:kTHNWindowModelShopWindowsKeywords];
	self.likeCount = [[aDecoder decodeObjectForKey:kTHNWindowModelShopWindowsLikeCount] integerValue];
	self.productCount = [[aDecoder decodeObjectForKey:kTHNWindowModelShopWindowsProductCount] integerValue];
	self.productCovers = [aDecoder decodeObjectForKey:kTHNWindowModelShopWindowsProductCovers];
	self.products = [aDecoder decodeObjectForKey:kTHNWindowModelShopWindowsProducts];
	self.rid = [[aDecoder decodeObjectForKey:kTHNWindowModelShopWindowsRid] integerValue];
	self.title = [aDecoder decodeObjectForKey:kTHNWindowModelShopWindowsTitle];
	self.uid = [aDecoder decodeObjectForKey:kTHNWindowModelShopWindowsUid];
	self.updatedAt = [[aDecoder decodeObjectForKey:kTHNWindowModelShopWindowsUpdatedAt] integerValue];
	self.userAvatar = [aDecoder decodeObjectForKey:kTHNWindowModelShopWindowsUserAvatar];
	self.userName = [aDecoder decodeObjectForKey:kTHNWindowModelShopWindowsUserName];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	THNWindowModelShopWindows *copy = [THNWindowModelShopWindows new];

	copy.commentCount = self.commentCount;
	copy.descriptionField = [self.descriptionField copy];
	copy.isExpert = self.isExpert;
	copy.isFollow = self.isFollow;
	copy.isLike = self.isLike;
	copy.isOfficial = self.isOfficial;
	copy.keywords = [self.keywords copy];
	copy.likeCount = self.likeCount;
	copy.productCount = self.productCount;
	copy.productCovers = [self.productCovers copy];
	copy.products = [self.products copy];
	copy.rid = self.rid;
	copy.title = [self.title copy];
	copy.uid = [self.uid copy];
	copy.updatedAt = self.updatedAt;
	copy.userAvatar = [self.userAvatar copy];
	copy.userName = [self.userName copy];

	return copy;
}
@end
