//
//  THNLikedGoodsCollectionViewCell.h
//  lexi
//
//  Created by FLYang on 2018/8/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNGoodsModel.h"
#import "NSObject+EnumManagement.h"

@interface THNLikedGoodsCollectionViewCell : UICollectionViewCell

/**
 设置商品数据
 
 @param cellViewType 单元格类型
 @param goodsModel 商品数据
 @param show 是否显示商品信息视图
 */
- (void)thn_setGoodsCellViewType:(THNGoodsListCellViewType)cellViewType
                      goodsModel:(THNGoodsModel *)goodsModel
                    showInfoView:(BOOL)show;

/**
 设置商品数据
 
 @param cellViewType 单元格类型
 @param goodsModel 商品数据
 @param show 是否显示商品信息视图
 @param index 根据下标请求不同的封面图
 */
- (void)thn_setGoodsCellViewType:(THNGoodsListCellViewType)cellViewType
                      goodsModel:(THNGoodsModel *)goodsModel
                    showInfoView:(BOOL)show
                           index:(NSInteger)index;

@end
