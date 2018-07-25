//
//  THNQiNiuUpload.h
//  lexi
//
//  Created by FLYang on 2018/7/25.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface THNQiNiuUpload : NSObject

+ (void)uploadQiNiuToken:(NSString *)token image:(UIImage *)image compltion:(void (^)(NSDictionary *))completion;

@end
