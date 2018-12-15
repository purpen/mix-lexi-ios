#import <UIKit/UIKit.h>

@interface THNInviteCountModel : NSObject

@property (nonatomic, assign) NSInteger inviteCount;
@property (nonatomic, assign) NSInteger pendingPrice;
@property (nonatomic, assign) NSInteger rewardPrice;
@property (nonatomic, assign) NSInteger todayCount;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end