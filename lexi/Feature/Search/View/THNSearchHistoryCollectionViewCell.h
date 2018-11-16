//
//  THNSearcgHistoryCollectionViewCell.h
//  lexi
//
//  Created by HongpingRao on 2018/9/26.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const kSearchHistoryCellIdentifier;

@interface THNSearchHistoryCollectionViewCell : UICollectionViewCell

// 历史记录
@property (nonatomic, strong) NSString *historyStr;
- (void)setupCellViewUI;

@end
