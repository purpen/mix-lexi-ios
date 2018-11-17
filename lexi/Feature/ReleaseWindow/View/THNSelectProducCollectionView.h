//
//  THNSelectProducCollectionView.h
//  lexi
//
//  Created by HongpingRao on 2018/11/15.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectProductBlock)(NSString *rid, NSString *storeRid);

@interface THNSelectProducCollectionView : UICollectionView

@property (nonatomic, strong) NSMutableArray *products;
@property (nonatomic, copy) SelectProductBlock selectProductBlcok;

@end
