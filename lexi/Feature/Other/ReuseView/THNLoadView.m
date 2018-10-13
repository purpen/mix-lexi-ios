//
//  THNLoadView.m
//  lexi
//
//  Created by rhp on 2018/10/13.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLoadView.h"
#import <SDWebImage/UIImage+GIF.h>

@interface THNLoadView()

@property (weak, nonatomic) IBOutlet UIImageView *loadImageView;

@end

@implementation THNLoadView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.loadImageView.image =  [UIImage sd_animatedGIFWithData:[NSData dataWithContentsOfFile:@"/Users/rhp/Desktop/mix-lexi-ios/lexi/Resource/Images/loading.gif"]];
}

@end
