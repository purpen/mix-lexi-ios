#import <UIKit/UIKit.h>
#import "THNInviteFriendsModelFriends.h"

@interface THNInviteFriendsModel : NSObject

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSArray * friends;
@property (nonatomic, assign) BOOL next;
@property (nonatomic, assign) BOOL prev;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end