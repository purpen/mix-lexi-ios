//
//	THNDynamicModelLines.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNDynamicModelLines.h"

NSString *const kTHNDynamicModelLinesCommentCount = @"comment_count";
NSString *const kTHNDynamicModelLinesDescriptionField = @"description";
NSString *const kTHNDynamicModelLinesIsExpert = @"is_expert";
NSString *const kTHNDynamicModelLinesIsFollow = @"is_follow";
NSString *const kTHNDynamicModelLinesIsLike = @"is_like";
NSString *const kTHNDynamicModelLinesIsOfficial = @"is_official";
NSString *const kTHNDynamicModelLinesKeywords = @"keywords";
NSString *const kTHNDynamicModelLinesLikeCount = @"like_count";
NSString *const kTHNDynamicModelLinesProductCount = @"product_count";
NSString *const kTHNDynamicModelLinesProductCovers = @"product_covers";
NSString *const kTHNDynamicModelLinesProducts = @"products";
NSString *const kTHNDynamicModelLinesRid = @"rid";
NSString *const kTHNDynamicModelLinesTitle = @"title";
NSString *const kTHNDynamicModelLinesUid = @"uid";
NSString *const kTHNDynamicModelLinesUpdatedAt = @"updated_at";
NSString *const kTHNDynamicModelLinesCreatedAt = @"created_at";
NSString *const kTHNDynamicModelLinesUserAvatar = @"user_avatar";
NSString *const kTHNDynamicModelLinesUserName = @"user_name";

