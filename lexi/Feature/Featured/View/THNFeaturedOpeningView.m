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
#import "THNTextTool.h"
#import "THNAPI.h"
#import "THNLivingHallHeadLineModel.h"
#import <MJExtension/MJExtension.h>
#import "THNFeaturedOpenCarouselScrollView.h"
#import "THNMarco.h"

// 开馆指引
static NSString *const kUrlLivingHallHeadLine = @"/store/store_headline";

@interface THNFeaturedOpeningView()

@property (weak, nonatomic) IBOutlet UIView *bottomCarouselView;
@property (weak, nonatomic) IBOutlet UIButton *openingButton;
@property (weak, nonatomic) IBOutlet UILabel *desTitleLabel;

@end

@implementation THNFeaturedOpeningView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.openingButton drawCornerWithType:0 radius:4];
    if (SCREEN_WIDTH == 320) {
        self.desTitleLabel.text = @"分享好物赚钱, 购物省钱";
    }
    [self drwaShadow];
}

// 开馆指引
- (void)loadLivingHallHeadLineData:(FeatureOpeningType)openingType {
    THNRequest *request = [THNAPI getWithUrlString:kUrlLivingHallHeadLine requestDictionary:nil delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        NSArray *headlines = result.data[@"headlines"];
        NSMutableArray *headlineAttStrArray = [NSMutableArray array];
        
        for (NSDictionary *dict in headlines) {
            THNLivingHallHeadLineModel *headLineModel = [THNLivingHallHeadLineModel mj_objectWithKeyValues:dict];
            NSString *headLineStr;
            NSAttributedString *headLineAttStr;
            if (headLineModel.event == HeadlineShowTypeOpen) {
                headLineStr = [NSString stringWithFormat:@"%@%@%@开了自己的设计馆",headLineModel.username, headLineModel.time, headLineModel.time_info];
                headLineAttStr = [THNTextTool setTextColor:headLineStr initWithColor:@"5fe4b1" initWithRange:NSMakeRange(0, 3 + headLineModel.username.length)];
            } else {
                NSString *saleOrderCountStr = [NSString stringWithFormat:@"售出%ld单", headLineModel.quantity];
                headLineStr = [NSString stringWithFormat:@"%@的设计馆%@%@%@",headLineModel.username, headLineModel.time, headLineModel.time_info, saleOrderCountStr];
                headLineAttStr = [THNTextTool setTextColor:headLineStr initWithColor:@"f4b329" initWithRange:NSMakeRange(headLineStr.length - saleOrderCountStr.length, saleOrderCountStr.length)];
            }
            [headlineAttStrArray addObject:headLineAttStr];
        }
        
        CGFloat y = 0;
        if (openingType == FeatureOpeningTypeMain) {
            y = 20;
        } else {
            y = - 45.5;
        }
        
       THNFeaturedOpenCarouselScrollView *carouselScrollView = [[THNFeaturedOpenCarouselScrollView alloc] initWithFrame:CGRectMake(68, y, self.viewWidth - 68, 40)];
        [carouselScrollView setDataTitleArray:headlineAttStrArray];
        [self.bottomCarouselView addSubview:carouselScrollView];
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

 - (IBAction)opening:(id)sender {
    self.openingBlcok();
}

@end
