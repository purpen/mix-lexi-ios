//
//  THNGrassListModel.h
//  lexi
//
//  Created by HongpingRao on 2018/8/11.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class THNGoodsModelDealContent;

@interface THNGrassListModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *des;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *user_avator;
@property (nonatomic, strong) NSString *channel_name;
@property (nonatomic, assign) CGFloat grassLabelHeight;
// 生活志编号
@property (nonatomic, assign) NSInteger rid;
@property (nonatomic, strong) NSArray <THNGoodsModelDealContent *> *deal_content;

@end
