//
//	THNCartModelItem.h
//  on 15/9/2018
//	Copyright © 2018. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "THNCartModelProduct.h"

@interface THNCartModelItem : NSObject

@property (nonatomic, strong) NSObject * option;
@property (nonatomic, strong) THNCartModelProduct * product;
@property (nonatomic, assign) NSInteger quantity;
@property (nonatomic, strong) NSString * rid;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
