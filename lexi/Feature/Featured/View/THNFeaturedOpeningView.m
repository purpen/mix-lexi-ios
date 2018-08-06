//
//  THNFeaturedOpeningView.m
//  lexi
//
//  Created by HongpingRao on 2018/7/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNFeaturedOpeningView.h"
#import "UIColor+Extension.h"
#import "UIView+Helper.h"

@interface THNFeaturedOpeningView()

@property (weak, nonatomic) IBOutlet UIButton *openingButton;

@end

@implementation THNFeaturedOpeningView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self drwaShadow];
}

@end
