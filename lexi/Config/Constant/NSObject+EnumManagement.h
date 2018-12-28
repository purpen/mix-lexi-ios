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
    THNGoodsListViewTypeCustomization,  //  接单订制
    THNGoodsListViewTypeFreeShipping,   //  包邮专区
    THNGoodsListViewTypeNewExpress,     //  新品速递
};

typedef NS_ENUM(NSInteger, THNUserCenterGoodsType) {
    THNUserCenterGoodsTypeLikedGoods = 0, // 喜欢的商品
    THNUserCenterGoodsTypeBrowses,        // 最近查看
    THNUserCenterGoodsTypeWishList,       // 心愿单
};

typedef NS_ENUM(NSUInteger, THNGoodsFunctionViewType) {
    THNGoodsFunctionViewTypeDefault = 0,  // 默认
    THNGoodsFunctionViewTypeCustom,       // 可订制
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

typedef NS_ENUM(NSUInteger, THNDealContentType) {
    THNDealContentTypeArticle = 0,  // 文章详情
    THNDealContentTypeGoodsInfo,    // 商品详情
    THNDealContentTypeBrandHall,    // 品牌馆故事
    THNDealContentTypeGrassNote,    // 种草笔记
};

typedef NS_ENUM(NSUInteger, THNSharePosterType) {
    THNSharePosterTypeNone = 0,       // 没有海报
    THNSharePosterTypeGoods,          // 分享商品
    THNSharePosterTypeLifeStore,      // 生活馆
    THNSharePosterTypeWindow,         // 橱窗
    THNSharePosterTypeInvitation,     // 邀请
    THNSharePosterTypeBrandStore,     // 品牌馆
    THNSharePosterTypeInvitationUser, // 邀请用户
    THNSharePosterTypeArticle,        // 文章详情
    THNSharePosterTypeNote            // 种草笔记
};

@interface NSObject (EnumManagement)

@end
