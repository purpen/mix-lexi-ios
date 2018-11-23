//
//	THNGoodsModelLabels.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNGoodsModelLabels.h"

NSString *const kTHNGoodsModelLabelsIdField = @"id";
NSString *const kTHNGoodsModelLabelsName = @"name";
NSString *const kTHNGoodsModelLabelsSortOrder = @"sort_order";

@interface THNGoodsModelLabels ()
@end
@implementation THNGoodsModelLabels




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNGoodsModelLabelsIdField] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[kTHNGoodsModelLabelsIdField] integerValue];
	}

	if(![dictionary[kTHNGoodsModelLabelsName] isKindOfClass:[NSNull class]]){
		self.name = dictionary[kTHNGoodsModelLabelsName];
	}	
	if(![dictionary[kTHNGoodsModelLabelsSortOrder] isKindOfClass:[NSNull class]]){
		self.sortOrder = [dictionary[kTHNGoodsModelLabelsSortOrder] integerValue];
	}

	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	dictionary[kTHNGoodsModelLabelsIdField] = @(self.idField);
	if(self.name != nil){
		dictionary[kTHNGoodsModelLabelsName] = self.name;
	}
	dictionary[kTHNGoodsModelLabelsSortOrder] = @(self.sortOrder);
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
	[aCoder encodeObject:@(self.idField) forKey:kTHNGoodsModelLabelsIdField];	if(self.name != nil){
		[aCoder encodeObject:self.name forKey:kTHNGoodsModelLabelsName];
	}
	[aCoder encodeObject:@(self.sortOrder) forKey:kTHNGoodsModelLabelsSortOrder];
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.idField = [[aDecoder decodeObjectForKey:kTHNGoodsModelLabelsIdField] integerValue];
	self.name = [aDecoder decodeObjectForKey:kTHNGoodsModelLabelsName];
	self.sortOrder = [[aDecoder decodeObjectForKey:kTHNGoodsModelLabelsSortOrder] integerValue];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	THNGoodsModelLabels *copy = [THNGoodsModelLabels new];

	copy.idField = self.idField;
	copy.name = [self.name copy];
	copy.sortOrder = self.sortOrder;

	return copy;
}
@end