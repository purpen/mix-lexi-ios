#import <UIKit/UIKit.h>

@interface THNDealContentModel : NSObject

@property (nonatomic, strong) NSString * content;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, strong) NSString * rid;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, assign) NSInteger width;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
