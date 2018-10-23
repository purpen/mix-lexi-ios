//
//  THNSearchIndexModel.h
//  lexi
//
//  Created by HongpingRao on 2018/9/27.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THNSearchIndexModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *serial_no;
// 1=商品, 2=原创品牌设计馆, 3=用户
@property (nonatomic, assign) NSInteger target_type;

@end
