//
//  THNMyCenterDataButton.h
//  lexi
//
//  Created by FLYang on 2018/8/15.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THNMyCenterDataButton : UIButton

/**
 设置数据值
 */
- (void)setDataValue:(NSString *)value;

/**
 标题文字
 */
@property (nonatomic, copy) NSString *titleText;

@end
