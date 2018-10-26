//
//  THNRecentlyViewedCollectionView.h
//  lexi
//
//  Created by HongpingRao on 2018/9/27.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RecentlyViewedBlock)(NSString *goodID);

@interface THNRecentlyViewedCollectionView : UICollectionView

@property (nonatomic, strong) NSArray *recentlyViewedProducts;
@property (nonatomic, copy) RecentlyViewedBlock recentlyViewedBlock;

@end
