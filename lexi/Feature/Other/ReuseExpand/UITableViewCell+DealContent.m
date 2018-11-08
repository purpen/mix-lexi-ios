//
//  UITableViewCell+DealContent.m
//  lexi
//
//  Created by FLYang on 2018/11/8.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "UITableViewCell+DealContent.h"
#import "YYLabel+Helper.h"
#import "THNDealContentModel.h"
#import "NSString+Helper.h"

@interface UITableViewCell ()

/// 创建类型
@property (nonatomic, assign) THNDealContentType type;

@end

@implementation UITableViewCell (DealContent)

+ (CGFloat)heightWithDaelContentData:(NSArray *)dealContent {
    return [self heightWithDaelContentData:dealContent type:(THNDealContentTypeArticle)];
}

+ (CGFloat)heightWithDaelContentData:(NSArray<THNDealContentModel *> *)dealContent type:(THNDealContentType)type {
    CGFloat contentH = 0.0;
    CGFloat imageW = type == THNDealContentTypeArticle ? kScreenWidth : kScreenWidth - 30;
    
    for (THNDealContentModel *model in dealContent) {
        if ([model.type isEqualToString:@"text"]) {
            CGFloat textH = [YYLabel thn_getYYLabelTextLayoutSizeWithText:[NSString filterHTML:model.content]
                                                                 fontSize:14
                                                              lineSpacing:7
                                                                  fixSize:CGSizeMake(kScreenWidth - 30, MAXFLOAT)].height;
            contentH += (textH + 10);
            
        } else if ([model.type isEqualToString:@"image"]) {
            CGFloat imageScale = imageW / model.width;
            CGFloat imageH = model.height * imageScale;
            
            contentH += (imageH + 10);
        }
    }
    
    return contentH + 15;
}

@end
