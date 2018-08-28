//
//  THNCategoriesModel.h
//  lexi
//
//  Created by HongpingRao on 2018/7/26.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THNCategoriesModel : NSObject

@property (nonatomic, strong) NSString *cover;
@property (nonatomic, assign) NSInteger browse_count;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger pid;
@property (nonatomic, assign) NSInteger categorieID;

@end
