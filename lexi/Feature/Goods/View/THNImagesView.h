//
//  THNImagesView.h
//  lexi
//
//  Created by FLYang on 2018/8/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol THNImagesViewDelegate <NSObject>

- (void)thn_didSelectImageAtIndex:(NSInteger)index;

@end

@interface THNImagesView : UIView

@property (nonatomic, weak) id <THNImagesViewDelegate> delegate;

@property (nonatomic, strong) UIColor *thn_backgroundColor;

/**
 是否全屏展示
 */
- (instancetype)initWithFrame:(CGRect)frame fullScreen:(BOOL)fullScreen;

/**
 设置图片数据
 */
- (void)thn_setImageAssets:(NSArray *)assets;

@end
