//
//	THNDealContentModel.h
//  on 1/9/2018
//	Copyright © 2018. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface THNDealContentModel : NSObject

@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * rid;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
