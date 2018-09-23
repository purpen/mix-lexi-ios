//
//	THNFreightModelItem.h
//  on 3/9/2018
//	Copyright © 2018. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface THNFreightModelItem : NSObject

@property (nonatomic, assign) NSInteger continuousAmount;
@property (nonatomic, assign) NSInteger continuousItem;
@property (nonatomic, assign) NSInteger continuousWeight;
@property (nonatomic, strong) NSString * expressCode;
@property (nonatomic, assign) NSInteger expressId;
@property (nonatomic, strong) NSString * expressName;
@property (nonatomic, assign) CGFloat firstAmount;
@property (nonatomic, assign) NSInteger firstItem;
@property (nonatomic, assign) NSInteger firstWeight;
@property (nonatomic, assign) BOOL isDefault;
@property (nonatomic, assign) NSInteger maxDays;
@property (nonatomic, assign) NSInteger minDays;
@property (nonatomic, strong) NSArray * placeItems;
@property (nonatomic, strong) NSString * rid;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
