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
        
        [self.searchTextField setValue:[UIColor colorWithHexString:@"555555"] forKeyPath:@"_placeholderLabel.textColor"];
        [self drwaShadow];
    }
    return self;
}



@end
