//
//  THNImageUrl.m
//  lexi
//
//  Created by FLYang on 2018/10/31.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNImageUrl.h"
#import <objc/runtime.h>

@implementation THNImageUrl

@end

@implementation NSObject (THNImageUrl)

- (NSString *)loadImageUrlWithType:(THNLoadImageUrlType)type {
    NSString *suffix = self.urlSuffixDict[@(type)];
    NSString *suffixStr = suffix.length ? [NSString stringWithFormat:@"-%@", suffix] : @"";
    NSString *resultUrl = [NSString stringWithFormat:@"%@%@", self, suffixStr];
    
    return resultUrl;
}

#pragma mark - getters and setters
- (id)urlSuffixDict {
    return objc_getAssociatedObject(self, _cmd) ? : ({
        NSDictionary *suffixDic = @{
                                    @(THNLoadImageUrlTypeBannerFeatured): @"",
                                    @(THNLoadImageUrlTypeBannerDiscover): @"",
                                    @(THNLoadImageUrlTypeBannerDefault) : @"",
                                    @(THNLoadImageUrlTypeArticleList)   : @"p315x236",
                                    @(THNLoadImageUrlTypeArticleInfo)   : @"bg75x40",
                                    @(THNLoadImageUrlTypeDealContent)   : @"",
                                    @(THNLoadImageUrlTypeGoodsInfo)     : @"p50",
                                    @(THNLoadImageUrlTypeGoodsList)     : @"md",
                                    @(THNLoadImageUrlTypeGoodsCell)     : @"p16",
                                    @(THNLoadImageUrlTypeWindowP500)    : @"p500",
                                    @(THNLoadImageUrlTypeWindowMd)      : @"md",
                                    @(THNLoadImageUrlTypeWindowP3)      : @"p315x236",
                                    @(THNLoadImageUrlTypeCategory)      : @"md",
                                    @(THNLoadImageUrlTypeGatherList)    : @"md",
                                    @(THNLoadImageUrlTypeGatherInfo)    : @"avabg",
                                    @(THNLoadImageUrlTypeAvatar)        : @"ava",
                                    @(THNLoadImageUrlTypeAvatarSmall)   : @"p16",
                                    @(THNLoadImageUrlTypeAvatarBg)      : @"avabg"
                                    };
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:suffixDic];
        objc_setAssociatedObject(self, @selector(urlSuffixDict), dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        dic;
    });
}


@end

