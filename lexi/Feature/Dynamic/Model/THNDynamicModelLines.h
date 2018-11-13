#import <UIKit/UIKit.h>
#import "THNDynamicModelProducts.h"

@interface THNDynamicModelLines : NSObject

@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, strong) NSString * descriptionField;
@property (nonatomic, assign) BOOL isExpert;
@property (nonatomic, assign) BOOL isFollow;
@property (nonatomic, assign) BOOL isLike;
@property (nonatomic, assign) BOOL isOfficial;
@property (nonatomic, strong) NSArray * keywords;
@property (nonatomic, assign) NSInteger likeCount;
@property (nonatomic, assign) NSInteger productCount;
@property (nonatomic, strong) NSArray * productCovers;
@property (nonatomic, strong) NSArray * products;
@property (nonatomic, assign) NSInteger rid;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * uid;
@property (nonatomic, assign) NSInteger updatedAt;
@property (nonatomic, assign) NSInteger createdAt;
@property (nonatomic, strong) NSString * userAvatar;
@property (nonatomic, strong) NSString * userName;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
