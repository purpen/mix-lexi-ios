#import <UIKit/UIKit.h>

@interface THNInviteAmountModel : NSObject

@property (nonatomic, assign) CGFloat cashAmount;
@property (nonatomic, assign) CGFloat cumulativeCashAmount;
@property (nonatomic, assign) CGFloat pendingPrice;
@property (nonatomic, assign) CGFloat rewardPrice;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
