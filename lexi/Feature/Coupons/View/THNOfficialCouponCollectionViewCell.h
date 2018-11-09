//
//  THNOfficialCouponCollectionViewCell.h
//  lexi
//
//  Created by FLYang on 2018/11/1.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNCouponOfficialModel.h"

@interface THNOfficialCouponCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) UIViewController *currentVC;

- (void)thn_setOfficialModel:(THNCouponOfficialModel *)model;

@end
