//
//  THNPoupalRecommendCollectionViewCell.h
//  lexi
//
//  Created by HongpingRao on 2018/10/26.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THNPoupalRecommendCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSArray *popularDataArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
