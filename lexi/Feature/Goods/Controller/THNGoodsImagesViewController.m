//
//  THNGoodsImagesViewController.m
//  lexi
//
//  Created by FLYang on 2018/8/30.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNGoodsImagesViewController.h"
#import "THNImagesView.h"

@interface THNGoodsImagesViewController ()

/// 图片列表
@property (nonatomic, strong) THNImagesView *imagesView;

@end

@implementation THNGoodsImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - setup UI
- (void)setupUI {
    [self.view addSubview:self.imagesView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGRect imageFrame = CGRectMake(0, (SCREEN_HEIGHT - SCREEN_WIDTH) / 2, SCREEN_WIDTH, SCREEN_WIDTH);
    [UIView animateWithDuration:0.3 animations:^{
        self.imagesView.frame = imageFrame;
    }];
}

#pragma mark - getters and setters
- (THNImagesView *)imagesView {
    if (!_imagesView) {
        _imagesView = [[THNImagesView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
    }
    return _imagesView;
}

@end
