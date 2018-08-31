//
//	THNGoodsModel.h
//  on 31/8/2018
//	Copyright © 2018. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "THNGoodsModelAsset.h"
#import "THNGoodsModelDealContent.h"
#import "THNGoodsModelLabel.h"
#import "THNGoodsModelSku.h"

@interface THNGoodsModel : NSObject

@property (nonatomic, strong) NSArray * assets;
@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, assign) NSInteger commissionPrice;
@property (nonatomic, assign) NSInteger commissionRate;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * cover;
@property (nonatomic, assign) NSInteger coverId;
@property (nonatomic, strong) NSString * customDetails;
@property (nonatomic, strong) NSArray * dealContent;
@property (nonatomic, strong) NSString * deliveryCountry;
@property (nonatomic, assign) NSInteger deliveryCountryId;
@property (nonatomic, strong) NSString * features;
@property (nonatomic, strong) NSString * fid;
@property (nonatomic, assign) BOOL haveDistributed;
@property (nonatomic, strong) NSString * idCode;
@property (nonatomic, assign) BOOL isCustomMade;
@property (nonatomic, assign) BOOL isCustomService;
@property (nonatomic, assign) BOOL isDistributed;
@property (nonatomic, assign) BOOL isFreePostage;
@property (nonatomic, assign) BOOL isMadeHoliday;
@property (nonatomic, assign) BOOL isProprietary;
@property (nonatomic, assign) BOOL isSoldOut;
@property (nonatomic, strong) NSString * keywords;
@property (nonatomic, strong) NSArray * labels;
@property (nonatomic, assign) NSInteger likeCount;
@property (nonatomic, assign) NSInteger madeCycle;
@property (nonatomic, assign) NSInteger materialId;
@property (nonatomic, strong) NSString * materialName;
@property (nonatomic, assign) NSInteger maxPrice;
@property (nonatomic, assign) CGFloat maxSalePrice;
@property (nonatomic, assign) NSInteger minPrice;
@property (nonatomic, assign) CGFloat minSalePrice;
@property (nonatomic, strong) NSArray * modes;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * productReturnPolicy;
@property (nonatomic, assign) NSInteger publishedAt;
@property (nonatomic, assign) NSInteger realPrice;
@property (nonatomic, assign) CGFloat realSalePrice;
@property (nonatomic, assign) NSInteger returnPolicyId;
@property (nonatomic, strong) NSString * returnPolicyTitle;
@property (nonatomic, strong) NSString * rid;
@property (nonatomic, assign) NSInteger secondCategoryId;
@property (nonatomic, strong) NSArray * skus;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) BOOL sticked;
@property (nonatomic, assign) NSInteger stockCount;
@property (nonatomic, strong) NSString * storeLogo;
@property (nonatomic, strong) NSString * storeName;
@property (nonatomic, strong) NSString * storeRid;
@property (nonatomic, assign) NSInteger styleId;
@property (nonatomic, strong) NSString * styleName;
@property (nonatomic, assign) NSInteger topCategoryId;
@property (nonatomic, assign) NSInteger totalStock;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
