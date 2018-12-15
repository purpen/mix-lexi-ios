#import <UIKit/UIKit.h>

@interface THNInviteFriendsModelFriends : NSObject

@property (nonatomic, assign) CGFloat amount;
@property (nonatomic, assign) NSInteger phases;
@property (nonatomic, strong) NSString * userLogo;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * userSn;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
