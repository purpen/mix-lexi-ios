//
//  THNSearchView.m
//  lexi
//
//  Created by HongpingRao on 2018/9/26.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNSearchView.h"
#import "UIColor+Extension.h"
#import "UIView+Helper.h"

@interface THNSearchView()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *clearBtn;
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UIView *searchBackgroundView;
@property (nonatomic, strong) UIImageView *searchImageView;

@end

@implementation THNSearchView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self addSubview:self.searchBackgroundView];
        [self addSubview:self.searchImageView];
        [self addSubview:self.searchTextField];
        [self addSubview:self.cancelBtn];
    }
    return self;
}

- (void)showClearButton {
    self.searchTextField.text.length  > 0 ? (self.clearBtn.hidden = NO) : (self.clearBtn.hidden = YES);
    [self addSubview:self.clearBtn];
}

- (void)clearTextfield {
    self.clearBtn.hidden = YES;
    self.searchTextField.text = @"";
}

// 搜索取消,刷新首页
- (void)backHomeController {
    [self.searchTextField resignFirstResponder];
    self.popBlock();
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

#pragma mark - lazy
- (UIImageView *)searchImageView {
    if (!_searchImageView) {
        _searchImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 14, 14)];
        _searchImageView.image = [UIImage imageNamed:@"icon_search_main"];
    }
    return _searchImageView;
}

- (UIView *)searchBackgroundView {
    if (!_searchBackgroundView) {
        _searchBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.viewWidth - 83, self.viewHeight)];
        _searchBackgroundView.backgroundColor = [UIColor colorWithHexString:@"EAEDF0"];
        _searchBackgroundView.layer.cornerRadius = self.viewHeight / 2;
    }
    return _searchBackgroundView;
}

- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc]init];
        _searchTextField.frame = CGRectMake(CGRectGetMaxX(self.searchImageView.frame) + 10, 5, self.viewWidth - 44 - 83, 20);
        UIColor *searchTextFieldColor = [UIColor colorWithHexString:@"555555"];
        _searchTextField.placeholder = @"关键字/商品/品牌馆/人";
        _searchTextField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _searchTextField.textColor = searchTextFieldColor;
        _searchTextField.delegate = self;
        [_searchTextField setValue:searchTextFieldColor forKeyPath:@"_placeholderLabel.textColor"];
        [_searchTextField addTarget:self action:@selector(showClearButton) forControlEvents:UIControlEventEditingChanged];
    }
    return _searchTextField;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc]init];
        _cancelBtn.frame = CGRectMake(CGRectGetMaxX(self.searchBackgroundView.frame) + 15, 0, 80, 30);
        _cancelBtn.backgroundColor = [UIColor whiteColor];
        _cancelBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0];
        _cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(backHomeController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)clearBtn {
    if (!_clearBtn) {
        _clearBtn = [[UIButton alloc]init];
        _clearBtn.frame = CGRectMake(CGRectGetMaxX(self.searchBackgroundView.frame) - 25, 6, 18, 18);
        [_clearBtn setImage:[UIImage imageNamed:@"icon_search_delete"] forState:UIControlStateNormal];
        [_clearBtn setImage:[UIImage imageNamed:@"icon_search_delete"] forState:UIControlStateHighlighted];
        [_clearBtn addTarget:self action:@selector(clearTextfield) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearBtn;
}

@end
