//
//  THNFunctionCollectionViewCell.h
//  lexi
//
//  Created by FLYang on 2018/8/27.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THNFunctionCollectionViewCell : UICollectionViewCell

/**
 设置单元格内容

 @param title 名称
 */
- (void)thn_setCellTitle:(NSString *)title;

/**
 选中单元格

 @param select 是否选中
 */
- (void)thn_selectCell:(BOOL)select;

@end
