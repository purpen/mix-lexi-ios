//
//  THNShopWindowHotLabelTableViewCell.h
//  lexi
//
//  Created by HongpingRao on 2018/11/16.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const shopWindowHotLabelCellIdentifier;

@class THNHotKeywordModel;

@interface THNShopWindowHotLabelTableViewCell : UICollectionViewCell

@property (nonatomic, strong) THNHotKeywordModel *hotKeywordModel;

@end
