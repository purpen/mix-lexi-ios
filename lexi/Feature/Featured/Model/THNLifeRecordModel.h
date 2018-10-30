//
//  THNGrassListModel.h
//  lexi
//
//  Created by HongpingRao on 2018/8/6.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THNProductModel;

@interface THNLifeRecordModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *user_avatar;
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *des;
@property (nonatomic, strong) NSArray <THNProductModel *> *products;
// 橱窗编号
@property (nonatomic, assign) NSInteger rid;

@end
