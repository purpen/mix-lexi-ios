//
//  THNBrandHallFeaturesTableViewCell.h
//  lexi
//
//  Created by HongpingRao on 2018/9/3.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BrandHallFeaturesBlock)(NSString *rid);

@class THNFeaturedBrandModel;

@interface THNBrandHallFeaturesTableViewCell : UITableViewCell

@property (nonatomic, strong) THNFeaturedBrandModel *brandModel;
@property (nonatomic, copy) BrandHallFeaturesBlock brandHallFeaturesBlock;

@end
