//
//  THNPhotoCollectionViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/10/10.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNPhotoCollectionViewCell.h"
#import "UIColor+Extension.h"

@interface THNPhotoCollectionViewCell()

@end

@implementation THNPhotoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)addPhoto:(id)sender {
    self.photoBlock();
}

- (IBAction)deletePhoto:(id)sender {
    self.deletePhotoBlock(self.tag);
}

- (void)setImageData:(NSData *)imageData {
    self.photoButton.enabled = NO;
    [self.photoButton setImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
}

@end
