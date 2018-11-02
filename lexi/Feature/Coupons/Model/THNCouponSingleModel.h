#import <UIKit/UIKit.h>

@interface THNCouponSingleModel : NSObject

@property (nonatomic, assign) NSInteger amount;
@property (nonatomic, strong) NSString * couponCode;
@property (nonatomic, assign) BOOL isGrant;
@property (nonatomic, assign) BOOL isRecommend;
@property (nonatomic, assign) NSInteger minAmount;
@property (nonatomic, assign) NSInteger productAmount;
@property (nonatomic, assign) NSInteger productCouponAmount;
@property (nonatomic, strong) NSString * productCover;
@property (nonatomic, strong) NSString * productName;
@property (nonatomic, strong) NSString * productRid;
@property (nonatomic, strong) NSString * storeRid;
@property (nonatomic, assign) NSInteger surplusCount;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end