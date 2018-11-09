#import <UIKit/UIKit.h>
#import "THNCouponSharedModelProductSku.h"

@interface THNCouponSharedModel : NSObject

@property (nonatomic, assign) NSInteger amount;
@property (nonatomic, strong) NSString * couponCode;
@property (nonatomic, assign) BOOL isRecommend;
@property (nonatomic, assign) NSInteger minAmount;
@property (nonatomic, strong) NSArray * productSku;
@property (nonatomic, strong) NSString * storeBgcover;
@property (nonatomic, strong) NSString * storeLogo;
@property (nonatomic, strong) NSString * storeName;
@property (nonatomic, strong) NSString * storeRid;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end