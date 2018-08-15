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

@interface THNFeaturedOpeningView : UIView

@property (nonatomic, copy) OpeningBlcok openingBlcok;
- (void)loadLivingHallHeadLineData;

@end
