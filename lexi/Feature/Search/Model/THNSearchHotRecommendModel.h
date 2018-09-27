//
//  THNSearchHotRecommendModel.h
//  lexi
//
//  Created by HongpingRao on 2018/9/27.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THNSearchHotRecommendModel : NSObject

@property (nonatomic, strong) NSString *recommend_cover;
@property (nonatomic, strong) NSString *recommend_cover_id;
@property (nonatomic, strong) NSString *recommend_id;
@property (nonatomic, strong) NSString *recommend_title;
// 1=商品, 2=店铺
@property (nonatomic, strong) NSString *target_type;

@end
