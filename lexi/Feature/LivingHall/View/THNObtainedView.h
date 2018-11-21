//
//  THNObtainedView.h
//  lexi
//
//  Created by HongpingRao on 2018/8/8.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ObtainedRightBlock)(void);
typedef void(^ObtainedLeftBlock)(void);

@interface THNObtainedView : UIView

+ (instancetype)sharedManager;
- (instancetype)show:(NSString *)title
withRightButtonTitle:(NSString *)rightButtonTitle
 withLeftButtonTitle:(NSString *)leftButtonTitle;

@property (nonatomic, copy) ObtainedRightBlock obtainedRightBlock;
@property (nonatomic, copy) ObtainedLeftBlock obtainedleftBlock;
@property (nonatomic, strong) NSString *title;

@end
