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
@property (nonatomic, assign) CGFloat backgroundViewWidth;

//一个用来归档，一个用来显示
@property (strong,nonatomic) NSMutableArray *historySearchArr;
@property (strong,nonatomic) NSArray *historyShowSearchArr;

@end

@implementation THNSearchView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
    }
    return self;
}

- (void)layoutSearchView:(SearchViewType)searchViewType {
    if (searchViewType == SearchViewTypeDefault) {
        self.backgroundViewWidth = 83;
        [self addSubview:self.cancelBtn];
    } else {
        self.backgroundViewWidth = 0;
    }
    
    [self addSubview:self.searchBackgroundView];
    [self addSubview:self.searchImageView];
    [self addSubview:self.searchTextField];
    [self.searchTextField becomeFirstResponder];
}

- (void)showClearButton {
    self.searchTextField.text.length  > 0 ? (self.clearBtn.hidden = NO) : (self.clearBtn.hidden = YES);
    [self addSubview:self.clearBtn];
}

- (void)clearTextfield {
    self.clearBtn.hidden = YES;
    self.searchTextField.text = @"";
    if (self.delegate && [self.delegate respondsToSelector:@selector(removeSearchIndexView)]) {
        [self.delegate removeSearchIndexView];
    }
}


// 搜索取消,刷新首页
- (void)backHomeController {
    [self.searchTextField resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(back)]) {
        [self.delegate back];
    }
}

//搜索
- (void)search:(UITextField *)textField {
    //给归档的数组添加一个模型
    [self addHistoryModelWithText:textField.text];
    //归档需要归档的数组
    [self saveHistorySearch];
}

//判断搜索记录是否重复后添加到归档数组
- (void)addHistoryModelWithText:(NSString *)text {
    //    重复的标志
    NSArray * array = [NSArray arrayWithArray: self.historySearchArr];
    BOOL isRepet = NO;
    for (NSString *searchWord in array) {
        if ([searchWord isEqualToString:text]) {
            [self.historySearchArr removeObject:searchWord];
            [self.historySearchArr addObject:text];
            isRepet = YES;
        }
    }
    if (!isRepet) {
        [self.historySearchArr addObject:text];
    }
}

//归档方法
- (void)saveHistorySearch {
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //注：保存文件的扩展名可以任意取，不影响。
    NSString *filePath = [Path stringByAppendingPathComponent:@"historySearch.data"];
    //归档
    [NSKeyedArchiver archiveRootObject:self.historySearchArr toFile:filePath];
}

//历史搜索解档
- (void)readHistorySearch {
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [Path stringByAppendingPathComponent:@"historySearch.data"];
    //解档
    NSMutableArray *personArr = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    self.historySearchArr = [NSMutableArray arrayWithArray:personArr];
    self.historyShowSearchArr = [[self.historySearchArr reverseObjectEnumerator]allObjects];
    if (self.delegate && [self.delegate respondsToSelector:@selector(loadSearchHistory:)]) {
        [self.delegate loadSearchHistory:self.historyShowSearchArr];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self search:textField];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
   
    NSMutableString *searchWord = [[textField.text stringByAppendingString:string] mutableCopy];
    if (self.delegate && [self.delegate respondsToSelector:@selector(loadSearchIndex:)]) {
        if (string.length == 0) {
            [searchWord deleteCharactersInRange:NSMakeRange(searchWord.length - 1, 1)];
        }
        [self.delegate loadSearchIndex:searchWord];
    }
    return YES;
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
        _searchBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.viewWidth - self.backgroundViewWidth, self.viewHeight)];
        _searchBackgroundView.backgroundColor = [UIColor colorWithHexString:@"EAEDF0"];
        _searchBackgroundView.layer.cornerRadius = self.viewHeight / 2;
    }
    return _searchBackgroundView;
}

- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc]init];
        _searchTextField.frame = CGRectMake(CGRectGetMaxX(self.searchImageView.frame) + 10, 5, self.viewWidth - 44 - self.backgroundViewWidth, 20);
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


- (NSMutableArray *)historySearchArr {
    if (!_historySearchArr) {
        _historySearchArr = [NSMutableArray array];
    }
    return _historySearchArr;
}

@end
