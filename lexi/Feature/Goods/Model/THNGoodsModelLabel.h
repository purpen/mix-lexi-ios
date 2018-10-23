//
//	THNGoodsModelLabel.h
//  on 1/9/2018
//	Copyright © 2018. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface THNGoodsModelLabel : NSObject

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) NSInteger sortOrder;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
