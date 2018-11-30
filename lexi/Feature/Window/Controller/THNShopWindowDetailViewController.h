//
//  THNShopWindowDetailViewController.h
//  lexi
//
//  Created by HongpingRao on 2018/8/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNBaseViewController.h"

@class THNShopWindowModel;

typedef NS_ENUM(NSUInteger, ShopWindowDetailCellType) {
    ShopWindowDetailCellTypeMain,
    ShopWindowDetailCellTypeComment,
    ShopWindowDetailCellTypeExplore,
    ShopWindowDetailCellTypeFeature
};

@interface THNShopWindowDetailViewController : THNBaseViewController

@property (nonatomic, assign) CGFloat shopWindowCellHeight;
@property (nonatomic, strong) THNShopWindowModel *shopWindowModel;
//橱窗编号
@property (nonatomic, strong) NSString *rid;

@end
