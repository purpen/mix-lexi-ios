//
//  THNSearchStoreTableViewCell.h
//  lexi
//
//  Created by HongpingRao on 2018/9/28.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THNFeaturedBrandModel;
typedef void(^SearchStoreBlcok)(NSString *productRid);

@interface THNSearchStoreTableViewCell : UITableViewCell

@property (nonatomic, strong) THNFeaturedBrandModel *brandModel;
@property (nonatomic, copy) SearchStoreBlcok searchStoreBlcok;

@end
