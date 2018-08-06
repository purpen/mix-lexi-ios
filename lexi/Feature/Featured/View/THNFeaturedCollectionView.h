//
//  THNFeaturedCollectionView.h
//  lexi
//
//  Created by HongpingRao on 2018/7/27.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THNFeaturedCollectionView : UICollectionView

- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(UICollectionViewLayout *)layout
                withDataArray:(NSArray *)dataArray;

@end
