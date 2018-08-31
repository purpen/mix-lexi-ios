//
//  THNGoodsSkuCollecitonView.h
//  lexi
//
//  Created by FLYang on 2018/8/31.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THNGoodsSkuCollecitonView : UIView

/**
 设置 sku 的名称
 */
- (void)thn_setSkuNameData:(NSArray *)data;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;

@end
