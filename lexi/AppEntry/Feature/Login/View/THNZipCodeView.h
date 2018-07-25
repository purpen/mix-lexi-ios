//
//  THNZipCodeView.h
//  lexi
//
//  Created by FLYang on 2018/7/23.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CloseZipCodeViewBlock)(void);
typedef void(^SelectedZipCodeBlock)(NSString *zipCode);

@interface THNZipCodeView : UIView

/**
 关闭区号列表
 */
@property (nonatomic, copy) CloseZipCodeViewBlock CloseZipCodeViewBlock;

/**
 选中区号
 */
@property (nonatomic, copy) SelectedZipCodeBlock SelectedZipCodeBlock;

@end
