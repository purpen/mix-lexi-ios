//
//  THNBannnerCollectionViewCell.h
//  lexi
//
//  Created by HongpingRao on 2018/7/26.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THNSetModel;

@interface THNBannnerCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (nonatomic, strong) THNSetModel *setModel;

@end
