//
//  NSObject+EnumManagement.h
//  lexi
//
//  Created by FLYang on 2018/8/29.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, THNGoodsListViewType) {
    THNGoodsListViewTypeDefault = 0,    //  默认商品列表
    THNGoodsListViewTypeUser,           //  个人中心商品
    THNGoodsListViewTypeCategory,       //  分类商品
    THNGoodsListViewTypeStore,          //  品牌馆
    THNGoodsListViewTypeEditors,        //  编辑推荐
    THNGoodsListViewTypeGather,         //  集合
    THNGoodsListViewTypeProductCenter,  //  选品中心
    THNGoodsListViewTypeBrandHall       //  品牌馆
};

typedef NS_ENUM(NSInteger, THNUserCenterGoodsType) {
    THNUserCenterGoodsTypeLikedGoods = 0, // 喜欢的商品
    THNUserCenterGoodsTypeBrowses,        // 最近查看
    THNUserCenterGoodsTypeWishList,       // 心愿单
    THNUserCenterGoodsTypeStore           // 设计馆商品
};

@interface NSObject (EnumManagement)

@end
