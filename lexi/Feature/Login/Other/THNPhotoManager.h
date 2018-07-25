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

+ (instancetype)sharedManager;

- (void)getPhotoOfAlbumOrCameraWithController:(UIViewController *)controller
                                   completion:(void(^)(UIImage *image))completion;

@end
