#import <UIKit/UIKit.h>
#import "THNWindowModelShopWindows.h"

@interface THNWindowModel : NSObject

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) BOOL next;
@property (nonatomic, assign) BOOL prev;
@property (nonatomic, strong) NSArray * shopWindows;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end