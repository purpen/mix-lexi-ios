//
//  THNHomeSearchView.m
//  lexi
//
//  Created by HongpingRao on 2018/7/24.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNHomeSearchView.h"
#import <UIKit/UIKit.h>
#import "UIColor+Extension.h"
#import "THNConst.h"
#import "THNMarco.h"
#import "UIView+Helper.h"

@interface THNHomeSearchView()

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@end

@implementation THNHomeSearchView

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [THNHomeSearchView viewFromXib];
        self.layer.shadowRadius = 5;
        self.layer.cornerRadius = 5;
        self.layer.shadowOffset = CGSizeMake(5, 5);
        self.layer.borderWidth = 0.5;
        self.layer.shadowOpacity = 0.1;
        self.layer.shadowColor = [[UIColor colorWithHexString:@"000000"] CGColor];
        self.layer.borderColor = [[UIColor colorWithHexString:@"e9e9e9"] CGColor];
        [self.searchTextField setValue:[UIColor colorWithHexString:@"555555"] forKeyPath:@"_placeholderLabel.textColor"];
        self.layer.masksToBounds = NO;
    }
    return self;
}



@end
