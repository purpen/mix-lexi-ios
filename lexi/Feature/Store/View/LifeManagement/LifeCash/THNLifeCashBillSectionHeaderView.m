//
//  THNLifeCashBillSectionHeaderView.m
//  lexi
//
//  Created by FLYang on 2018/10/8.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNLifeCashBillSectionHeaderView.h"
#import <Masonry/Masonry.h>
#import "UIColor+Extension.h"

static NSString *const kTextCash = @"提现：";

@interface THNLifeCashBillSectionHeaderView ()

@property (nonatomic, strong) UILabel *textLable;
@property (nonatomic, strong) UILabel *subTextLable;

@end

@implementation THNLifeCashBillSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewUI];
    }
    return self;
}

- (void)thn_setTitleText:(NSString *)title subTitleText:(NSString *)subText {
    self.textLable.text = title;
    self.subTextLable.text = [NSString stringWithFormat:@"%@%@", kTextCash, subText];
    self.subTextLable.hidden = subText.length == 0;
}

- (void)setShowSubLabel:(BOOL)showSubLabel {
    self.subTextLable.hidden = !showSubLabel;
}

#pragma mark - setup UI
- (void)setupViewUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
    
    [self addSubview:self.textLable];
    [self addSubview:self.subTextLable];
    
    self.textLable.text = @"8月";
    self.subTextLable.text = [NSString stringWithFormat:@"%@141.20", kTextCash];
}

#pragma mark - getters and setters
- (UILabel *)textLable {
    if (!_textLable) {
        _textLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 50, CGRectGetHeight(self.frame))];
        _textLable.textColor = [UIColor colorWithHexString:@"#666666"];
        _textLable.font = [UIFont systemFontOfSize:14];
    }
    return _textLable;
}

- (UILabel *)subTextLable {
    if (!_subTextLable) {
        _subTextLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 220, 0, 200, CGRectGetHeight(self.frame))];
        _subTextLable.textColor = [UIColor colorWithHexString:@"#666666"];
        _subTextLable.font = [UIFont systemFontOfSize:12];
        _subTextLable.textAlignment = NSTextAlignmentRight;
    }
    return _subTextLable;
}

@end
