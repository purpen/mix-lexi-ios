#import <UIKit/UIKit.h>

@interface THNWindowModelProducts : NSObject

@property (nonatomic, strong) NSString * bgcover;
@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, assign) CGFloat commissionPrice;
@property (nonatomic, assign) NSInteger commissionRate;
@property (nonatomic, strong) NSString * country;
@property (nonatomic, strong) NSString * cover;
@property (nonatomic, assign) NSInteger coverId;
@property (nonatomic, strong) NSString * customDetails;
@property (nonatomic, strong) NSString * deliveryCity;
@property (nonatomic, strong) NSString * deliveryCountry;
@property (nonatomic, assign) NSInteger deliveryCountryId;
@property (nonatomic, strong) NSString * deliveryProvince;
@property (nonatomic, assign) NSInteger distributionType;
@property (nonatomic, assign) NSInteger fansCount;
@property (nonatomic, strong) NSString * features;
@property (nonatomic, assign) BOOL haveDistributed;
@property (nonatomic, strong) NSString * idCode;
@property (nonatomic, assign) BOOL isCustomMade;
@property (nonatomic, assign) BOOL isCustomService;
@property (nonatomic, assign) BOOL isDistributed;
@property (nonatomic, assign) BOOL isFreePostage;
@property (nonatomic, assign) BOOL isMadeHoliday;
@property (nonatomic, assign) BOOL isProprietary;
@property (nonatomic, assign) BOOL isSoldOut;
@property (nonatomic, assign) NSInteger likeCount;
@property (nonatomic, assign) NSInteger madeCycle;
@property (nonatomic, assign) NSInteger materialId;
@property (nonatomic, strong) NSString * materialName;
@property (nonatomic, assign) NSInteger maxPrice;
@property (nonatomic, assign) NSInteger maxSalePrice;
@property (nonatomic, assign) NSInteger minPrice;
@property (nonatomic, assign) NSInteger minSalePrice;
@property (nonatomic, strong) NSArray * modes;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * province;
@property (nonatomic, assign) NSInteger publishedAt;
@property (nonatomic, assign) NSInteger realPrice;
@property (nonatomic, assign) NSInteger realSalePrice;
@property (nonatomic, strong) NSString * rid;
@property (nonatomic, assign) NSInteger secondCategoryId;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) BOOL sticked;
@property (nonatomic, strong) NSString * storeLogo;
@property (nonatomic, strong) NSString * storeName;
@property (nonatomic, strong) NSString * storeRid;
@property (nonatomic, assign) NSInteger styleId;
@property (nonatomic, strong) NSString * styleName;
@property (nonatomic, strong) NSString * tagLine;
@property (nonatomic, assign) NSInteger topCategoryId;
@property (nonatomic, assign) NSInteger totalStock;
@property (nonatomic, strong) NSString * town;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end