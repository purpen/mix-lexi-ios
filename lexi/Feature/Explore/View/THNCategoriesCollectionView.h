//
//  THNCategoriesCollectionView.h
//  lexi
//
//  Created by HongpingRao on 2018/7/26.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CategoriesBlock)(NSInteger pid);

@interface THNCategoriesCollectionView : UICollectionView

- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(UICollectionViewLayout *)layout;

@property (nonatomic, strong) NSArray *categorieDataArray;
@property (nonatomic, assign) CategoriesBlock categoriesBlock;

@end
