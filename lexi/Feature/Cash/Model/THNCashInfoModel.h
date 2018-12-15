#import <UIKit/UIKit.h>

@interface THNCashInfoModel : NSObject

@property (nonatomic, assign) CGFloat actualAmount;
@property (nonatomic, assign) NSInteger arrivalTime;
@property (nonatomic, assign) NSInteger createdAt;
@property (nonatomic, assign) NSInteger receiveTarget;
@property (nonatomic, strong) NSString * rid;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * userAccount;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
