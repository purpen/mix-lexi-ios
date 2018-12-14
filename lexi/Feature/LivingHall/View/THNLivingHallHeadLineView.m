//
//  THNLivingHallHeadLineView.m
//  lexi
//
//  Created by HongpingRao on 2018/12/13.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNLivingHallHeadLineView.h"
#import "THNLivingHallHeadLineTableView.h"

@interface THNLivingHallHeadLineView ()

@property (nonatomic, strong) THNLivingHallHeadLineTableView *headLineTableView;
@property (weak, nonatomic) IBOutlet UIButton *openStoreButton;

@end

@implementation THNLivingHallHeadLineView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addSubview:self.headLineTableView];
    self.openStoreButton.layer.cornerRadius = 4;
}

- (THNLivingHallHeadLineTableView *)headLineTableView {
    if (!_headLineTableView) {
        _headLineTableView = [[THNLivingHallHeadLineTableView alloc]initWithFrame:CGRectMake(214, 30, 112, 70)];
    }
    return _headLineTableView;
}

- (IBAction)openStore:(id)sender {
    if (self.headLineViewBlock) {
        self.headLineViewBlock();
    }
}

@end
