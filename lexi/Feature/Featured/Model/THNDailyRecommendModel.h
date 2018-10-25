//
//  THNDailyRecommendModel.h
//  lexi
//
//  Created by HongpingRao on 2018/8/14.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THNDailyRecommendModel : NSObject

@property (nonatomic, strong) NSString *cover;
// 推荐标签
@property (nonatomic, strong) NSString *recommend_label;
// 推荐标题
@property (nonatomic, strong) NSString *recommend_title;
// 推荐描述内容
@property (nonatomic, strong) NSString *recommend_description;
@property (nonatomic, assign) NSInteger recommend_id;

@end
