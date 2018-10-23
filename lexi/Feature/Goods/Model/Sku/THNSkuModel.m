//
//	THNSkuModel.m
//  on 31/8/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNSkuModel.h"

NSString *const kTHNSkuModelColors = @"colors";
NSString *const kTHNSkuModelItems = @"items";
NSString *const kTHNSkuModelModes = @"modes";

@interface THNSkuModel ()
@end
@implementation THNSkuModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(dictionary[kTHNSkuModelColors] != nil && [dictionary[kTHNSkuModelColors] isKindOfClass:[NSArray class]]){
		NSArray * colorsDictionaries = dictionary[kTHNSkuModelColors];
		NSMutableArray * colorsItems = [NSMutableArray array];
		for(NSDictionary * colorsDictionary in colorsDictionaries){
			THNSkuModelColor * colorsItem = [[THNSkuModelColor alloc] initWithDictionary:colorsDictionary];
			[colorsItems addObject:colorsItem];
		}
		self.colors = colorsItems;
	}
	if(dictionary[kTHNSkuModelItems] != nil && [dictionary[kTHNSkuModelItems] isKindOfClass:[NSArray class]]){
		NSArray * itemsDictionaries = dictionary[kTHNSkuModelItems];
		NSMutableArray * itemsItems = [NSMutableArray array];
		for(NSDictionary * itemsDictionary in itemsDictionaries){
			THNSkuModelItem * itemsItem = [[THNSkuModelItem alloc] initWithDictionary:itemsDictionary];
			[itemsItems addObject:itemsItem];
		}
		self.items = itemsItems;
	}
	if(dictionary[kTHNSkuModelModes] != nil && [dictionary[kTHNSkuModelModes] isKindOfClass:[NSArray class]]){
		NSArray * modesDictionaries = dictionary[kTHNSkuModelModes];
		NSMutableArray * modesItems = [NSMutableArray array];
		for(NSDictionary * modesDictionary in modesDictionaries){
			THNSkuModelColor * modesItem = [[THNSkuModelColor alloc] initWithDictionary:modesDictionary];
			[modesItems addObject:modesItem];
		}
		self.modes = modesItems;
	}
	return self;
}
@end
