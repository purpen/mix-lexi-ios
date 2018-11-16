//
//  THNPhotoCollectionViewCell.h
//  lexi
//
//  Created by HongpingRao on 2018/10/10.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PhotoBlock)(void);
typedef void(^DeletePhotoBlock)(NSInteger tag);

@interface THNPhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSData *imageData;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (nonatomic, copy) PhotoBlock photoBlock;
@property (nonatomic, copy) DeletePhotoBlock deletePhotoBlock;


@end
