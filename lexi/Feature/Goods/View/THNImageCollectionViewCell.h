//
//  THNImageCollectionViewCell.h
//  lexi
//
//  Created by FLYang on 2018/8/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THNImageCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *showImageView;

- (void)thn_setImageUrl:(NSString *)url;

@end
