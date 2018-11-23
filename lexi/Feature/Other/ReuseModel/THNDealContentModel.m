//
//	THNDealContentModel.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNDealContentModel.h"

NSString *const kTHNGoodsModelDealContentContent = @"content";
NSString *const kTHNGoodsModelDealContentHeight = @"height";
NSString *const kTHNGoodsModelDealContentRid = @"rid";
NSString *const kTHNGoodsModelDealContentType = @"type";
NSString *const kTHNGoodsModelDealContentWidth = @"width";

@interface THNDealContentModel ()
@end
@implementation THNDealContentModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNGoodsModelDealContentContent] isKindOfClass:[NSNull class]]){
		self.content = dictionary[kTHNGoodsModelDealContentContent];
	}	
	if(![dictionary[kTHNGoodsModelDealContentHeight] isKindOfClass:[NSNull class]]){
		self.height = [dictionary[kTHNGoodsModelDealContentHeight] integerValue];
	}

	if(![dictionary[kTHNGoodsModelDealContentRid] isKindOfClass:[NSNull class]]){
		self.rid = dictionary[kTHNGoodsModelDealContentRid];
	}	
	if(![dictionary[kTHNGoodsModelDealContentType] isKindOfClass:[NSNull class]]){
		self.type = dictionary[kTHNGoodsModelDealContentType];
	}	
	if(![dictionary[kTHNGoodsModelDealContentWidth] isKindOfClass:[NSNull class]]){
		self.width = [dictionary[kTHNGoodsModelDealContentWidth] integerValue];
	}

	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.content != nil){
		dictionary[kTHNGoodsModelDealContentContent] = self.content;
	}
	dictionary[kTHNGoodsModelDealContentHeight] = @(self.height);
	if(self.rid != nil){
		dictionary[kTHNGoodsModelDealContentRid] = self.rid;
	}
	if(self.type != nil){
		dictionary[kTHNGoodsModelDealContentType] = self.type;
	}
	dictionary[kTHNGoodsModelDealContentWidth] = @(self.width);
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
	if(self.content != nil){
		[aCoder encodeObject:self.content forKey:kTHNGoodsModelDealContentContent];
	}
	[aCoder encodeObject:@(self.height) forKey:kTHNGoodsModelDealContentHeight];	if(self.rid != nil){
		[aCoder encodeObject:self.rid forKey:kTHNGoodsModelDealContentRid];
	}
	if(self.type != nil){
		[aCoder encodeObject:self.type forKey:kTHNGoodsModelDealContentType];
	}
	[aCoder encodeObject:@(self.width) forKey:kTHNGoodsModelDealContentWidth];
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.content = [aDecoder decodeObjectForKey:kTHNGoodsModelDealContentContent];
	self.height = [[aDecoder decodeObjectForKey:kTHNGoodsModelDealContentHeight] integerValue];
	self.rid = [aDecoder decodeObjectForKey:kTHNGoodsModelDealContentRid];
	self.type = [aDecoder decodeObjectForKey:kTHNGoodsModelDealContentType];
	self.width = [[aDecoder decodeObjectForKey:kTHNGoodsModelDealContentWidth] integerValue];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	THNDealContentModel *copy = [THNDealContentModel new];

	copy.content = [self.content copy];
	copy.height = self.height;
	copy.rid = [self.rid copy];
	copy.type = [self.type copy];
	copy.width = self.width;

	return copy;
}
@end
