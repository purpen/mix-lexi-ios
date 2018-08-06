//
//  THNProductCollectionViewCell.h
//  lexi
//
//  Created by HongpingRao on 2018/7/26.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THNProductModel;

@interface THNProductCollectionViewCell : UICollectionViewCell

//@property (nonatomic, strong) THNProductModel *productModel;

- (void)thn_setProductModel:(THNProductModel *)model;

@end
