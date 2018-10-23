//
//	THNSkuModel.h
//  on 31/8/2018
//	Copyright © 2018. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "THNSkuModelColor.h"
#import "THNSkuModelItem.h"
#import "THNSkuModelColor.h"

@interface THNSkuModel : NSObject

@property (nonatomic, strong) NSArray * colors;
@property (nonatomic, strong) NSArray * items;
@property (nonatomic, strong) NSArray * modes;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
