//
//	THNGoodsModelLabel.m
//  on 31/8/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNGoodsModelLabel.h"

NSString *const kTHNGoodsModelLabelIdField = @"id";
NSString *const kTHNGoodsModelLabelName = @"name";
NSString *const kTHNGoodsModelLabelSortOrder = @"sort_order";

@interface THNGoodsModelLabel ()
@end
@implementation THNGoodsModelLabel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNGoodsModelLabelIdField] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[kTHNGoodsModelLabelIdField] integerValue];
	}

	if(![dictionary[kTHNGoodsModelLabelName] isKindOfClass:[NSNull class]]){
		self.name = dictionary[kTHNGoodsModelLabelName];
	}	
	if(![dictionary[kTHNGoodsModelLabelSortOrder] isKindOfClass:[NSNull class]]){
		self.sortOrder = [dictionary[kTHNGoodsModelLabelSortOrder] integerValue];
	}

	return self;
}
@end
