//
//  THNLivingHallHeaderView.m
//  lexi
//
//  Created by HongpingRao on 2018/8/1.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLivingHallHeaderView.h"
#import "UIView+Helper.h"

@interface THNLivingHallHeaderView()

@property (weak, nonatomic) IBOutlet UIView *livingHallView;
@property (weak, nonatomic) IBOutlet UIView *selectionView;


@end

@implementation THNLivingHallHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 绘制渐变色
    self.selectionView.layer.cornerRadius = 4;
    self.selectionView.alpha = 1;
    CAGradientLayer *gradientLayer0 = [[CAGradientLayer alloc] init];
    gradientLayer0.cornerRadius = 4;
    gradientLayer0.frame = self.selectionView.bounds;
    gradientLayer0.colors = @[
                              (id)[UIColor colorWithRed:95.0f/255.0f green:228.0f/255.0f blue:177.0f/255.0f alpha:1.0f].CGColor,
                              (id)[UIColor colorWithRed:177.0f/255.0f green:230.0f/255.0f blue:126.0f/255.0f alpha:1.0f].CGColor];
    gradientLayer0.locations = @[@0, @1];
    [gradientLayer0 setStartPoint:CGPointMake(0, 0.5)];
    [gradientLayer0 setEndPoint:CGPointMake(1, 0.5)];
    [self.selectionView.layer addSublayer:gradientLayer0];
    [self.livingHallView drwaShadow];
    self.livingHallView.layer.borderWidth = 0;
}


@end
