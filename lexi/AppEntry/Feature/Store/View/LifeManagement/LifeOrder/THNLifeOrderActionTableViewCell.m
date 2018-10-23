//
//  THNLifeOrderExpressTableViewCell.m
//  lexi
//
//  Created by FLYang on 2018/10/10.
//  Copyright © 2018 taihuoniao. All rights reserved.
//

#import "THNLifeOrderActionTableViewCell.h"
#import "UIColor+Extension.h"
#import "UIView+Helper.h"
#import "THNConst.h"
#import "THNMarco.h"

static NSString *const kTextExpress = @"物流跟踪";

@interface THNLifeOrderActionTableViewCell ()

@property (nonatomic, strong) UIButton *expressButton;

@end

@implementation THNLifeOrderActionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupCellViewUI];
    }
    return self;
}

- (void)thn_setLifeOrderExpressNumber:(NSString *)number {
    self.expressButton.hidden = number.length == 0;
}

- (void)thn_setLifeOrderExpressStatus:(NSInteger)status {
    self.expressButton.hidden = status == 1;
}

#pragma mark - setup UI
- (void)setupCellViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.expressButton];
}

- (void)drawRect:(CGRect)rect {
    [UIView drawRectLineStart:(CGPointMake(0, 0))
                          end:(CGPointMake(SCREEN_WIDTH, 0))
                        width:1
                        color:[UIColor colorWithHexString:@"#E9E9E9"]];
}

#pragma mark - getters and setters
- (UIButton *)expressButton {
    if (!_expressButton) {
        _expressButton = [[UIButton alloc] initWithFrame: \
                          CGRectMake(SCREEN_WIDTH - 88, (49 - 30) / 2, 68, 30)];
        [_expressButton setTitle:kTextExpress forState:(UIControlStateNormal)];
        [_expressButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _expressButton.backgroundColor = [UIColor colorWithHexString:kColorMain];
        _expressButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_expressButton drawCornerWithType:(UILayoutCornerRadiusAll) radius:4];
    }
    return _expressButton;
}

@end
