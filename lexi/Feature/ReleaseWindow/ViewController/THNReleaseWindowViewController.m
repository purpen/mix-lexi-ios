//
//  THNReleaseWindowViewController.m
//  lexi
//
//  Created by HongpingRao on 2018/11/13.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "THNReleaseWindowViewController.h"
#import "UIView+Helper.h"
#import <YYKit/YYTextView.h>
#import <Masonry/Masonry.h>
#import "THNShopWindowTableViewCell.h"
#import "THNThreeImageStitchingView.h"
#import "THNFiveImagesStitchView.h"
#import "THNSevenImagesStitchView.h"
#import "IQKeyboardManager.h"
#import "THNToolBarView.h"
#import "WBStatusHelper.h"
#import "WBEmoticonInputView.h"
#import "THNSelectWindowProductViewController.h"

@interface THNReleaseWindowViewController () <
YYTextViewDelegate,
YYTextKeyboardObserver,
THNToolBarViewDelegate,
WBStatusComposeEmoticonViewDelegate,
UITextFieldDelegate
>

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *collageButtons;
@property (weak, nonatomic) IBOutlet UIView *postContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *postContenViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *ImageViewStitchingView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewStitchViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *keywordView;
@property (weak, nonatomic) IBOutlet UIButton *addTagButton;
@property (nonatomic, strong) YYTextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBottomConstraint;
@property (nonatomic, assign) ShopWindowImageType imageType;
@property (nonatomic, strong) THNThreeImageStitchingView *threeImageStitchingView;
@property (nonatomic, strong) THNFiveImagesStitchView *fiveImagesStitchingView;
@property (nonatomic, strong) THNSevenImagesStitchView *sevenImagesStitchingView;
@property (nonatomic, strong) THNToolBarView *toolbar;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@end

@implementation THNReleaseWindowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    // 监听键盘
    [[YYTextKeyboardManager defaultManager] addObserver:self];
    [self.view addSubview:self.toolbar];
    self.titleTextField.delegate = self;
    self.toolbar.delegate = self;
    
    self.navigationBarView.title = @"发布橱窗";
    self.navigationBarView.rightButtonTrailing = -20;
    [self.navigationBarView setNavigationRightButtonOfImageNamed:@"icon_release_gray"];
    [self.addTagButton drawCornerWithType:0 radius:13];
    self.scrollViewBottomConstraint.constant = kDeviceiPhoneX ? 34 : 0;
    [self.collageButtons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = obj;
        [btn drawCornerWithType:0 radius:4];
        if (idx == 0) {
            btn.backgroundColor = [UIColor colorWithHexString:@"5FE4B1"];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } else {
            btn.backgroundColor = [UIColor colorWithHexString:@"F5F7F9"];
            [btn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        }
    }];
    
    [self.postContentView addSubview:self.textView];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.trailing.equalTo(self.postContentView).with.offset(-3);
        make.top.equalTo(self.postContentView).with.offset(30);
        make.height.equalTo(@(100));
    }];
    
    self.imageViewStitchViewHeightConstraint.constant = threeImageHeight;
    [self.ImageViewStitchingView addSubview:self.threeImageStitchingView];
    WEAKSELF;
    self.threeImageStitchingView.threeImageBlock = ^(NSInteger index) {
        [weakSelf pushSelectWindowProductVC];
    };
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    // 设置键盘距textView的间距
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;
    keyboardManager.keyboardDistanceFromTextField = 50;
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    self.toolbar.hidden = YES;
}

- (void)layoutInputView {
    WBEmoticonInputView *inputView = [WBEmoticonInputView sharedView];
    inputView.delegate = self;
    _textView.inputView = inputView;
    [_textView reloadInputViews];
    [_textView becomeFirstResponder];
}

- (void)pushSelectWindowProductVC {
    WEAKSELF;
    THNSelectWindowProductViewController *selectProductVC = [[THNSelectWindowProductViewController alloc]init];
    [weakSelf.navigationController pushViewController:selectProductVC animated:YES];
}

