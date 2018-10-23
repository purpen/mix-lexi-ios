//
//  THNGrassListCollectionViewCell.h
//  lexi
//
//  Created by HongpingRao on 2018/7/31.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THNGrassListModel;

/**
 展示内容
 
 - ShowTextTypeDefault: 展示标题和内容
 - ShowTextTypeTheme: 展示主题和标题
 */
typedef NS_ENUM(NSUInteger, ShowTextType) {
    ShowTextTypeDefault,
    ShowTextTypeTheme
};


@interface THNGrassListCollectionViewCell : UICollectionViewCell


@property (nonatomic, assign) ShowTextType showTextType ;
@property (nonatomic, strong) THNGrassListModel *grassListModel;

@end
