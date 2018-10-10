//
//  THNEvaluationTableViewCell.m
//  lexi
//
//  Created by HongpingRao on 2018/10/10.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNEvaluationTableViewCell.h"
#import <YYKit/YYKit.h>
#import "THNMarco.h"

@interface THNEvaluationTableViewCell()

@property (nonatomic, strong) YYTextView *textView;
@property (weak, nonatomic) IBOutlet UIView *evaluationView;

@end

@implementation THNEvaluationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.evaluationView addSubview:self.textView];
}

#pragma mark - lazy
- (YYTextView *)textView {
    if (!_textView) {
        _textView = [[YYTextView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH - 30, 100)];
        _textView.placeholderText = @" 我们希望收到你的建议，优化我们的不足。长度在100字以内";
        _textView.placeholderFont = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        _textView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _textView.placeholderTextColor = [UIColor colorWithHexString:@"B2B2B2"];
    }
    return _textView;
}

@end
