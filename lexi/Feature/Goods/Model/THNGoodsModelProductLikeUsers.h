#import <UIKit/UIKit.h>

@interface THNGoodsModelProductLikeUsers : NSObject

@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, strong) NSString * uid;
@property (nonatomic, strong) NSString * username;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end