//
//  THNSearchHotSearchCollectionViewCell.h
//  lexi
//
//  Created by HongpingRao on 2018/9/26.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THNSearchHotSearchCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *hotSearchImageView;
// 热门搜索文字
@property (nonatomic, strong) NSString *hotSerarchStr;

@end
