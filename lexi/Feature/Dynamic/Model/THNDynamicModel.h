#import <UIKit/UIKit.h>
#import "THNDynamicModelLines.h"

@interface THNDynamicModel : NSObject

@property (nonatomic, strong) NSString * bgCover;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger followedStatus;
@property (nonatomic, strong) NSArray * lines;
@property (nonatomic, assign) BOOL next;
@property (nonatomic, assign) BOOL prev;
@property (nonatomic, strong) NSString * userAvatar;
@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSString * uid;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
