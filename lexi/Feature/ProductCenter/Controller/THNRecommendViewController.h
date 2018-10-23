//
//  THNRecommendTableViewController.h
//  lexi
//
//  Created by HongpingRao on 2018/8/24.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ProductType) {
    ProductTypeHot,
    ProductTypeOfficialRecommend,
    ProductTypeNew
};

@interface THNRecommendViewController : UITableViewController


@property (nonatomic, assign) ProductType productType;
@end
