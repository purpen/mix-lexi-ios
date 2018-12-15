#import <UIKit/UIKit.h>

@interface THNInviteRewardsModelRewards : NSObject

@property (nonatomic, assign) CGFloat amount;
@property (nonatomic, assign) NSInteger createdAt;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * userLogo;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * userSn;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end