//
//	THNGoodsModelAssets.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNGoodsModelAssets.h"

NSString *const kTHNGoodsModelAssetsCreatedAt = @"created_at";
NSString *const kTHNGoodsModelAssetsFilename = @"filename";
NSString *const kTHNGoodsModelAssetsFilepath = @"filepath";
NSString *const kTHNGoodsModelAssetsIdField = @"id";
NSString *const kTHNGoodsModelAssetsType = @"type";
NSString *const kTHNGoodsModelAssetsViewUrl = @"view_url";

@interface THNGoodsModelAssets ()
@end
@implementation THNGoodsModelAssets




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNGoodsModelAssetsCreatedAt] isKindOfClass:[NSNull class]]){
		self.createdAt = [dictionary[kTHNGoodsModelAssetsCreatedAt] integerValue];
	}

	if(![dictionary[kTHNGoodsModelAssetsFilename] isKindOfClass:[NSNull class]]){
		self.filename = dictionary[kTHNGoodsModelAssetsFilename];
	}	
	if(![dictionary[kTHNGoodsModelAssetsFilepath] isKindOfClass:[NSNull class]]){
		self.filepath = dictionary[kTHNGoodsModelAssetsFilepath];
	}	
	if(![dictionary[kTHNGoodsModelAssetsIdField] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[kTHNGoodsModelAssetsIdField] integerValue];
	}

	if(![dictionary[kTHNGoodsModelAssetsType] isKindOfClass:[NSNull class]]){
		self.type = [dictionary[kTHNGoodsModelAssetsType] integerValue];
	}

	if(![dictionary[kTHNGoodsModelAssetsViewUrl] isKindOfClass:[NSNull class]]){
		self.viewUrl = dictionary[kTHNGoodsModelAssetsViewUrl];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	dictionary[kTHNGoodsModelAssetsCreatedAt] = @(self.createdAt);
	if(self.filename != nil){
		dictionary[kTHNGoodsModelAssetsFilename] = self.filename;
	}
	if(self.filepath != nil){
		dictionary[kTHNGoodsModelAssetsFilepath] = self.filepath;
	}
	dictionary[kTHNGoodsModelAssetsIdField] = @(self.idField);
	dictionary[kTHNGoodsModelAssetsType] = @(self.type);
	if(self.viewUrl != nil){
		dictionary[kTHNGoodsModelAssetsViewUrl] = self.viewUrl;
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
	[aCoder encodeObject:@(self.createdAt) forKey:kTHNGoodsModelAssetsCreatedAt];	if(self.filename != nil){
		[aCoder encodeObject:self.filename forKey:kTHNGoodsModelAssetsFilename];
	}
	if(self.filepath != nil){
		[aCoder encodeObject:self.filepath forKey:kTHNGoodsModelAssetsFilepath];
	}
	[aCoder encodeObject:@(self.idField) forKey:kTHNGoodsModelAssetsIdField];	[aCoder encodeObject:@(self.type) forKey:kTHNGoodsModelAssetsType];	if(self.viewUrl != nil){
		[aCoder encodeObject:self.viewUrl forKey:kTHNGoodsModelAssetsViewUrl];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.createdAt = [[aDecoder decodeObjectForKey:kTHNGoodsModelAssetsCreatedAt] integerValue];
	self.filename = [aDecoder decodeObjectForKey:kTHNGoodsModelAssetsFilename];
	self.filepath = [aDecoder decodeObjectForKey:kTHNGoodsModelAssetsFilepath];
	self.idField = [[aDecoder decodeObjectForKey:kTHNGoodsModelAssetsIdField] integerValue];
	self.type = [[aDecoder decodeObjectForKey:kTHNGoodsModelAssetsType] integerValue];
	self.viewUrl = [aDecoder decodeObjectForKey:kTHNGoodsModelAssetsViewUrl];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	THNGoodsModelAssets *copy = [THNGoodsModelAssets new];

	copy.createdAt = self.createdAt;
	copy.filename = [self.filename copy];
	copy.filepath = [self.filepath copy];
	copy.idField = self.idField;
	copy.type = self.type;
	copy.viewUrl = [self.viewUrl copy];

	return copy;
}
@end