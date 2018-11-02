#import <UIKit/UIKit.h>

@interface THNCouponSharedModelProductSku : NSObject

@property (nonatomic, assign) NSInteger productAmount;
@property (nonatomic, assign) NSInteger productCouponAmount;
@property (nonatomic, strong) NSString * productCover;
@property (nonatomic, strong) NSString * productName;
@property (nonatomic, strong) NSString * productRid;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end