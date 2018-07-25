//
//  THNExploresViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/7/25.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNExploresViewController.h"
#import "THNBannerView.h"
#import "THNMarco.h"

static CGFloat const kBannerViewHeight = 115;
static CGFloat const kBannerViewSpacing = 20;
static CGFloat const kBannerViewY = 15;

@interface THNExploresViewController ()

@property (nonatomic, strong) THNBannerView *bannerView;
@property (nonatomic, strong) NSArray *data;

@end

@implementation THNExploresViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self setupUI];
}

- (void)setupUI {
    self.bannerView.data = self.data;
    [self.view addSubview:self.bannerView];

}

- (void)loadData {
    //@"https://kg.erp.taihuoniao.com/20180706/4605FpseCHcjdicYOsLROtwF_SVFKg_9.jpg",@"https://kg.erp.taihuoniao.com/20180702/3306FghyFReC2A0CWCUoZ4nTDV1KdhWT.jpg
    NSArray * array = @[@"https://kg.erp.taihuoniao.com/20180711/1808FgkTUxcFE3_2DAXlTdi4rQMRU7IY.jpg",@"https://kg.erp.taihuoniao.com/20180705/2856FgnuLr9GzH9Yg5Izfa3Cu5Y8iLHH.jpg",@"https://kg.erp.taihuoniao.com/20180701/5504FtL-iSk6tn4p1F2QKf4UBpJLgbZr.jpg"];
    self.data = array;
    
}


#pragma mark -lazy
- (THNBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[THNBannerView alloc]initWithFrame:CGRectMake(kBannerViewSpacing, kBannerViewY, SCREEN_WIDTH - kBannerViewSpacing * 2, kBannerViewHeight)];
    }
    return _bannerView;
}

@end
