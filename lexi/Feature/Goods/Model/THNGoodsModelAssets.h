#import <UIKit/UIKit.h>

@interface THNGoodsModelAssets : NSObject

@property (nonatomic, assign) NSInteger createdAt;
@property (nonatomic, strong) NSString * filename;
@property (nonatomic, strong) NSString * filepath;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString * viewUrl;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end