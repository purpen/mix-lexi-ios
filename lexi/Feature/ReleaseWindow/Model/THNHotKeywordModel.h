//
//  THNHotKeywordModel.h
//  lexi
//
//  Created by HongpingRao on 2018/11/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THNHotKeywordModel : NSObject

@property (nonatomic, assign) NSInteger keyWordID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger numbers;
// 标签类型： 0=无， 1=活动
@property (nonatomic, assign) NSInteger type;

@end
