//
//  THNImagesView.h
//  lexi
//
//  Created by FLYang on 2018/8/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THNImagesView : UIView

/**
 是否全屏展示
 */
- (instancetype)initWithFrame:(CGRect)frame fullScreen:(BOOL)fullScreen;

/**
 设置图片数据
 */
- (void)thn_setImageAssets:(NSArray *)assets;

@end
