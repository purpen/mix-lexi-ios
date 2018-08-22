//
//  THNShopWindowTableViewCell.h
//  lexi
//
//  Created by HongpingRao on 2018/8/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THNShopWindowModel;

typedef NS_ENUM(NSUInteger, ShopWindowType) {
    ShopWindowThree,
    ShopWindowFive,
    ShopWindowSeven,
};

typedef void(^ContentBlock)(void);

@interface THNShopWindowTableViewCell : UITableViewCell

@property (nonatomic, strong) THNShopWindowModel *shopWindowModel;
@property (nonatomic, copy) ContentBlock contentBlock;

@end
