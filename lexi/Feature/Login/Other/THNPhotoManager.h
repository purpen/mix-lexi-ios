//
//  THNPhotoManager.h
//  lexi
//
//  Created by FLYang on 2018/7/25.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface THNPhotoManager : NSObject

/**
 获取系统图片

 @param controller 当前控制器
 @param completion 完成回调
 */
- (void)getPhotoOfAlbumOrCameraWithController:(UIViewController *)controller completion:(void(^)(NSData *imageData))completion;

+ (instancetype)sharedManager;

@end
