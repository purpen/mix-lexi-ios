//
//  THNImageUrl.h
//  lexi
//
//  Created by FLYang on 2018/10/31.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, THNLoadImageUrlType) {
    THNLoadImageUrlTypeDefault = 0,         // 默认（不添加后缀，显示原图）
    THNLoadImageUrlTypeBannerFeatured,      // “精选” banner
    THNLoadImageUrlTypeBannerDiscover,      // "发现" banner
    THNLoadImageUrlTypeBannerDefault,       // 默认 banner
    THNLoadImageUrlTypeArticleList,         // 文章列表
    THNLoadImageUrlTypeArticleInfo,         // 文章详情
    THNLoadImageUrlTypeDealContent,         // 详情内容
    THNLoadImageUrlTypeGoodsInfo,           // 商品详情
    THNLoadImageUrlTypeGoodsList,           // 商品列表
    THNLoadImageUrlTypeGoodsCell,           // 商品单元格
    THNLoadImageUrlTypeWindowP500,          // 橱窗图片（500 * 500）
    THNLoadImageUrlTypeWindowMd,            // 橱窗图片（375 * 375）
    THNLoadImageUrlTypeWindowP3,            // 橱窗图片（315 * 236）
    THNLoadImageUrlTypeCategory,            // 分类
    THNLoadImageUrlTypeGatherList,          // 集合列表
    THNLoadImageUrlTypeGatherInfo,          // 集合详情
    THNLoadImageUrlTypeAvatar,              // 用户头像
    THNLoadImageUrlTypeAvatarSmall,         // 用户头像（最小）
    THNLoadImageUrlTypeAvatarBg,            // 用户头像背景
};

@interface THNImageUrl : NSString

@end

@interface NSObject (THNImageUrl)

/**
 配置拼接的后缀
 */
@property(nonatomic, readonly, strong) NSMutableDictionary *urlSuffixDict;

- (NSString *)loadImageUrlWithType:(THNLoadImageUrlType)type;

@end
