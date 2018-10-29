//
//  THNGoodsUserTableViewCell.h
//  lexi
//
//  Created by FLYang on 2018/9/1.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsBaseTableViewCell.h"

@protocol THNGoodsUserTableViewCellDelegate <NSObject>

@optional
- (void)thn_didSelectedGoodsLikedUser:(NSString *)userId;

@end

@interface THNGoodsUserTableViewCell : THNGoodsBaseTableViewCell

@property (nonatomic, weak) id <THNGoodsUserTableViewCellDelegate> delegate;

/**
 喜欢商品的用户
 */
- (void)thn_setLikedUserData:(NSArray *)data;

@end
