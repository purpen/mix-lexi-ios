//
//  THNFiveImagesStitchView.h
//  lexi
//
//  Created by HongpingRao on 2018/8/23.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FiveImageBlock)(NSInteger index);

@interface THNFiveImagesStitchView : UIView

- (void)setFiveImageStitchingView:(NSArray *)images;

@property (nonatomic, copy) FiveImageBlock fiveImageBlock;
@property (nonatomic, assign) BOOL isContentModeCenter;
- (void)setCLickImageView:(NSString *)url withSelectIndex:(NSInteger)index;

@end
