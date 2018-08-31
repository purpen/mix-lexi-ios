//
//	THNGoodsModelAsset.m
//  on 31/8/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNGoodsModelAsset.h"

NSString *const kTHNGoodsModelAssetCreatedAt = @"created_at";
NSString *const kTHNGoodsModelAssetFilename = @"filename";
NSString *const kTHNGoodsModelAssetFilepath = @"filepath";
NSString *const kTHNGoodsModelAssetIdField = @"id";
NSString *const kTHNGoodsModelAssetType = @"type";
NSString *const kTHNGoodsModelAssetViewUrl = @"view_url";

@interface THNGoodsModelAsset ()
@end
@implementation THNGoodsModelAsset




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNGoodsModelAssetCreatedAt] isKindOfClass:[NSNull class]]){
		self.createdAt = [dictionary[kTHNGoodsModelAssetCreatedAt] integerValue];
	}

	if(![dictionary[kTHNGoodsModelAssetFilename] isKindOfClass:[NSNull class]]){
		self.filename = dictionary[kTHNGoodsModelAssetFilename];
	}	
	if(![dictionary[kTHNGoodsModelAssetFilepath] isKindOfClass:[NSNull class]]){
		self.filepath = dictionary[kTHNGoodsModelAssetFilepath];
	}	
	if(![dictionary[kTHNGoodsModelAssetIdField] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[kTHNGoodsModelAssetIdField] integerValue];
	}

	if(![dictionary[kTHNGoodsModelAssetType] isKindOfClass:[NSNull class]]){
		self.type = [dictionary[kTHNGoodsModelAssetType] integerValue];
	}

	if(![dictionary[kTHNGoodsModelAssetViewUrl] isKindOfClass:[NSNull class]]){
		self.viewUrl = dictionary[kTHNGoodsModelAssetViewUrl];
	}	
	return self;
}
@end