@interface THNDynamicModelLines ()
@end
@implementation THNDynamicModelLines




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNDynamicModelLinesCommentCount] isKindOfClass:[NSNull class]]){
		self.commentCount = [dictionary[kTHNDynamicModelLinesCommentCount] integerValue];
	}

	if(![dictionary[kTHNDynamicModelLinesDescriptionField] isKindOfClass:[NSNull class]]){
		self.descriptionField = dictionary[kTHNDynamicModelLinesDescriptionField];
	}	
	if(![dictionary[kTHNDynamicModelLinesIsExpert] isKindOfClass:[NSNull class]]){
		self.isExpert = [dictionary[kTHNDynamicModelLinesIsExpert] boolValue];
	}

	if(![dictionary[kTHNDynamicModelLinesIsFollow] isKindOfClass:[NSNull class]]){
		self.isFollow = [dictionary[kTHNDynamicModelLinesIsFollow] boolValue];
	}

	if(![dictionary[kTHNDynamicModelLinesIsLike] isKindOfClass:[NSNull class]]){
		self.isLike = [dictionary[kTHNDynamicModelLinesIsLike] boolValue];
	}

	if(![dictionary[kTHNDynamicModelLinesIsOfficial] isKindOfClass:[NSNull class]]){
		self.isOfficial = [dictionary[kTHNDynamicModelLinesIsOfficial] boolValue];
	}

	if(![dictionary[kTHNDynamicModelLinesKeywords] isKindOfClass:[NSNull class]]){
		self.keywords = dictionary[kTHNDynamicModelLinesKeywords];
	}	
	if(![dictionary[kTHNDynamicModelLinesLikeCount] isKindOfClass:[NSNull class]]){
		self.likeCount = [dictionary[kTHNDynamicModelLinesLikeCount] integerValue];
	}

	if(![dictionary[kTHNDynamicModelLinesProductCount] isKindOfClass:[NSNull class]]){
		self.productCount = [dictionary[kTHNDynamicModelLinesProductCount] integerValue];
	}

	if(![dictionary[kTHNDynamicModelLinesProductCovers] isKindOfClass:[NSNull class]]){
		self.productCovers = dictionary[kTHNDynamicModelLinesProductCovers];
	}	
	if(dictionary[kTHNDynamicModelLinesProducts] != nil && [dictionary[kTHNDynamicModelLinesProducts] isKindOfClass:[NSArray class]]){
		NSArray * productsDictionaries = dictionary[kTHNDynamicModelLinesProducts];
		NSMutableArray * productsItems = [NSMutableArray array];
		for(NSDictionary * productsDictionary in productsDictionaries){
			THNDynamicModelProducts * productsItem = [[THNDynamicModelProducts alloc] initWithDictionary:productsDictionary];
			[productsItems addObject:productsItem];
		}
		self.products = productsItems;
	}
	if(![dictionary[kTHNDynamicModelLinesRid] isKindOfClass:[NSNull class]]){
		self.rid = [dictionary[kTHNDynamicModelLinesRid] integerValue];
	}

	if(![dictionary[kTHNDynamicModelLinesTitle] isKindOfClass:[NSNull class]]){
		self.title = dictionary[kTHNDynamicModelLinesTitle];
	}	
	if(![dictionary[kTHNDynamicModelLinesUid] isKindOfClass:[NSNull class]]){
		self.uid = dictionary[kTHNDynamicModelLinesUid];
	}	
    if(![dictionary[kTHNDynamicModelLinesUpdatedAt] isKindOfClass:[NSNull class]]){
        self.updatedAt = [dictionary[kTHNDynamicModelLinesUpdatedAt] integerValue];
    }
    if(![dictionary[kTHNDynamicModelLinesCreatedAt] isKindOfClass:[NSNull class]]){
        self.createdAt = [dictionary[kTHNDynamicModelLinesCreatedAt] integerValue];
    }

	if(![dictionary[kTHNDynamicModelLinesUserAvatar] isKindOfClass:[NSNull class]]){
		self.userAvatar = dictionary[kTHNDynamicModelLinesUserAvatar];
	}	
	if(![dictionary[kTHNDynamicModelLinesUserName] isKindOfClass:[NSNull class]]){
		self.userName = dictionary[kTHNDynamicModelLinesUserName];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	dictionary[kTHNDynamicModelLinesCommentCount] = @(self.commentCount);
	if(self.descriptionField != nil){
		dictionary[kTHNDynamicModelLinesDescriptionField] = self.descriptionField;
	}
	dictionary[kTHNDynamicModelLinesIsExpert] = @(self.isExpert);
	dictionary[kTHNDynamicModelLinesIsFollow] = @(self.isFollow);
	dictionary[kTHNDynamicModelLinesIsLike] = @(self.isLike);
	dictionary[kTHNDynamicModelLinesIsOfficial] = @(self.isOfficial);
	if(self.keywords != nil){
		dictionary[kTHNDynamicModelLinesKeywords] = self.keywords;
	}
	dictionary[kTHNDynamicModelLinesLikeCount] = @(self.likeCount);
	dictionary[kTHNDynamicModelLinesProductCount] = @(self.productCount);
	if(self.productCovers != nil){
		dictionary[kTHNDynamicModelLinesProductCovers] = self.productCovers;
	}
	if(self.products != nil){
		NSMutableArray * dictionaryElements = [NSMutableArray array];
		for(THNDynamicModelProducts * productsElement in self.products){
			[dictionaryElements addObject:[productsElement toDictionary]];
		}
		dictionary[kTHNDynamicModelLinesProducts] = dictionaryElements;
	}
	dictionary[kTHNDynamicModelLinesRid] = @(self.rid);
	if(self.title != nil){
		dictionary[kTHNDynamicModelLinesTitle] = self.title;
	}
	if(self.uid != nil){
		dictionary[kTHNDynamicModelLinesUid] = self.uid;
	}
	dictionary[kTHNDynamicModelLinesUpdatedAt] = @(self.updatedAt);
    dictionary[kTHNDynamicModelLinesCreatedAt] = @(self.createdAt);
	if(self.userAvatar != nil){
		dictionary[kTHNDynamicModelLinesUserAvatar] = self.userAvatar;
	}
	if(self.userName != nil){
		dictionary[kTHNDynamicModelLinesUserName] = self.userName;
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
	[aCoder encodeObject:@(self.commentCount) forKey:kTHNDynamicModelLinesCommentCount];	if(self.descriptionField != nil){
		[aCoder encodeObject:self.descriptionField forKey:kTHNDynamicModelLinesDescriptionField];
	}
	[aCoder encodeObject:@(self.isExpert) forKey:kTHNDynamicModelLinesIsExpert];	[aCoder encodeObject:@(self.isFollow) forKey:kTHNDynamicModelLinesIsFollow];	[aCoder encodeObject:@(self.isLike) forKey:kTHNDynamicModelLinesIsLike];	[aCoder encodeObject:@(self.isOfficial) forKey:kTHNDynamicModelLinesIsOfficial];	if(self.keywords != nil){
		[aCoder encodeObject:self.keywords forKey:kTHNDynamicModelLinesKeywords];
	}
	[aCoder encodeObject:@(self.likeCount) forKey:kTHNDynamicModelLinesLikeCount];	[aCoder encodeObject:@(self.productCount) forKey:kTHNDynamicModelLinesProductCount];	if(self.productCovers != nil){
		[aCoder encodeObject:self.productCovers forKey:kTHNDynamicModelLinesProductCovers];
	}
	if(self.products != nil){
		[aCoder encodeObject:self.products forKey:kTHNDynamicModelLinesProducts];
	}
	[aCoder encodeObject:@(self.rid) forKey:kTHNDynamicModelLinesRid];	if(self.title != nil){
		[aCoder encodeObject:self.title forKey:kTHNDynamicModelLinesTitle];
	}
	if(self.uid != nil){
		[aCoder encodeObject:self.uid forKey:kTHNDynamicModelLinesUid];
	}
	[aCoder encodeObject:@(self.updatedAt) forKey:kTHNDynamicModelLinesUpdatedAt];
    [aCoder encodeObject:@(self.createdAt) forKey:kTHNDynamicModelLinesCreatedAt];
    if(self.userAvatar != nil){
		[aCoder encodeObject:self.userAvatar forKey:kTHNDynamicModelLinesUserAvatar];
	}
	if(self.userName != nil){
		[aCoder encodeObject:self.userName forKey:kTHNDynamicModelLinesUserName];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.commentCount = [[aDecoder decodeObjectForKey:kTHNDynamicModelLinesCommentCount] integerValue];
	self.descriptionField = [aDecoder decodeObjectForKey:kTHNDynamicModelLinesDescriptionField];
	self.isExpert = [[aDecoder decodeObjectForKey:kTHNDynamicModelLinesIsExpert] boolValue];
	self.isFollow = [[aDecoder decodeObjectForKey:kTHNDynamicModelLinesIsFollow] boolValue];
	self.isLike = [[aDecoder decodeObjectForKey:kTHNDynamicModelLinesIsLike] boolValue];
	self.isOfficial = [[aDecoder decodeObjectForKey:kTHNDynamicModelLinesIsOfficial] boolValue];
	self.keywords = [aDecoder decodeObjectForKey:kTHNDynamicModelLinesKeywords];
	self.likeCount = [[aDecoder decodeObjectForKey:kTHNDynamicModelLinesLikeCount] integerValue];
	self.productCount = [[aDecoder decodeObjectForKey:kTHNDynamicModelLinesProductCount] integerValue];
	self.productCovers = [aDecoder decodeObjectForKey:kTHNDynamicModelLinesProductCovers];
	self.products = [aDecoder decodeObjectForKey:kTHNDynamicModelLinesProducts];
	self.rid = [[aDecoder decodeObjectForKey:kTHNDynamicModelLinesRid] integerValue];
	self.title = [aDecoder decodeObjectForKey:kTHNDynamicModelLinesTitle];
	self.uid = [aDecoder decodeObjectForKey:kTHNDynamicModelLinesUid];
	self.updatedAt = [[aDecoder decodeObjectForKey:kTHNDynamicModelLinesUpdatedAt] integerValue];
    self.createdAt = [[aDecoder decodeObjectForKey:kTHNDynamicModelLinesCreatedAt] integerValue];
	self.userAvatar = [aDecoder decodeObjectForKey:kTHNDynamicModelLinesUserAvatar];
	self.userName = [aDecoder decodeObjectForKey:kTHNDynamicModelLinesUserName];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	THNDynamicModelLines *copy = [THNDynamicModelLines new];

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
    copy.createdAt = self.createdAt;
	copy.userAvatar = [self.userAvatar copy];
	copy.userName = [self.userName copy];

	return copy;
}
@end
