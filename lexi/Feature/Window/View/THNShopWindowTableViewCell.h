//
//  THNShopWindowTableViewCell.h
//  lexi
//
//  Created by HongpingRao on 2018/8/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const kUrlShopWindowsUserLikes;

@class THNShopWindowModel;

typedef NS_ENUM(NSUInteger, ShopWindowImageType) {
    ShopWindowImageTypeThree,
    ShopWindowImageTypeFive,
    ShopWindowImageTypeSeven,
};

typedef void(^ContentBlock)(void);
typedef void(^ShopWindowCellBlock)(NSString *rid);
typedef void(^ShopWindowShareBlock)(NSString *rid);

@interface THNShopWindowTableViewCell : UITableViewCell

@property (nonatomic, strong) THNShopWindowModel *shopWindowModel;
@property (nonatomic, copy) ContentBlock contentBlock;
@property (nonatomic, copy) ShopWindowCellBlock shopWindowCellBlock;
@property (nonatomic, copy) ShopWindowShareBlock shareBlock;
@property (nonatomic, assign) ShopWindowImageType imageType;
@property (nonatomic, strong) NSString *flag;
- (void)layoutLikeButtonStatus:(BOOL)isLike;

@end
