//
//	THNDynamicModelProducts.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNDynamicModelProducts.h"

NSString *const kTHNDynamicModelProductsCover = @"cover";
NSString *const kTHNDynamicModelProductsRid = @"rid";

@interface THNDynamicModelProducts ()
@end
@implementation THNDynamicModelProducts




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNDynamicModelProductsCover] isKindOfClass:[NSNull class]]){
		self.cover = dictionary[kTHNDynamicModelProductsCover];
	}	
	if(![dictionary[kTHNDynamicModelProductsRid] isKindOfClass:[NSNull class]]){
		self.rid = dictionary[kTHNDynamicModelProductsRid];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.cover != nil){
		dictionary[kTHNDynamicModelProductsCover] = self.cover;
	}
	if(self.rid != nil){
		dictionary[kTHNDynamicModelProductsRid] = self.rid;
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
	if(self.cover != nil){
		[aCoder encodeObject:self.cover forKey:kTHNDynamicModelProductsCover];
	}
	if(self.rid != nil){
		[aCoder encodeObject:self.rid forKey:kTHNDynamicModelProductsRid];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.cover = [aDecoder decodeObjectForKey:kTHNDynamicModelProductsCover];
	self.rid = [aDecoder decodeObjectForKey:kTHNDynamicModelProductsRid];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	THNDynamicModelProducts *copy = [THNDynamicModelProducts new];

	copy.cover = [self.cover copy];
	copy.rid = [self.rid copy];

	return copy;
}
@end