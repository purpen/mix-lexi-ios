//
//  THNSearchView.h
//  lexi
//
//  Created by HongpingRao on 2018/9/26.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PopBlock)(void);

@interface THNSearchView : UIView

@property (nonatomic, copy) PopBlock popBlock;

@end
