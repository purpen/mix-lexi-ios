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

@interface THNHomeSearchView()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@end

@implementation THNHomeSearchView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [THNHomeSearchView viewFromXib];
        self.frame = frame;
        [self.searchTextField setValue:[UIColor colorWithHexString:@"555555"] forKeyPath:@"_placeholderLabel.textColor"];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.viewHeight = 40;
}

- (void)setSearchType:(SearchType)searchType {
    self.searchTextField.delegate = self;
    switch (searchType) {
        case SearchTypeHome:
            [self drawShadow:1.0];
            break;
        case SearchTypeProductCenter:
            self.backgroundColor = [UIColor colorWithHexString:@"F6F5F5"];
            [self drawCornerWithType:0 radius:self.viewHeight / 2];
            self.searchTextField.placeholder = @"商品名称， 关键词";
            break;
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        self.pushSearchBlock();
    }];
    
}


@end
