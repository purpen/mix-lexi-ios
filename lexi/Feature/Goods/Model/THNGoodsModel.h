#import <UIKit/UIKit.h>
#import "THNGoodsModelAssets.h"
#import "THNDealContentModel.h"
#import "THNGoodsModelLabels.h"
#import "THNGoodsModelProductLikeUsers.h"

@interface THNGoodsModel : NSObject

@property (nonatomic, strong) NSArray * assets;
@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, assign) CGFloat commissionPrice;
@property (nonatomic, assign) NSInteger commissionRate;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, assign) NSInteger countryId;
@property (nonatomic, strong) NSString * cover;
@property (nonatomic, assign) NSInteger coverId;
@property (nonatomic, strong) NSString * customDetails;
@property (nonatomic, strong) NSArray * dealContent;
@property (nonatomic, strong) NSString * deliveryCity;
@property (nonatomic, strong) NSString * deliveryCountry;
@property (nonatomic, strong) NSString * deliveryProvince;
@property (nonatomic, strong) NSString * features;
@property (nonatomic, strong) NSString * fid;
@property (nonatomic, assign) BOOL haveDistributed;
@property (nonatomic, strong) NSString * idCode;
@property (nonatomic, assign) BOOL isCustomMade;
@property (nonatomic, assign) BOOL isCustomService;
@property (nonatomic, assign) BOOL isDistributed;
@property (nonatomic, assign) BOOL isFreePostage;
@property (nonatomic, assign) BOOL isLike;
@property (nonatomic, assign) BOOL isMadeHoliday;
@property (nonatomic, assign) BOOL isProprietary;
@property (nonatomic, assign) BOOL isSoldOut;
@property (nonatomic, assign) BOOL isWish;
@property (nonatomic, strong) NSString * keywords;
@property (nonatomic, strong) NSArray * labels;
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
@property (nonatomic, strong) NSArray * productLikeUsers;
@property (nonatomic, strong) NSString * productReturnPolicy;
@property (nonatomic, assign) NSInteger publishedAt;
@property (nonatomic, strong) NSObject * pyIntro;
@property (nonatomic, assign) NSInteger realPrice;
@property (nonatomic, assign) NSInteger realSalePrice;
@property (nonatomic, assign) NSInteger returnPolicyId;
@property (nonatomic, strong) NSString * returnPolicyTitle;
@property (nonatomic, strong) NSString * rid;
@property (nonatomic, assign) NSInteger secondCategoryId;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger stockCount;
@property (nonatomic, strong) NSString * storeLogo;
@property (nonatomic, strong) NSString * storeName;
@property (nonatomic, strong) NSString * storeRid;
@property (nonatomic, assign) NSInteger styleId;
@property (nonatomic, strong) NSString * styleName;
@property (nonatomic, assign) NSInteger topCategoryId;
@property (nonatomic, assign) NSInteger totalStock;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
