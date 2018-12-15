#import <UIKit/UIKit.h>
#import "THNCashRecordModelRecordList.h"

@interface THNCashRecordModel : NSObject

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) BOOL next;
@property (nonatomic, assign) BOOL prev;
@property (nonatomic, strong) NSArray * recordList;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end