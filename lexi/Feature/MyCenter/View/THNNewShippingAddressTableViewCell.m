//
//  THNNewShippingAddressTableViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/9/10.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNNewShippingAddressTableViewCell.h"
#import <YYKit/YYTextView.h>
#import "UIColor+Extension.h"
#import "THNMarco.h"
#import "UIView+Helper.h"


@implementation THNNewShippingAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setPlaceholderText:(NSString *)placeholderText {
    _placeholderText = placeholderText;
    self.textView.placeholderText = placeholderText;
    self.textView.frame = CGRectMake(15, 7.5, SCREEN_WIDTH - self.areaCodeTextView.viewWidth - 40, self.viewHeight - 7.5);
    [self addSubview:self.textView];
    
}

- (YYTextView *)textView {
    if (!_textView) {
        _textView = [[YYTextView alloc]init];
        _textView.placeholderFont = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _textView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _textView.textColor = [UIColor colorWithHexString:@"333333"];
        _textView.placeholderTextColor = [UIColor colorWithHexString:@"B2B2B2"];
    }
    return _textView;
}

- (YYTextView *)areaCodeTextView {
    if (!_areaCodeTextView) {
        _areaCodeTextView = [[YYTextView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 90, 7.5, 60, self.viewHeight - 10)];
        _areaCodeTextView.backgroundColor = [UIColor whiteColor];
        _areaCodeTextView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _areaCodeTextView.textColor = [UIColor colorWithHexString:@"333333"];
        _areaCodeTextView.textAlignment = NSTextAlignmentRight;
    }
    return _areaCodeTextView;
}

@end
