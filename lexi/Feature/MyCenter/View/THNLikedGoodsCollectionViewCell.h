//
//  THNLikedGoodsCollectionViewCell.h
//  lexi
//
//  Created by FLYang on 2018/8/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNProductModel.h"

@interface THNLikedGoodsCollectionViewCell : UICollectionViewCell

/**
 绑定商品数据
 
 @param model 商品model
 @param show 是否显示商品信息视图
 */
- (void)thn_setGoodsModel:(THNProductModel *)model showInfoView:(BOOL)show;

@end
