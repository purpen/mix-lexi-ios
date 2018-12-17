//
//  THNLivingHallHeadLineView.m
//  lexi
//
//  Created by HongpingRao on 2018/12/13.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLivingHallHeadLineView.h"
#import "THNLivingHallHeadLineTableView.h"
#import "THNMarco.h"
#import "THNAPI.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+Helper.h"

static NSString *kUrlHeadLineBg = @"/banners/wxa_lifestore_bg";


@interface THNLivingHallHeadLineView ()

@property (nonatomic, strong) THNLivingHallHeadLineTableView *headLineTableView;
@property (weak, nonatomic) IBOutlet UIButton *openStoreButton;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end

@implementation THNLivingHallHeadLineView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.openStoreButton.layer.cornerRadius = 4;
    [self addSubview:self.headLineTableView];
    [self loadBackgroundImage];
}

- (void)loadBackgroundImage {
    THNRequest *request = [THNAPI getWithUrlString:kUrlHeadLineBg requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        NSString *imageUrl = result.data[@"banner_images"][0][@"image"];
        [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
        [self.backgroundImageView drawCornerWithType:0 radius:4];
    } failure:^(THNRequest *request, NSError *error) {
            
    }];
}

- (THNLivingHallHeadLineTableView *)headLineTableView {
    if (!_headLineTableView) {
        _headLineTableView = [[THNLivingHallHeadLineTableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 162, 30, 112, 70)];
    }
    return _headLineTableView;
}

- (IBAction)openStore:(id)sender {
    if (self.headLineViewBlock) {
        self.headLineViewBlock();
    }
}

@end