- (IBAction)collage:(UIButton *)button {
     WEAKSELF;
   
    for (UIButton *btn in self.collageButtons) {
        btn.backgroundColor = [UIColor colorWithHexString:@"F5F7F9"];
        [btn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    }
    
    self.imageType = [self.collageButtons indexOfObject:button];
    button.backgroundColor = [UIColor colorWithHexString:@"5FE4B1"];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    switch (self.imageType) {
        case ShopWindowImageTypeThree:
            self.fiveImagesStitchingView.hidden = YES;
            self.sevenImagesStitchingView.hidden = YES;
            self.threeImageStitchingView.hidden = NO;
            self.imageViewStitchViewHeightConstraint.constant = threeImageHeight;
//            [self.threeImageStitchingView setThreeImageStitchingView:shopWindowModel.product_covers];
            [self.ImageViewStitchingView addSubview:self.threeImageStitchingView];
            break;
        case ShopWindowImageTypeFive:{
            self.threeImageStitchingView.hidden = YES;
            self.fiveImagesStitchingView.hidden = NO;
            self.imageViewStitchViewHeightConstraint.constant = threeImageHeight + fiveToGrowImageHeight;
            self.fiveImagesStitchingView.fiveImageBlock = ^(NSInteger index) {
                [weakSelf pushSelectWindowProductVC];
            };
            
            [self.ImageViewStitchingView addSubview:self.fiveImagesStitchingView];
            //            [self.fiveImagesStitchingView setFiveImageStitchingView:shopWindowModel.product_covers];
            break;
        }
        case ShopWindowImageTypeSeven:{
            self.sevenImagesStitchingView.hidden = NO;
            self.threeImageStitchingView.hidden = YES;
            self.fiveImagesStitchingView.hidden = YES;
            self.imageViewStitchViewHeightConstraint.constant = threeImageHeight + sevenToGrowImageHeight;
            
            self.sevenImagesStitchingView.sevenImageBlock = ^(NSInteger index) {
                
                [weakSelf pushSelectWindowProductVC];
            };
            
            [self.ImageViewStitchingView addSubview:self.sevenImagesStitchingView];
            //            [self.sevenImagesStitchingView setSevenImageStitchingView:shopWindowModel.product_covers];
            break;
        }
            
    }
}

- (IBAction)addTag:(id)sender {

}

#pragma mark - YYTextViewDelegate
- (void)textViewDidBeginEditing:(YYTextView *)textView {
    self.toolbar.hidden = NO;
    [self.textView reloadInputViews];
    [self.textView becomeFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.toolbar.hidden = NO;
    [textField reloadInputViews];
    [textField becomeFirstResponder];
}

// 动态改变TextView的高度
- (void)textViewDidChange:(YYTextView *)textView {
    CGFloat fltTextHeight = textView.textLayout.textBoundingSize.height;
    textView.scrollEnabled = NO; //必须设置为NO
    
    [UIView performWithoutAnimation:^{
        textView.height = fltTextHeight;
        self.postContenViewHeightConstraint.constant = textView.height + 24;
    }];
}

#pragma mark @protocol YYTextKeyboardObserver
- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition {
    CGRect toFrame = [[YYTextKeyboardManager defaultManager] convertRect:transition.toFrame toView:self.view];
    if (transition.animationDuration == 0) {
        self.toolbar.bottom = CGRectGetMinY(toFrame);
    } else {
        self.toolbar.bottom = CGRectGetMinY(toFrame);
        [UIView animateWithDuration:transition.animationDuration delay:0 options:transition.animationOption | UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.toolbar.bottom = CGRectGetMinY(toFrame);
        } completion:NULL];
    }
}

- (void)dealloc {
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - THNToolBarViewDelegate
- (void)changeKeyboardType:(UIButton *)button {
    if (self.textView.inputView) {
        self.textView.inputView = nil;
        [self.textView reloadInputViews];
        [self.textView becomeFirstResponder];
        
        [button setImage:[WBStatusHelper imageNamed:@"compose_emoticonbutton_background"] forState:UIControlStateNormal];
        [button setImage:[WBStatusHelper imageNamed:@"compose_emoticonbutton_background_highlighted"] forState:UIControlStateHighlighted];
    } else {
        [self layoutInputView];
        [button setImage:[WBStatusHelper imageNamed:@"compose_keyboardbutton_background"] forState:UIControlStateNormal];
        [button setImage:[WBStatusHelper imageNamed:@"compose_keyboardbutton_background_highlighted"] forState:UIControlStateHighlighted];
    }
}

- (void)addComment:(NSString *)text {
    [self.view endEditing:YES];
}

#pragma mark @protocol WBStatusComposeEmoticonView
- (void)emoticonInputDidTapText:(NSString *)text {
    if (text.length) {
        [self.textView replaceRange:self.textView.selectedTextRange withText:text];
    }
}

- (void)emoticonInputDidTapBackspace {
    [self.textView deleteBackward];
}

#pragma mark - lazy
- (YYTextView *)textView {
    if (!_textView) {
        _textView = [[YYTextView alloc]init];
        _textView.placeholderFont = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _textView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _textView.textColor = [UIColor colorWithHexString:@"333333"];
        _textView.placeholderText = @"每个人都是生活美学家，分享你的搭配灵感与故事";
        _textView.delegate = self;
    }
    return _textView;
}

#pragma mark - lazy
- (THNThreeImageStitchingView *)threeImageStitchingView {
    if (!_threeImageStitchingView) {
        _threeImageStitchingView = [THNThreeImageStitchingView viewFromXib];
        _threeImageStitchingView.frame = self.ImageViewStitchingView.bounds;
        _threeImageStitchingView.isContentModeCenter = YES;
    }
    return _threeImageStitchingView;
}

- (THNFiveImagesStitchView *)fiveImagesStitchingView {
    if (!_fiveImagesStitchingView) {
        _fiveImagesStitchingView = [THNFiveImagesStitchView viewFromXib];
        _fiveImagesStitchingView.frame = self.ImageViewStitchingView.bounds;
        _fiveImagesStitchingView.isContentModeCenter = YES;
    }
    return _fiveImagesStitchingView;
}

- (THNSevenImagesStitchView *)sevenImagesStitchingView {
    if (!_sevenImagesStitchingView) {
        _sevenImagesStitchingView = [THNSevenImagesStitchView viewFromXib];
        _sevenImagesStitchingView.frame = self.ImageViewStitchingView.bounds;
        _sevenImagesStitchingView.isContentModeCenter = YES;
    }
    return _sevenImagesStitchingView;
}

- (THNToolBarView *)toolbar {
    if (!_toolbar) {
        _toolbar = [THNToolBarView viewFromXib];
        _toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _toolbar.frame = CGRectMake(0, 1000, self.view.width, 50);
        _toolbar.isNoNeedAddTextView = YES;
    }
    return _toolbar;
}


@end
