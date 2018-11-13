//
//  THNSevenImagesStitchView.h
//  lexi
//
//  Created by HongpingRao on 2018/8/23.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SevenImageBlock)(NSInteger index);

@interface THNSevenImagesStitchView : UIView

- (void)setSevenImageStitchingView:(NSArray *)images;
@property (nonatomic, copy) SevenImageBlock sevenImageBlock;
@property (nonatomic, assign) BOOL isContentModeCenter;

@end
