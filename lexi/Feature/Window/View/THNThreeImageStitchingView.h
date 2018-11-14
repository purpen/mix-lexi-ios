//
//  THNImageStitchingView.h
//  lexi
//
//  Created by HongpingRao on 2018/8/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ThreeImageBlock)(NSInteger index);

@interface THNThreeImageStitchingView : UIView

- (void)setThreeImageStitchingView:(NSArray *)images;
@property (nonatomic, copy) ThreeImageBlock threeImageBlock;

@property (nonatomic, assign) BOOL isHaveUserInteractionEnabled;
@property (nonatomic, assign) BOOL isContentModeCenter;

@end
