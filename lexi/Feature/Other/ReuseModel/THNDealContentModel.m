//
//	THNDealContentModel.m
//  on 1/9/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNDealContentModel.h"

NSString *const kTHNGoodsModelDealContentContent = @"content";
NSString *const kTHNGoodsModelDealContentRid = @"rid";
NSString *const kTHNGoodsModelDealContentType = @"type";
NSString *const kTHNGoodsModelDealContentWidth = @"width";
NSString *const kTHNGoodsModelDealContentHeght = @"height";

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
	if(![dictionary[kTHNGoodsModelDealContentRid] isKindOfClass:[NSNull class]]){
		self.rid = dictionary[kTHNGoodsModelDealContentRid];
	}	
    if(![dictionary[kTHNGoodsModelDealContentType] isKindOfClass:[NSNull class]]){
        self.type = dictionary[kTHNGoodsModelDealContentType];
    }
    if(![dictionary[kTHNGoodsModelDealContentWidth] isKindOfClass:[NSNull class]]){
        self.width = [dictionary[kTHNGoodsModelDealContentWidth] floatValue];
    }
    if(![dictionary[kTHNGoodsModelDealContentHeght] isKindOfClass:[NSNull class]]){
        self.height = [dictionary[kTHNGoodsModelDealContentHeght] floatValue];
    }
    
	return self;
}

@end
