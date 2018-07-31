//
//  THNFeaturedOpeningView.m
//  lexi
//
//  Created by HongpingRao on 2018/7/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNFeaturedOpeningView.h"
#import "UIColor+Extension.h"

@interface THNFeaturedOpeningView()

@property (weak, nonatomic) IBOutlet UIButton *openingButton;

@end

@implementation THNFeaturedOpeningView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.openingButton.layer.cornerRadius = 4;
    self.layer.shadowRadius = 5;
    self.layer.cornerRadius = 5;
    self.layer.shadowOffset = CGSizeMake(5, 5);
    self.layer.borderWidth = 0.5;
    self.layer.shadowOpacity = 0.1;
    self.layer.shadowColor = [[UIColor colorWithHexString:@"000000"] CGColor];
    self.layer.borderColor = [[UIColor colorWithHexString:@"e9e9e9"] CGColor];
    self.layer.masksToBounds = NO;
}

@end
