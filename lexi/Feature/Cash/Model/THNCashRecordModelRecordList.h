#import <UIKit/UIKit.h>

@interface THNCashRecordModelRecordList : NSObject

@property (nonatomic, assign) NSInteger actualAmount;
@property (nonatomic, assign) NSInteger createdAt;
@property (nonatomic, strong) NSString * rid;
@property (nonatomic, assign) NSInteger status;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end