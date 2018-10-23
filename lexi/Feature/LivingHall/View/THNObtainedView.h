//
//  THNObtainedView.h
//  lexi
//
//  Created by HongpingRao on 2018/8/8.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ObtainedBlock)(void);

@interface THNObtainedView : UIView

+ (instancetype)sharedManager;
- (instancetype)show;
@property (nonatomic, copy) ObtainedBlock obtainedBlock;
@property (nonatomic, strong) NSString *title;

@end
