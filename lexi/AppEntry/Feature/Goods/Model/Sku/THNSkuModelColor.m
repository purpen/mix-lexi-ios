//
//	THNSkuModelColor.m
//  on 31/8/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNSkuModelColor.h"

NSString *const kTHNSkuModelColorName = @"name";
NSString *const kTHNSkuModelColorValid = @"valid";

@interface THNSkuModelColor ()
@end
@implementation THNSkuModelColor




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNSkuModelColorName] isKindOfClass:[NSNull class]]){
		self.name = dictionary[kTHNSkuModelColorName];
	}	
	if(![dictionary[kTHNSkuModelColorValid] isKindOfClass:[NSNull class]]){
		self.valid = [dictionary[kTHNSkuModelColorValid] boolValue];
	}

	return self;
}
@end
