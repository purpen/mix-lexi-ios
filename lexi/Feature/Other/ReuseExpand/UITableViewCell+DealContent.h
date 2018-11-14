//
//  UITableViewCell+DealContent.h
//  lexi
//
//  Created by FLYang on 2018/11/8.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNDealContentModel.h"
#import "NSObject+EnumManagement.h"

@interface UITableViewCell (DealContent)

/**
 文字内容的高度

 @param text 文字
 @param fontSize 字体大小
 @param spacing 行间距
 @param width 固定宽度
 @return 高度
 */
+ (CGFloat)heightWithText:(NSString *)text fontSize:(CGFloat)fontSize spacing:(CGFloat)spacing width:(CGFloat)width;

/**
 图文详情的高度

 @param dealContent 图文数组
 @return 高度
 */
+ (CGFloat)heightWithDaelContentData:(NSArray <THNDealContentModel *> *)dealContent;
+ (CGFloat)heightWithDaelContentData:(NSArray <THNDealContentModel *> *)dealContent type:(THNDealContentType)type;

@end
