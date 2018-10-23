//
//  THNLoadView.m
//  lexi
//
//  Created by rhp on 2018/10/13.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLoadView.h"
#import <SDWebImage/UIImage+GIF.h>
#import "THNMarco.h"

@interface THNLoadView()

@property (weak, nonatomic) IBOutlet UIImageView *loadImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loadViewCententYConstraint;

@end

@implementation THNLoadView

-(void)awakeFromNib{
    [super awakeFromNib];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"loading" ofType:@"gif"];
    self.loadImageView.image =  [UIImage sd_animatedGIFWithData:[NSData dataWithContentsOfFile:imagePath]];
    self.loadViewCententYConstraint.constant = kDeviceiPhoneX ? -88 : -64;
}

@end
