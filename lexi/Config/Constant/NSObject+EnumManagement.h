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
    THNGoodsListViewTypeProductCenter,  //  选品中心
    THNGoodsListViewTypeEditors,        //  编辑推荐
    THNGoodsListViewTypeStore,          //  品牌馆
    THNGoodsListViewTypeNewProduct,     //  优质新品
    THNGoodsListViewTypeGather,         //  集合
    THNGoodsListViewTypeDesign,         //  特惠好设计
    THNGoodsListViewTypeGoodThing,      //  百元好物
    THNGoodsListViewTypeOptimal,        //  乐喜优选
    THNGoodsListViewTypeRecommend,      //  人气推荐
    THNGoodsListViewTypeSearch,         //  商品搜索
    THNGoodsListViewTypeCustomization,  //  接单定制
    THNGoodsListViewTypeFreeShipping    //  包邮专区
};

typedef NS_ENUM(NSInteger, THNUserCenterGoodsType) {
    THNUserCenterGoodsTypeLikedGoods = 0, // 喜欢的商品
    THNUserCenterGoodsTypeBrowses,        // 最近查看
    THNUserCenterGoodsTypeWishList,       // 心愿单
};

typedef NS_ENUM(NSUInteger, THNGoodsFunctionViewType) {
    THNGoodsFunctionViewTypeDefault = 0,  // 默认
    THNGoodsFunctionViewTypeCustom,       // 可定制
    THNGoodsFunctionViewTypeSell,         // 可卖
};

typedef NS_ENUM(NSUInteger, THNGoodsButtonType) {
    THNGoodsButtonTypeBuy = 0,  //  购买
    THNGoodsButtonTypeAddCart,  //  加入购物车
    THNGoodsButtonTypeCustom,   //  接单订制
    THNGoodsButtonTypeSell      //  卖
};

typedef NS_ENUM(NSUInteger, THNGoodsListCellViewType) {
    THNGoodsListCellViewTypeUserCenter = 0, // 个人中心
    THNGoodsListCellViewTypeGoodsInfoStore, // 商品详情店铺
    THNGoodsListCellViewTypeSimilarGoods,   // 相似商品
    THNGoodsListCellViewTypeGoodsList       // 商品列表
};

typedef NS_ENUM(NSUInteger, THNUserCouponType) {
    THNUserCouponTypeBrand = 0,     // 品牌券
    THNUserCouponTypeOfficial,      // 官方券
    THNUserCouponTypeFail,          // 失效券
};

@interface NSObject (EnumManagement)

@end
