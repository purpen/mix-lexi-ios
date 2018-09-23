//
//	THNGoodsModelAsset.h
//  on 1/9/2018
//	Copyright © 2018. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface THNGoodsModelAsset : NSObject

@property (nonatomic, assign) NSInteger createdAt;
@property (nonatomic, strong) NSString * filename;
@property (nonatomic, strong) NSString * filepath;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString * viewUrl;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
