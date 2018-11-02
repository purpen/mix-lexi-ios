#import <UIKit/UIKit.h>

@interface THNCouponOfficialModel : NSObject

@property (nonatomic, assign) CGFloat amount;
@property (nonatomic, strong) NSString * code;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger createdAt;
@property (nonatomic, assign) NSInteger endDate;
@property (nonatomic, assign) BOOL isGrant;
@property (nonatomic, assign) CGFloat minAmount;
@property (nonatomic, assign) NSInteger pickupCount;
@property (nonatomic, assign) NSInteger startDate;
@property (nonatomic, assign) NSInteger surplusCount;
@property (nonatomic, strong) NSString * typeText;
@property (nonatomic, assign) NSInteger useCount;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
