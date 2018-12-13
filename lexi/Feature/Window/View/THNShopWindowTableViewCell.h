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


@protocol THNShopWindowTableViewCellDelegate <NSObject>

@optional
- (void)lookContentBlock:(THNShopWindowModel *)shopWindowModel;
- (void)clickImageViewWithRid:(NSString *)productRid;
- (void)showWindowShare:(THNShopWindowModel *)shopWindowModel;
- (void)clickAvatarImageView:(NSString *)userRid;

@end

@interface THNShopWindowTableViewCell : UITableViewCell

@property (nonatomic, strong) THNShopWindowModel *shopWindowModel;
@property (nonatomic, assign) ShopWindowImageType imageType;
@property (nonatomic, strong) NSString *flag;
@property (nonatomic, weak) id <THNShopWindowTableViewCellDelegate> delegate;
- (void)layoutLikeButtonStatus:(BOOL)isLike;

@end
