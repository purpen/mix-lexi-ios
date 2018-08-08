//
//  THNBannnerCollectionViewCell.h
//  lexi
//
//  Created by HongpingRao on 2018/7/26.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THNSetModel;
@class THNBannerModel;

@interface THNBannnerCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) THNSetModel *setModel;
@property (nonatomic, strong) THNBannerModel *bannerModel;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UIView *setLabelsView;

@end
