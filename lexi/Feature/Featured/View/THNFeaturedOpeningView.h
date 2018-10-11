//
//  THNFeaturedOpeningView.h
//  lexi
//
//  Created by HongpingRao on 2018/7/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THNFeatureOpeningModel;
typedef void(^OpeningBlcok)(void);

typedef NS_ENUM(NSUInteger, FeatureOpeningType) {
    FeatureOpeningTypeMain,
    FeatureOpeningTypeProductCenterType
};

@interface THNFeaturedOpeningView : UIView

@property (weak, nonatomic) IBOutlet UIView *topTintView;
@property (nonatomic, copy) OpeningBlcok openingBlcok;
- (void)loadLivingHallHeadLineData:(FeatureOpeningType)openingType;

@end
