//
//  THNZipCodeView.h
//  lexi
//
//  Created by FLYang on 2018/7/23.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNAreaCodeModel.h"

@interface THNZipCodeView : UIView

/**
 关闭区号列表
 */
@property (nonatomic, copy) void (^CloseZipCodeViewBlock)(void);

/**
 选中区号
 */
@property (nonatomic, copy) void (^SelectedZipCodeBlock)(THNAreaCodeModel *model);

/**
 设置地区编码

 @param codes 编码列表
 */
- (void)thn_setAreaCodes:(NSArray *)codes;

@end
