//
//	THNFreightModel.h
//  on 3/9/2018
//	Copyright © 2018. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "THNFreightModelItem.h"

@interface THNFreightModel : NSObject

@property (nonatomic, strong) NSArray * items;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) NSInteger pricingMethod;
@property (nonatomic, strong) NSString * rid;
@property (nonatomic, assign) NSInteger updateAt;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
