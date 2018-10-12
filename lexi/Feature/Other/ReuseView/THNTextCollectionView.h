//
//  THNTextCollectionView.h
//  lexi
//
//  Created by HongpingRao on 2018/9/5.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNGrassListCollectionViewCell.h"

typedef void(^TextCollectionBlock)(NSInteger rid);

@interface THNTextCollectionView : UICollectionView

@property (nonatomic, assign) ShowTextType showTextType ;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, copy) TextCollectionBlock textCollectionBlock;

@end
