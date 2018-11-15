//
//  THNSelectPruductCoverCollectionViewCell.h
//  lexi
//
//  Created by HongpingRao on 2018/11/15.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THNSelectPruductCoverCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) BOOL isSelect;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@end
