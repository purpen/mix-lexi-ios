//
//  THNHeaderTitleView.h
//  lexi
//
//  Created by FLYang on 2018/9/15.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THNHeaderTitleView : UIView

@property (nonatomic, strong) NSString *title;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;

@end
