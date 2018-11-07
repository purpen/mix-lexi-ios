//
//  THNCategoriesModel.h
//  lexi
//
//  Created by HongpingRao on 2018/7/26.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>

@interface THNCategoriesModel : NSObject

@property (nonatomic, strong) NSString *cover;
@property (nonatomic, assign) NSInteger browse_count;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *category_id;
@property (nonatomic, assign) NSInteger pid;

@end
