//
//  THNBannerModel.h
//  lexi
//
//  Created by HongpingRao on 2018/8/7.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 Banner的内容跳转

 - BannerContentTypeLink: 链接地址
 - BannerContentTypeProduct: 商品
 - BannerContentTypeCatogories: 分类
 - BannerContentTypeBrandHall: 品牌
 - BannerContentTypeSpecialTopic: 品牌
 - BannerContentTypeArticle: 文章
 */
typedef NS_ENUM(NSUInteger, BannerContentType) {
    BannerContentTypeLink = 1,
    BannerContentTypeProduct,
    BannerContentTypeCatogories,
    BannerContentTypeBrandHall,
    BannerContentTypeSpecialTopic,
    BannerContentTypeArticle
};

@interface THNBannerModel : NSObject

@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BannerContentType type;

@end
