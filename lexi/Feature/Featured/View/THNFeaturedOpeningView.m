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

// 开馆指引
static NSString *const kUrlLivingHallHeadLine = @"/store/store_headline";

@interface THNFeaturedOpeningView()


@property (weak, nonatomic) IBOutlet UIButton *openingButton;
@property (weak, nonatomic) IBOutlet UILabel *openLivingHallLabel;
@property (weak, nonatomic) IBOutlet UILabel *soldOrderCountTextLabel;

@end

@implementation THNFeaturedOpeningView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.openingButton drawCornerWithType:0 radius:4];
    [self drwaShadow];
}

// 开馆指引
- (void)loadLivingHallHeadLineData {
    THNRequest *request = [THNAPI getWithUrlString:kUrlLivingHallHeadLine requestDictionary:nil isSign:YES delegate:nil];
    [request startRequestSuccess:^(THNRequest *request, THNResponse *result) {
        NSString *fistUserName = result.data[@"username_one"];
        NSString *secondUserName = result.data[@"username_two"];
        NSInteger orderCount = [result.data[@"order_count"] integerValue];
        NSString *openLivingHallStr = [NSString stringWithFormat:@"设计师%@秒前开了自己的设计馆",fistUserName];
        NSString *soldOrderStr = [NSString stringWithFormat:@"%@的设计馆1小时售出%ld单",secondUserName,orderCount];
        NSAttributedString *openLivingHallAttStr = [THNTextTool setTextColor:openLivingHallStr initWithColor:@"5fe4b1" initWithRange:NSMakeRange(0, 3 + fistUserName.length)];
        NSInteger loc = secondUserName.length + 7;
        NSAttributedString *soldOrderAttStr = [THNTextTool setTextColor:soldOrderStr initWithColor:@"f4b329" initWithRange:NSMakeRange(loc, soldOrderStr.length - loc)];
        self.openLivingHallLabel.attributedText = openLivingHallAttStr;
        self.soldOrderCountTextLabel.attributedText = soldOrderAttStr;
    } failure:^(THNRequest *request, NSError *error) {
        
    }];
}

- (IBAction)opening:(id)sender {
    self.openingBlcok();
}

@end
