//
//  THNSearchHeaderView.m
//  lexi
//
//  Created by HongpingRao on 2018/9/26.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSearchHeaderView.h"

@interface THNSearchHeaderView()

@property (weak, nonatomic) IBOutlet UILabel *sectionTitleLabel;

@end

@implementation THNSearchHeaderView

- (IBAction)delete:(id)sender {
    
}

- (void)setSectionTitle:(NSString *)sectionTitle {
    self.sectionTitleLabel.text = sectionTitle;
}

@end
