//
//	THNGoodsModelDealContent.m
//  on 1/9/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNGoodsModelDealContent.h"

NSString *const kTHNGoodsModelDealContentContent = @"content";
NSString *const kTHNGoodsModelDealContentRid = @"rid";
NSString *const kTHNGoodsModelDealContentType = @"type";

@interface THNGoodsModelDealContent ()
@end
@implementation THNGoodsModelDealContent




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNGoodsModelDealContentContent] isKindOfClass:[NSNull class]]){
		self.content = dictionary[kTHNGoodsModelDealContentContent];
	}	
	if(![dictionary[kTHNGoodsModelDealContentRid] isKindOfClass:[NSNull class]]){
		self.rid = dictionary[kTHNGoodsModelDealContentRid];
	}	
	if(![dictionary[kTHNGoodsModelDealContentType] isKindOfClass:[NSNull class]]){
		self.type = dictionary[kTHNGoodsModelDealContentType];
	}	
	return self;
}
@end
