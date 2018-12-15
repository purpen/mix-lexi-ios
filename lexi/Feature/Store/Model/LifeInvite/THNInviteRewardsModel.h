#import <UIKit/UIKit.h>
#import "THNInviteRewardsModelRewards.h"

@interface THNInviteRewardsModel : NSObject

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) BOOL next;
@property (nonatomic, assign) BOOL prev;
@property (nonatomic, strong) NSArray * rewards;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end