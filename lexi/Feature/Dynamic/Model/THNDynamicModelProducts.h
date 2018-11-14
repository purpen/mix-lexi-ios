#import <UIKit/UIKit.h>

@interface THNDynamicModelProducts : NSObject

@property (nonatomic, strong) NSString * cover;
@property (nonatomic, strong) NSString * rid;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end