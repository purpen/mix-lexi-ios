//
//	THNCartModel.h
//  on 15/9/2018
//	Copyright © 2018. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "THNCartModelItem.h"

@interface THNCartModel : NSObject

@property (nonatomic, assign) NSInteger itemCount;
@property (nonatomic, strong) NSArray * items;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
